package com.cenizal.blisDemo.pbe
{
	import com.cenizal.blisDemo.IIsoBuilding;
	
	import flash.display.BitmapData;

	public class BuildingController extends BlisController implements IIsoBuilding
	{
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		// AI.
		public var targetX:int = 0;
		public var targetY:int = 0;
		
		// State.
		private var _isDragging:Boolean = false;
		
		public function BuildingController( id:String, colorId:String, w:int, h:int ) {
			super( id, colorId, w, h );
			isAnimated = true;
		}
		
		override public function update():void {
			if ( !_isDragging ) {
				if ( Math.floor( targetX - _isoX ) == 0 && Math.floor( targetY - _isoY ) == 0 ) {
				} else {
					isoX += Math.round( ( targetX - _isoX ) * .05 );
					isoY += Math.round( ( targetY - _isoY ) * .05 );
				}
			}
			super.update();
		}
		
		override public function tick(deltaTime:Number):void {
			( owner as BlisGameObject ).renderer.tick( deltaTime );
		}
		
		public function setNewTarget( range:int ):void {
			targetX = Math.random() * range - range * .5;
			targetY = Math.random() * range - range * .5;
		}
		
		public function setTarget( x:Number, y:Number ):void {
			targetX = x;
			targetY = y;
		}
		
		override public function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number, mouseCullX:int, mouseCullY:int, mouseCullW:int, mouseCullH:int ):void {
			( owner as BlisGameObject ).renderer.draw( _isOver, _color, _x, _y, canvas, mouseCanvas, cameraX, cameraY, mouseCullX, mouseCullY, mouseCullW, mouseCullH );
		}
		
		public function get isDragging():Boolean {
			return _isDragging;
		}
		
		public function set isDragging( val:Boolean ):void {
			_isDragging = val;
		}
		
		override public function set alpha( val:Number ):void {
			super.alpha = val;
			( owner as BlisGameObject ).renderer.alpha = _alpha;
		}
	}
}
