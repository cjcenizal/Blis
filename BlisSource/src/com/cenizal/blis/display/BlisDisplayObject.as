/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.blis.display
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class BlisDisplayObject implements IBlisDisplayObject
	{
		protected var _id:String;
		protected var _colorId:String;
		protected var _color:uint;
		
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _width:int = 0;
		protected var _height:int = 0;
		protected var _isoX:Number = 0;
		protected var _isoY:Number = 0;
		protected var _alpha:Number = 1;
		
		protected var _isAnimated:Boolean = false;
		protected var _isOver:Boolean = false;
		
		private var _layer:BlisLayer;
		private var _isoToScreenX:Function;
		private var _isoToScreenY:Function;
		private var _destroyCallback:Function;
		
		// Invalidation.
		private var _isInvalidatedPosition:Boolean = false;
		
		// Sorting.
		private var _sortOffsetY:Number = 0;
		private var _sortVal:Number = 0;
		
		public function BlisDisplayObject( id:String = null, colorId:String = null )
		{
			_id = id;
			_colorId = colorId;
			_color = uint( colorId );
		}
		
		public function update():void {
			if ( isInvalidatedPosition ) {
				_isInvalidatedPosition = false;
				_x = _isoToScreenX( _isoX, _isoY );
				_y = _isoToScreenY( _isoX, _isoY );
				_sortVal = ( y << 17 ) + x;
			}
		}
		
		public function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number, mouseCullX:int, mouseCullY:int, mouseCullW:int, mouseCullH:int ):void {
		}
		
		public function destroy():void {
			if ( _layer ) {
				_layer.remove( this );
			}
			if ( _destroyCallback ) {
				_destroyCallback( this )
			}
			_isoToScreenX = null;
			_isoToScreenY = null;
			_destroyCallback = null;
		}
		
		//===================================
		//		Time.
		//===================================
		
		public function tick( deltaTime:Number ):void {
		}
		
		//===================================
		//		Mouse.
		//===================================
		
		public function over():void {
			_isOver = true;
		}
		
		public function out():void {
			_isOver = false;
		}
		
		//===================================
		//		Injecting functionality.
		//===================================
		
		public function setIsoToScreenX( func:Function ):void {
			_isoToScreenX = func;
		}
		
		public function setIsoToScreenY( func:Function ):void {
			_isoToScreenY = func;
		}
		
		public function setDestroyCallback( func:Function ):void {
			_destroyCallback = func;
		}
		
		//===================================
		//		Accessors.
		//===================================
		
		public function get id():String {
			return _id;
		}
		
		public function get colorId():String {
			return _colorId;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set layer( layer:BlisLayer ):void {
			_layer = layer;
		}
		
		public function set isoX( val:Number ):void {
			if ( _isoX != val ) {
				_isoX = val;
				_isInvalidatedPosition = true;
			}
		}
		
		public function set isoY( val:Number ):void {
			if ( _isoY != val ) {
				_isoY = val;
				_isInvalidatedPosition = true;
			}
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function get isoX():Number {
			return _isoX;
		}
		
		public function get isoY():Number {
			return _isoY;
		}
		
		public function get isInvalidatedPosition():Boolean {
			return _isInvalidatedPosition;
		}
		
		public function get isAnimated():Boolean {
			return _isAnimated;
		}
		
		public function set isAnimated( val:Boolean ):void {
			_isAnimated = val;
		}
		
		public function get isOver():Boolean {
			return _isOver;
		}
		
		public function get sortVal():Number {
			return _sortVal;
		}
		
		public function get alpha():Number {
			return _alpha;
		}
		
		public function set alpha( val:Number ):void {
			_alpha = val;
		}
		
		public function get width():int {
			return _width;
		}
		
		public function get height():int {
			return _height;
		}
	}
}