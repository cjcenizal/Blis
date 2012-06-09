/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.blis.display
{
	import flash.display.BitmapData;

	public class BlisLayer
	{
		private var _id:String;
		private var _objects:Array;
		private var _mouseCullX:int = 0;
		private var _mouseCullY:int = 0;
		
		public function BlisLayer( id:String )
		{
			_id = id;
			_objects = new Array();
		}
		
		public function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number ):void {
			//var minX:Number = 0;
			var maxX:Number = canvas.width;
			//var minY:Number = 0;
			var maxY:Number = canvas.height;
			var len:int = _objects.length;
			var obj:IBlisDisplayObject;
			var cameraX:Number = ~cameraX + 1;
			var cameraY:Number = ~cameraY + 1;
			var x:Number;
			var y:Number;
			var w:int;
			var h:int;
			for ( var i:int = 0; i < len; i++ ) {
				obj = _objects[ i ] as IBlisDisplayObject;
				obj.update();
				x = obj.x + cameraX;
				y = obj.y + cameraY;
				w = obj.width;
				h = obj.height;
				if ( w == 0 && h == 0 ) {
					obj.draw( canvas, mouseCanvas, cameraX, cameraY, _mouseCullX - w, _mouseCullY - h, _mouseCullX + w, _mouseCullY + h );
				} else {
					if ( x + w > 0 ) {
						if ( x - w < maxX ) {
							if ( y + h > 0 ) {
								if ( y - h < maxY ) {
									obj.draw( canvas, mouseCanvas, cameraX, cameraY, _mouseCullX - w, _mouseCullY - h, _mouseCullX + w, _mouseCullY + h );
								}
							}
						}
					}
				}
			}
		}
		
		public function tick( deltaTime:Number ):void {
			var len:int = _objects.length;
			var obj:IBlisDisplayObject;
			for ( var i:int = 0; i < len; i++ ) {
				obj = _objects[ i ] as IBlisDisplayObject;
				if ( obj.isAnimated ) {
					obj.tick( deltaTime );
				}
			}
			_objects.sortOn( [ "sortVal" ], Array.NUMERIC );
		}
		
		public function add( object:IBlisDisplayObject ):void {
			object.layer = this;
			_objects.push( object );
		}
		
		public function remove( object:IBlisDisplayObject ):void {
			var index:int = _objects.indexOf( object );
			if ( index > -1 ) {
				_objects.splice( index, 1 );
			}
		}
		
		public function getAt( index:int ):IBlisDisplayObject {
			return _objects[ index ];
		}
		
		//===================================
		//		Interaction.
		//===================================
		
		public function setMouseCull( x:int, y:int ):void {
			_mouseCullX = x;
			_mouseCullY = y;
		}
		
		//===================================
		//		Accessors.
		//===================================
		
		public function get id():String {
			return _id;
		}
	}
}