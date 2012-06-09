/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.animation
{

	public class LoopAnimator extends BaseAnimator
	{
		public function LoopAnimator( elapsedTime:Number, numFrames:int, frameDuration:Number ) {
			super( elapsedTime, numFrames, frameDuration );
		}

		override public function tick( deltaTime:Number ):int {
			super.tick( deltaTime );
			if ( _elapsedTime >= _frameDuration ) {
				_currCol++;
				if ( _currCol >= _numFrames ) {
					_currCol = 0;
				}
				_elapsedTime = 0;
			}
			return _currCol;
		}
	}
}
