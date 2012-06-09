/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.blis.display
{
	import flash.display.BitmapData;

	public class BlisLayers
	{
		private var _isMoved:Boolean = false;
		
		// View.
		private var _layers:Array;
		private var _layersObj:Object;

		public function BlisLayers() {
			_layers = new Array();
			_layersObj = new Object();
		}

		public function reset():void {
			for ( var id:String in _layersObj ) {
				delete _layersObj[ id ];
			}
			_layersObj = new Object();
		}
		
		public function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number ):void {
			var len:int = _layers.length;
			for ( var i:int = 0; i < len; i++ ) {
				getAt( i ).draw( canvas, mouseCanvas, cameraX, cameraY );
			}
		}
		
		public function tick( deltaTime:Number ):void {
			var len:int = _layers.length;
			for ( var i:int = 0; i < len; i++ ) {
				getAt( i ).tick( deltaTime );
			}
		}
		
		//===================================
		//		Objects.
		//===================================
		
		public function addObject( object:IBlisDisplayObject, layerId:String ):void {
			getWithId( layerId ).add( object );
		}
		
		//===================================
		//		Interaction.
		//===================================
		
		public function setMouseCull( x:int, y:int ):void {
			var len:int = _layers.length;
			for ( var i:int = 0; i < len; i++ ) {
				getAt( i ).setMouseCull( x, y );
			}
		}
		
		//===================================
		//		Layers.
		//===================================

		public function addWithId( id:String ):void {
			if ( !_layersObj[ id ] ) {
				var layer:BlisLayer = new BlisLayer( id );
				_layersObj[ id ] = layer;
				_layers.push( layer );
			}
		}

		public function getWithId( id:String ):BlisLayer {
			return _layersObj[ id ];
		}
		
		public function getAt( index:int ):BlisLayer {
			return _layers[ index ];
		}
	}
}
