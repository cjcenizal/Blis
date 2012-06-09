package com.cenizal.blisDemo.pbe
{
	import com.cenizal.animation.SpriteSheet;
	import com.cenizal.animation.SpriteSheetCycle;
	import com.cenizal.blis.BlisSystem;
	import com.cenizal.blisDemo.Building;
	import com.cenizal.blisDemo.Buildings;
	import com.cenizal.blisDemo.IGameController;
	import com.cenizal.blisDemo.Resources;
	import com.pblabs.core.PBGroup;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class PbeGameController extends PBGroup implements IGameController
	{
		private static const DIRECTIONS:Object = {
			39: "RIGHT",
			40: "DOWN",
			37: "LEFT",
			38: "UP"
		};
		
		private static const DOWN_STATES:Object = {
			39: false,
			40: false,
			37: false,
			38: false
		};
		
		private var _system:BlisSystem;
		private var _spriteSheetBitmapData:BitmapData;
		private var _overSpriteSheetBitmapData:BitmapData;
		private var _buildings:Buildings;
		
		private var _soldier:BlisGameObject;
		
		private var _count:int = 0;
		
		public function PbeGameController( system:BlisSystem, spriteSheet:BitmapData, overSpriteSheet:BitmapData, buildings:Buildings ) {
			super();
			_system = system;
			_spriteSheetBitmapData = spriteSheet;
			_overSpriteSheetBitmapData = overSpriteSheet;
			_buildings = buildings;
		}
		
		public override function initialize():void
		{
			super.initialize();
			
			var dim:int = 32;
			var building:Building;
			var dir:int = 1;
			for ( var i:int = dim * -.5; i < dim * .5; i++ ) {
				var frame:int = 0;
				for ( var j:int = dim * -.5; j < dim * .5; j++ ) {
					
					building = new Building();
					building.x = i * 31;
					building.y = j * 31;
					_buildings.add( building );
					
					var colorId:String = _system.makeNewObjectId().toString();
					var spriteSheet:SpriteSheet = new SpriteSheet( 9, 1, _spriteSheetBitmapData.width, _spriteSheetBitmapData.height );
					spriteSheet.addCycle( new SpriteSheetCycle( "idle", "pong", 1, 9, .5 ) );
					spriteSheet.offsetX = -60;
					spriteSheet.offsetY = -80;
					
					var controller:BuildingController = new BuildingController( building.id, colorId, spriteSheet.frameWidth, spriteSheet.frameHeight );
					var renderer:BlisSpriteSheetRenderer = new BlisSpriteSheetRenderer( _spriteSheetBitmapData, _overSpriteSheetBitmapData, spriteSheet );
					renderer.cycle = "idle";
					frame += dir;
					if ( frame > 8 ) {
						dir = -1;
						frame = 7;
					}
					if ( frame < 0 ) {
						dir = 1;
						frame = 1;
					}
					renderer.frame = frame;
					controller.isoX = controller.targetX = building.x;
					controller.isoY = controller.targetY = building.y;
					
					var gameObject:BlisGameObject = new BlisGameObject();
					gameObject.owningGroup = this;
					gameObject.controller = controller;
					gameObject.renderer = renderer;
					gameObject.initialize();
					
					building.view = controller;
					_system.addObject( controller, "buildings" );
					
					_count++;
				}
			}
			
			var bitmapData:BitmapData = ( new Resources.SoldierImage() as Bitmap ).bitmapData;
			var spriteSheet:SpriteSheet = new SpriteSheet( 7, 4, bitmapData.width, bitmapData.height );
			spriteSheet.addCycle( new SpriteSheetCycle( "idle", "none", 1, 1, 1 ) );
			spriteSheet.addCycle( new SpriteSheetCycle( "fire", "once", 2, 3, .25, true ) );
			spriteSheet.addCycle( new SpriteSheetCycle( "walk", "pong", 4, 7, .2 ) );
			spriteSheet.offsetX = -40;
			spriteSheet.offsetY = -50;
			
			var soldierController:SoldierController = new SoldierController( "soldier", _system.makeNewObjectId().toString(), spriteSheet.frameWidth, spriteSheet.frameHeight );
			soldierController.speed = 4;
			soldierController.isoX = -550;
			var soldierRenderer:BlisSpriteSheetRenderer = new BlisSpriteSheetRenderer( bitmapData, bitmapData, spriteSheet );
			soldierRenderer.cycle = "idle";
			_soldier = new BlisGameObject();
			_soldier.owningGroup = this;
			_soldier.controller = soldierController;
			_soldier.renderer = soldierRenderer;
			_soldier.initialize();
			_system.addObject( soldierController, "buildings" );
			
			trace(_count + " objects");
		}
		
		public function startWalking( code:int ):void {
			if ( !DOWN_STATES[ code ] ) {
				DOWN_STATES[ code ] = true;
				switch ( DIRECTIONS[ code ] ) {
					case "RIGHT":
						( _soldier.controller as SoldierController ).walkRight( true );
						break;
					case "DOWN":
						( _soldier.controller as SoldierController ).walkDown( true );
						break;
					case "LEFT":
						( _soldier.controller as SoldierController ).walkLeft( true );
						break;
					case "UP":
						( _soldier.controller as SoldierController ).walkUp( true );
						break;
				}
			}
		}
		
		public function stopWalking( code:int ):void {
			DOWN_STATES[ code ] = false;
			switch ( DIRECTIONS[ code ] ) {
				case "RIGHT":
					( _soldier.controller as SoldierController ).walkRight( false );
					break;
				case "DOWN":
					( _soldier.controller as SoldierController ).walkDown( false );
					break;
				case "LEFT":
					( _soldier.controller as SoldierController ).walkLeft( false );
					break;
				case "UP":
					( _soldier.controller as SoldierController ).walkUp( false );
					break;
			}
		}
		
		public function shoot():void {
			( _soldier.controller as SoldierController ).shoot();
		}
		
		public function stopShooting():void {
			( _soldier.controller as SoldierController ).stopShooting();
		}
		
		public function get soldier():BlisGameObject {
			return _soldier;
		}
		
		public function get count():int {
			return _count;
		}
	}
}