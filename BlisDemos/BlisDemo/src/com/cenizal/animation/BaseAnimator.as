/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.animation
{
	
	public class BaseAnimator
	{
		private static const LOOP:String = AnimationTypes.LOOP;
		private static const PING_PONG:String = AnimationTypes.PING_PONG;
		private static const ONCE:String = AnimationTypes.ONCE;
		private static const NONE:String = AnimationTypes.NONE;
		
		protected var _elapsedTime:Number;
		protected var _numFrames:int;
		protected var _frameDuration:Number;
		protected var _currCol:int = 0;
		protected var _completeCallback:Function;
		protected var _isDone:Boolean = true;
		
		public function BaseAnimator( elapsedTime:Number, numFrames:int, frameDuration:Number ) {
			_elapsedTime = elapsedTime;
			_numFrames = numFrames;
			_frameDuration = frameDuration;
		}
		
		public function tick( deltaTime:Number ):int {
			_elapsedTime += deltaTime;
			return _currCol;
		}
		
		public static function getAnimator( type:String, elapsedTime:Number, numFrames:int, frameDuration:Number ):BaseAnimator {
			switch ( type ) {
				case BaseAnimator.LOOP:
					return new LoopAnimator( elapsedTime, numFrames, frameDuration );
				case BaseAnimator.NONE:
					return new NoneAnimator( elapsedTime, numFrames, frameDuration );
				case BaseAnimator.ONCE:
					return new OnceAnimator( elapsedTime, numFrames, frameDuration );
				case BaseAnimator.PING_PONG:
					return new PongAnimator( elapsedTime, numFrames, frameDuration );
			}
			return null;
		}
		
		public function onCompletePlay( sheet:SpriteSheet, id:String ):void {
			_completeCallback = function():void {
				sheet.cycle = id;
			}
		}
		
		public function get elapsedTime():Number {
			return _elapsedTime;
		}
		
		public function get isDone():Boolean {
			return _isDone;
		}
		
		public function set col( val:int ):void {
			_currCol = ( val < 0 ) ? 0 : ( val > _numFrames - 1 ? _numFrames - 1 : val );
		}
	}
}
