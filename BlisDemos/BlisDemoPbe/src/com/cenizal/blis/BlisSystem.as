/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.blis
{
	import com.cenizal.blis.display.BlisLayers;
	import com.cenizal.blis.display.IBlisDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class BlisSystem extends Sprite
	{
		// Screen coords.
		private var _screenCoordOffsetX:Number = 0;
		private var _screenCoordOffsetY:Number = 0;
		
		// Objects.
		private var _objects:Object = new Object();
		
		// Bounds.
		private var _boundsWidth:int = 0;
		private var _boundsHeight:int = 0;
		private var _boundsMaxX:Number = 0;
		private var _boundsMinX:Number = 0;
		private var _boundsMaxY:Number = 0;
		private var _boundsMinY:Number = 0;
		
		// Validation.
		private var _cameraSizeIsDirty:Boolean = false;
		private var _zoomIsDirty:Boolean = false;
		
		// Canvas.
		private var _canvas:Bitmap;
		private var _canvasData:BitmapData;
		private var _layers:BlisLayers;
		
		// Camera.
		private var _baseViewPortWidth:int = 0;
		private var _baseViewPortHeight:int = 0;
		private var _viewPortWidth:int = 0;
		private var _viewPortHeight:int = 0;
		private var _cameraX:Number = 0;
		private var _cameraY:Number = 0;
		private var _cameraOffsetX:Number = 0; // Places origin in center of view port.
		private var _cameraOffsetY:Number = 0; // Places origin in center of view port.
		private var _zoom:Number = 1;
		
		// Interaction.
		private var _currId:int = 1;
		private var _mouseCanvas:Bitmap;
		private var _mouseCanvasData:BitmapData;
		
		public function BlisSystem( cameraWidth:int, cameraHeight:int, boundsWidth:int, boundsHeight:int ) {
			super();
			_baseViewPortWidth = _viewPortWidth = cameraWidth;
			_baseViewPortHeight = _viewPortHeight = cameraHeight;
			_boundsWidth = boundsWidth;
			_boundsHeight = boundsHeight;
			
			_canvasData = new BitmapData( _baseViewPortWidth, _baseViewPortHeight );
			_canvas = new Bitmap( _canvasData );
			addChild( _canvas );
			
			_mouseCanvasData = new BitmapData( _baseViewPortWidth, _baseViewPortHeight );
			_mouseCanvas = new Bitmap( _mouseCanvasData );
			addChild( _mouseCanvas );
			_mouseCanvas.visible = false;
			
			_layers = new BlisLayers();
			
			updateBounds();
			updateCameraOffset();
		}

		public function reset():void {
			_layers.reset();
		}
		
		//===================================
		//		Objects.
		//===================================
		
		public function addObject( object:IBlisDisplayObject, layerId:String ):void {
			if ( _objects[ object.colorId ] ) {
				trace(this, "addObject COLLISION AT " + object.colorId);
			}
			object.setIsoToScreenX( isoToFlatX );
			object.setIsoToScreenY( isoToFlatY );
			object.setDestroyCallback( destroyObject );
			_objects[ object.colorId ] = object;
			_layers.addObject( object, layerId );
		}
		
		public function getObjectAt( x:int, y:int ):IBlisDisplayObject {
			x /= _zoom;
			y /= _zoom;
			var val:String = _mouseCanvasData.getPixel( x, y ).toString( 16 );
			while ( val.length < 6 ) { val = "0" + val; }
			var colorId:String = "0xFF" + val;
			return _objects[ colorId ];
		}
		
		private function destroyObject( object:IBlisDisplayObject ):void {
			if ( _objects[ object.colorId ] ) {
				delete _objects[ object.colorId ];
			}
		}
		
		public function makeNewObjectId():String {
			var val:String = _currId.toString( 16 );
			while ( val.length < 6 ) { val = "0" + val; }
			var newId:String = "0xFF" + val;
			_currId += 1;
			return newId;
		}
		
		public function addLayer( id:String ):void {
			_layers.addWithId( id );
		}
		
		//===================================
		//		Interaction.
		//===================================
		
		public function setMouseCull( x:int, y:int ):void {
			_layers.setMouseCull( x / _zoom + _cameraX, y / _zoom + _cameraY );
		}
		
		//===================================
		//		Camera controls.
		//===================================
		
		public function moveCamera( x:Number, y:Number ):void {
			_cameraX += x / _zoom;
			_cameraY += y / _zoom;
			clampCameraToBounds();
			updateCameraOffset();
		}
		
		public function moveCameraTo( isoX:Number, isoY:Number ):void {
			var x:Number = isoX - isoY;
			var y:Number = isoX + ( isoY >> 1 );
			_cameraX = x;
			_cameraY = y;
			updateCameraOffset();
		}
		
		public function setCameraSize( w:int, h:int ):void {
			_baseViewPortWidth = w;
			_baseViewPortHeight = h;
			_cameraSizeIsDirty = true;
		}
		
		public function set zoom( val:Number ):void {
			if ( _zoom != val ) {
				_zoom = val;
				_zoomIsDirty = true;
			}
		}
		
		public function get zoom():Number {
			return _zoom;
		}
		
		public function get cameraX():int {
			return _cameraX;
		}
		
		public function get cameraY():int {
			return _cameraY;
		}
		
		//===================================
		//		Camera.
		//===================================
		
		private function updateCameraSize():void {
			_viewPortWidth = _baseViewPortWidth / _zoom;
			_viewPortHeight = _baseViewPortHeight / _zoom;
			if ( _viewPortWidth < 0 ) _viewPortWidth = 1;
			if ( _viewPortHeight < 0 ) _viewPortHeight = 1;
			if ( _viewPortWidth < 8191 && _viewPortHeight < 8191 && ( _viewPortWidth * _viewPortHeight ) < 16777215 ) {
				_canvasData.dispose();
				_canvasData = new BitmapData( _viewPortWidth, _viewPortHeight );
				_canvas.bitmapData = _canvasData;
				_mouseCanvasData.dispose();
				_mouseCanvasData = new BitmapData( _viewPortWidth, _viewPortHeight );
				_mouseCanvas.bitmapData = _mouseCanvasData;
			}
			_viewPortWidth = _canvasData.width;
			_viewPortHeight = _canvasData.height;
			updateBounds();
			updateCameraOffset();
			clampCameraToBounds();
			_cameraSizeIsDirty = false;
		}
		
		private function updateBounds():void {
			if ( _viewPortWidth < _boundsWidth ) {
				_boundsMinX = ( _viewPortWidth - _boundsWidth ) * .5;
				_boundsMaxX = ( _boundsWidth - _viewPortWidth ) * .5;
			} else {
				_boundsMinX = ( _boundsWidth - _viewPortWidth ) * _zoom;
				_boundsMaxX = ( _viewPortWidth - _boundsWidth ) * _zoom;
			}
			if ( _viewPortHeight < _boundsHeight ) {
				_boundsMinY = ( _viewPortHeight - _boundsHeight ) * .5;
				_boundsMaxY = ( _boundsHeight - _viewPortHeight ) * .5;
			} else {
				_boundsMinY = ( _boundsHeight - _viewPortHeight ) * _zoom;
				_boundsMaxY = ( _viewPortHeight - _boundsHeight ) * _zoom;
			}
		}
		
		private function clampCameraToBounds():void {
			if ( _cameraX < _boundsMinX ) _cameraX = _boundsMinX;
			else if ( _cameraX > _boundsMaxX ) _cameraX = _boundsMaxX;
			if ( _cameraY < _boundsMinY ) _cameraY = _boundsMinY;
			else if ( _cameraY > _boundsMaxY ) _cameraY = _boundsMaxY;
		}
		
		private function updateCameraOffset():void {
			_cameraOffsetX = _cameraX - ( _viewPortWidth >> 1 );
			_cameraOffsetY = _cameraY - ( _viewPortHeight >> 1 )
		}
		
		private function updateZoom():void {
			if ( _zoom < .01 ) {
				_zoom = .01;
			}
			_canvas.scaleX = _canvas.scaleY = _zoom;
			_mouseCanvas.scaleX = _mouseCanvas.scaleY = _zoom;
			_zoomIsDirty = false;
			_cameraSizeIsDirty = true;
		}
		
		//===================================
		//		Time.
		//===================================
		
		public function onTick( deltaTime:Number ):void {
			_layers.tick( deltaTime );
			draw();
		}
		
		public function draw():void {
			if ( _zoomIsDirty ) {
				updateZoom();
			}
			if ( _cameraSizeIsDirty ) {
				updateCameraSize();
			}
			_canvasData.lock();
			_mouseCanvasData.lock();
			_canvasData.fillRect( _canvasData.rect, 0 );
			_mouseCanvasData.fillRect( _mouseCanvasData.rect, 0 );
			_layers.draw( _canvasData, _mouseCanvasData, _cameraOffsetX, _cameraOffsetY );
			_canvasData.unlock();
			_mouseCanvasData.unlock();
		}
		
		//===================================
		//		Space.
		//===================================
		
		public function screenToIso( x:Number, y:Number ):Point {
			var x:Number = x / _zoom + _cameraOffsetX;
			var y:Number = y / _zoom + _cameraOffsetY;
			return new Point( y + ( x >> 1 ), ( ( ~x + 1 ) >> 1 ) + y );
		}
		
		public function isoToDisplay( isoX:Number, isoY:Number ):Point {
			var pos:Point = isoToFlat( isoX, isoY );
			pos.x *= _zoom;
			pos.y *= _zoom;
			pos.x += stage.stageWidth * .5 - _cameraX * _zoom;
			pos.y += stage.stageHeight * .5 - _cameraY * _zoom;
			return pos;
		}
		
		private function isoToFlat( isoX:Number, isoY:Number ):Point {
			return new Point( isoToFlatX( isoX, isoY ), isoToFlatY( isoX, isoY ) );
		}
		
		private function isoToFlatX( isoX:Number, isoY:Number ):Number {
			return isoX - isoY;
		}
		
		private function isoToFlatY( isoX:Number, isoY:Number ):Number {
			return ( isoX + isoY ) >> 1;
		}
		
		//===================================
		//		Debugging.
		//===================================
		
		public function set debugMouseCanvas( val:Boolean ):void {
			_mouseCanvas.visible = val;
		}
		
		public function get debugMouseCanvas():Boolean {
			return _mouseCanvas.visible;
		}
	}
}
