package com.cenizal.blisDemo.basic
{
	import com.cenizal.animation.SpriteSheet;
	import com.cenizal.blis.display.BlisDisplayObject;
	import com.cenizal.blisDemo.IIsoBuilding;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class IsoBuilding extends BlisDisplayObject implements IIsoBuilding
	{
		private static var _alphaPoint:Point;
		
		// Mouse.
		private var _bitmapData:BitmapData;
		private var _overBitmapData:BitmapData;
		private var _spriteSheet:SpriteSheet;
		private var _alphaData:BitmapData;
		
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		// AI.
		public var targetX:int = 0;
		public var targetY:int = 0;
		
		// State.
		private var _isDragging:Boolean = false;
		
		public function IsoBuilding( id:String, colorId:String, bitmapData:BitmapData, overBitmapData:BitmapData, spriteSheet:SpriteSheet ) {
			super( id, colorId );
			_bitmapData = bitmapData;
			_overBitmapData = overBitmapData;
			_spriteSheet = spriteSheet;
			_alphaData = new BitmapData( _spriteSheet.frameWidth, _spriteSheet.frameHeight, true, 0 );
			_alphaData.fillRect( _alphaData.rect, pctToHex( _alpha ) );
			if ( !_alphaPoint ) _alphaPoint = new Point();
			_width = _spriteSheet.frameWidth;
			_height = _spriteSheet.frameHeight;
			isAnimated = true;
		}
		
		override public function destroy():void {
			_spriteSheet.destroy();
			_spriteSheet = null;
			_bitmapData = null;
			_overBitmapData = null;
			_alphaData.dispose();
			_alphaData = null;
			super.destroy();
		}
		
		override public function tick( deltaTime:Number ):void {
			_spriteSheet.tick( deltaTime );
		}
		
		override public function update():void {
			if ( !isDragging ) {
				if ( Math.floor( targetX - isoX ) == 0 && Math.floor( targetY - isoY ) == 0 ) {
				} else {
					isoX += Math.round( ( targetX - isoX ) * .05 );
					isoY += Math.round( ( targetY - isoY ) * .05 );
				}
			}
			super.update();
		}
		
		public function setNewTarget( range:int ):void {
			targetX = Math.random() * range - range * .5;
			targetY = Math.random() * range - range * .5;
		}
		
		public function setTarget( x:Number, y:Number ):void {
			targetX = x;
			targetY = y;
		}
		
		override public function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number, mouseCullX:int, mouseCullY:int, mouseCullX2:int, mouseCullY2:int ):void {
			var rect:Rectangle = _spriteSheet.getFrameRect();
			var point:Point = _spriteSheet.getFramePoint( x, y, cameraX, cameraY );
			if ( _alpha > 0 ) {
				if ( isOver ) {
					if ( _alpha < 1 ) {
						canvas.copyPixels( _overBitmapData, rect, point, _alphaData, _alphaPoint, true );
					} else {
						canvas.copyPixels( _overBitmapData, rect, point, null, null, true );
					}
				} else {
					if ( _alpha < 1 ) {
						canvas.copyPixels( _bitmapData, rect, point, _alphaData, _alphaPoint, true );
					} else {
						canvas.copyPixels( _bitmapData, rect, point, null, null, true );
					}
				}
				if ( x > mouseCullX ) {
					if ( x < mouseCullX2 ) {
						if ( y > mouseCullY ) {
							if ( y < mouseCullY2 ) {
								mouseCanvas.threshold( _bitmapData, rect, point, ">", 0x00000000, color, 0xFFFFFF, false );
							}
						}
					}
				}
			}
		}
		
		public function get isDragging():Boolean {
			return _isDragging;
		}
		
		public function set isDragging( val:Boolean ):void {
			_isDragging = val;
		}
		
		override public function set alpha(val:Number):void {
			if ( _alpha != val ) {
				super.alpha = val;
				_alphaData.fillRect( _alphaData.rect, pctToHex( _alpha ) );
			}
		}
		
		private static function pctToHex( val:Number ):uint {
			val = int( val * 255 );
			var str:String = val.toString( 16 );
			return uint( "0x" + str + "000000" );
		}
	}
}
