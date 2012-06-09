
package com.cenizal.blisDemo
{
	import com.cenizal.blis.display.BlisDisplayObject;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class Background extends BlisDisplayObject
	{
		private var _boundsWidth:Number;
		private var _boundsHeight:Number;
		
		public function Background( boundsWidth:Number, boundsHeight:Number ) {
			super();
			_boundsWidth = boundsWidth;
			_boundsHeight = boundsHeight;
		}

		override public function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number, mouseCullX:int, mouseCullY:int, mouseCullW:int, mouseCullH:int ):void {
			canvas.fillRect( new Rectangle( cameraX - _boundsWidth * .5, cameraY - _boundsHeight * .5, _boundsWidth, _boundsHeight ), 0xFFAAAAAA );
		}
	}
}
