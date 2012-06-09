package com.cenizal.blisDemo.pbe
{
	import com.cenizal.animation.SpriteSheet;
	import com.pblabs.core.PBComponent;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BlisSpriteSheetRenderer extends PBComponent
	{
		private static var _alphaPoint:Point;
		
		private var _bitmapData:BitmapData;
		private var _overBitmapData:BitmapData;
		private var _spriteSheet:SpriteSheet;
		private var _alphaData:BitmapData;
		
		private var _alpha:Number = 1;
		private var _direction:Number = 0;
		
		public function BlisSpriteSheetRenderer( bitmapData:BitmapData, overBitmapData:BitmapData, spriteSheet:SpriteSheet )
		{
			super();
			_bitmapData = bitmapData;
			_overBitmapData = overBitmapData;
			_spriteSheet = spriteSheet;
			_alphaData = new BitmapData( _spriteSheet.frameWidth, _spriteSheet.frameHeight, true, 0 );
			_alphaData.fillRect( _alphaData.rect, pctToHex( _alpha ) );
			if ( !_alphaPoint ) _alphaPoint = new Point();
		}
		
		public function draw( isOver:Boolean, color:uint, x:Number, y:Number, canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number, mouseCullX:int, mouseCullY:int, mouseCullX2:int, mouseCullY2:int ):void {
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
		
		public function tick( deltaTime:Number ):void {
			_spriteSheet.tick( deltaTime );
		}
		
		override protected function onRemove():void {
			_bitmapData = null;
			_overBitmapData = null;
			_spriteSheet.destroy();
			_spriteSheet = null;
			_alphaData.dispose();
			_alphaData = null;
			super.onRemove();
		}
		
		public function set cycle( id:String ):void {
			_spriteSheet.cycle = id;
		}
		
		public function get cycle():String {
			return _spriteSheet.cycle;
		}
		
		public function set direction( angle:Number ):void {
			if ( _direction != angle ) {
				_direction = angle;
				_spriteSheet.row = angle / 360 * _spriteSheet.numRows;
			}
		}
		
		public function set frame( val:int ):void {
			_spriteSheet.col = val;
		}
		
		public function set alpha( val:Number ):void {
			if ( val != _alpha ) {
				_alpha = val;
				_alphaData.fillRect( _alphaData.rect, pctToHex( val ) );
			}
		}
		
		public function get alpha():Number {
			return _alpha;
		}
		
		private static function pctToHex( val:Number ):uint {
			val = int( val * 255 );
			var str:String = val.toString( 16 );
			return uint( "0x" + str + "000000" );
		}
	}
}