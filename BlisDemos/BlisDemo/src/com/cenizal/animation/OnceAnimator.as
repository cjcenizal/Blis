/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.animation
{
	public class OnceAnimator extends BaseAnimator
	{
		public function OnceAnimator( elapsedTime:Number, numFrames:int, frameDuration:Number ) {
			super( elapsedTime, numFrames, frameDuration );
			_isDone = false;
		}

		override public function tick( deltaTime:Number ):int {
			if ( !_isDone ) {
				super.tick( deltaTime );
				if ( _elapsedTime >= _frameDuration ) {
					_currCol++;
					if ( _currCol >= _numFrames ) {
						_isDone = true;
						_currCol = _numFrames - 1;
					}
					_elapsedTime = 0;
				}
			} else {
				if ( _completeCallback ) {
					_completeCallback();
				}
			}
			return _currCol;
		}
	}
}
