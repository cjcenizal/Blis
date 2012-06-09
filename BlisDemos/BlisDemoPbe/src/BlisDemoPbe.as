package
{
	import com.cenizal.blis.BlisSystem;
	import com.cenizal.blis.display.IBlisDisplayObject;
	import com.cenizal.blisDemo.Background;
	import com.cenizal.blisDemo.Buildings;
	import com.cenizal.blisDemo.IGameController;
	import com.cenizal.blisDemo.IIsoBuilding;
	import com.cenizal.blisDemo.Resources;
	import com.cenizal.blisDemo.pbe.PbeGameController;
	import com.cenizal.ui.Label;
	import com.pblabs.core.PBGroup;
	import com.pblabs.property.PropertyManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import net.hires.debug.Stats;
	
	public class BlisDemoPbe extends Sprite
	{
		// Isometric system.
		private var _system:BlisSystem;
		
		// Dragging.
		private var _prevX:int = 0;
		private var _prevY:int = 0;
		
		// Animation.
		private var _lastTimer:int = 0;
		
		// Interaction.
		private var _isDraggingMode:Boolean = false;
		private var _overObject:IIsoBuilding;
		private var _draggingObject:IIsoBuilding;
		private var _isMouseDown:Boolean = false;
		
		// UI.
		private var _label:Label;
		private var _soldierLabel:Label;
		
		// Objects.
		private var _buildings:Buildings;
		
		// PBE.
		private var _rootGroup:PBGroup = new PBGroup();
		private var _gameController:IGameController;
		
		public function BlisDemoPbe() {
			super();
			_buildings = new Buildings();
			addEventListener( Event.ADDED_TO_STAGE, onAdded );
		}
		
		private function onAdded( e:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAdded );
			
			// Set our stage.
			stage.frameRate = 30;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Set up Blis.
			_system = new BlisSystem( stage.stageWidth, stage.stageHeight, 2002, 1402 );
			addChild( _system );
			_system.addLayer( "bg" );
			_system.addLayer( "shadows" );
			_system.addLayer( "buildings" );
			
			// Add a boring gray background.
			var bg:Background = new Background( 2000, 1400 );
			bg.isoX = bg.isoY = 0;
			_system.addObject( bg, "bg" );
			
			// Set up our bitmap data for the blocks.
			var spriteSheet:BitmapData = ( new Resources.BuildingImage() as Bitmap ).bitmapData;
			var overSpriteSheet:BitmapData = new BitmapData( spriteSheet.width, spriteSheet.height );
			overSpriteSheet.applyFilter( spriteSheet, spriteSheet.rect, new Point(), new GlowFilter( 0xFF0000, 1, 10, 10, 40, 1, false, false ) );
			
			// Toggle between using PBE v2 to compose game objects out of the Blis base classes,
			// or just using the Blis base classes by themselves.
			_rootGroup.initialize();
			_rootGroup.name = "BlisDemoGroup";
			_rootGroup.registerManager( PropertyManager, new PropertyManager() );
			_gameController = new PbeGameController( _system, spriteSheet, overSpriteSheet, _buildings );
			( _gameController as PbeGameController ).owningGroup = _rootGroup;
			_gameController.initialize();
			
			// Set up our initial frame.
			_system.moveCameraTo( 0, 0 );
			_system.draw();
			
			// Add stats and label.
			addChild( new Stats() );
			_label = new Label( this, 400, 100, "Currently showing " + _gameController.count.toString() + " blocks."
				+ " Click on an empty area to rearrange the blocks."
				+ " Click a block to select it."
				+ " Click and drag to move the map."
				+ " Mouse wheel zooms."
				+ " Hit tab to see color coding of the game objects."
				+ " Use arrow keys to move the soldier, and hit space bar to shoot." );
			_label.x = 10;
			_label.y = stage.stageHeight - _label.height - 10;
			
			_soldierLabel = new Label( this, 70, 30, "Soldier" );
			positionSoldierLabel();
			
			// Event handlers.
			stage.addEventListener( Event.ENTER_FRAME, onTick );
			stage.addEventListener( Event.RESIZE, onResize );
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		}
		
		private function onMouseDown( e:MouseEvent ):void {
			_isMouseDown = true;
			_prevX = mouseX;
			_prevY = mouseY;
		}
		
		private function onMouseUp( e:MouseEvent ):void {
			if ( !_isDraggingMode ) {
				if ( _draggingObject ) {
					_draggingObject.setTarget( _draggingObject.isoX, _draggingObject.isoY );
					_draggingObject.isDragging = false;
					_draggingObject.alpha = 1;
					_draggingObject.out();
					_draggingObject = null;
				} else {
					_draggingObject = _overObject;
					_overObject = null;
					if ( _draggingObject ) {
						_draggingObject.isDragging = true;
						_draggingObject.alpha = .5;
					} else {
						var len:int = _buildings.count;
						for ( var i:int = 0; i < len; i++ ) {
							_buildings.getAt( i ).view.setNewTarget( 1200 );
						}
					}
				}
			}
			_isDraggingMode = false;
			_isMouseDown = false;
		}
		
		private function onMouseMove( e:MouseEvent ):void {
			if ( _isMouseDown ) {
				_isDraggingMode = true;
			}
			if ( _isDraggingMode ) {
				_system.moveCamera( _prevX - mouseX, _prevY - mouseY );
				_prevX = mouseX;
				_prevY = mouseY;
			} else {
				if ( _draggingObject ) {
					var pos:Point = _system.screenToIso( mouseX, mouseY );
					_draggingObject.isoX = pos.x;
					_draggingObject.isoY = pos.y;
				} else {
					var obj:IBlisDisplayObject = _system.getObjectAt( mouseX, mouseY );
					if ( obj && obj is IIsoBuilding ) {
						if ( _overObject && obj != _overObject ) {
							_overObject.out();
						}
						if ( obj != _overObject ) {
							_overObject = obj as IIsoBuilding;
							_overObject.over();
						}
					} else {
						if ( _overObject ) {
							_overObject.out();
							_overObject = null;
						}
					}
				}
			}
			var mx:int = stage.mouseX - stage.stageWidth * .5;
			var my:int = stage.mouseY - stage.stageHeight * .5;
			_system.setMouseCull( mx, my );
		}
		
		private function onMouseWheel( e:MouseEvent ):void {
			if ( e.delta > 0 ) {
				_system.zoom += .05;
			} else if ( e.delta < 0 ) {
				_system.zoom -= .05;
			}
		}
		
		private function onTick( e:Event = null ):void {
			var currentTime:int = getTimer();
			var deltaTime:Number = ( currentTime - _lastTimer ) * 0.001;
			_lastTimer = currentTime;
			_system.onTick( deltaTime );
			positionSoldierLabel();
		}
		
		private function onResize( e:Event ):void {
			_system.setCameraSize( stage.stageWidth, stage.stageHeight );
			_label.y = stage.stageHeight - _label.height - 10;
		}
		
		private function onKeyDown( e:KeyboardEvent ):void {
			switch ( e.keyCode ) {
				case 9: // Tab
					_system.debugMouseCanvas = !_system.debugMouseCanvas;
					break;
				case 32: // Space
					_gameController.shoot();
					break;
				default:
					_gameController.startWalking( e.keyCode );
			}
		}
		
		private function onKeyUp( e:KeyboardEvent ):void {
			switch ( e.keyCode ) {
				case 32: // Space
					_gameController.stopShooting();
					break;
				default:
					_gameController.stopWalking( e.keyCode );
			}
		}
		
		private function positionSoldierLabel():void {
			if ( _gameController is PbeGameController ) {
				var controller:IBlisDisplayObject = ( _gameController as PbeGameController ).soldier.controller;
				var pos:Point = _system.isoToDisplay( controller.isoX, controller.isoY );
				_soldierLabel.x = pos.x - 20;
				_soldierLabel.y = pos.y - 80;
			}
		}
	}
}
