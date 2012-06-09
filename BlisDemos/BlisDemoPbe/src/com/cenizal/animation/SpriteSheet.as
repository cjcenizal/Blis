/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.animation
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SpriteSheet
	{	
		// Animation.
		protected var _numCols:int;
		protected var _numRows:int;
		protected var _frameDuration:Number;
		protected var _frameWidth:int;
		protected var _frameHeight:int;
		
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		private var _cycles:Object;
		
		// State.
		protected var _currCol:int = 0;
		protected var _currRow:int;
		protected var _currCycle:SpriteSheetCycle;
		protected var _animator:BaseAnimator;
		
		// Cache.
		private var _frameRect:Rectangle;
		private var _framePoint:Point;
		
		public function SpriteSheet( numCols:int, numRows:int, bitmapWidth:Number, bitmapHeight:Number ) {
			_numCols = numCols;
			_numRows = numRows;
			_frameWidth = bitmapWidth / numCols;
			_frameHeight = bitmapHeight / numRows;
			_cycles = new Object();
			_frameRect = new Rectangle();
			_framePoint = new Point();
			_frameRect.width = _frameWidth;
			_frameRect.height = _frameHeight;
		}
		
		public function destroy():void {
			_frameRect = null;
			_framePoint = null;
			_currCycle = null;
			_animator = null;
			_cycles = null;
		}
		
		public function addCycle( cycle:SpriteSheetCycle ):void {
			_cycles[ cycle.id ] = cycle;
		}
		
		public function tick( deltaTime:Number ):void {
			if ( _animator ) {
				_currCol = _animator.tick( deltaTime ) + _currCycle.startFrame - 1;
			}
		}
		
		public function getFrameRect():Rectangle {
			_frameRect.x = _currCol * _frameWidth;
			_frameRect.y = _currRow * _frameHeight;
			return _frameRect;
		}
		
		public function getFramePoint( x:Number, y:Number, cameraX:Number, cameraY:Number ):Point {
			_framePoint.x = x + cameraX + offsetX;
			_framePoint.y = y + cameraY + offsetY;
			return _framePoint;
		}
		
		public function set row( val:int ):void {
			_currRow = val;
		}
		
		public function set col( val:int ):void {
			_currCol = val;
			_animator.col = val;
		}
		
		public function get row():int {
			return _currRow;
		}
		
		public function set cycle( id:String ):void {
			if ( !_animator || _animator.isDone || !_currCycle.mustComplete ) {
				_currCycle = _cycles[ id ];
				_frameDuration = _currCycle.frameDuration; 
				var elapsed:Number = ( _animator ) ? _animator.elapsedTime : 0;
				_animator = BaseAnimator.getAnimator( _currCycle.type, elapsed, _currCycle.numFrames, _currCycle.frameDuration );
			} else if ( _animator ) {
				_animator.onCompletePlay( this, id );
			}
		}
		
		public function get cycle():String {
			if ( _currCycle ) {
				return _currCycle.id;
			}
			return null;
		}
		
		public function get numRows():int {
			return _numRows;
		}
		
		public function get frameWidth():int {
			return _frameWidth;
		}
		
		public function get frameHeight():int {
			return _frameHeight;
		}
	}
}
