/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.animation
{

	public class NoneAnimator extends BaseAnimator
	{
		public function NoneAnimator( elapsedTime:Number, numFrames:int, frameDuration:Number ) {
			super( elapsedTime, numFrames, frameDuration );
		}

		override public function tick( deltaTime:Number ):int {
			return _currCol;
		}
	}
}
