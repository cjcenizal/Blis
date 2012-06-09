/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.animation
{
	public class PongAnimator extends BaseAnimator
	{
		private var _dir:int = 1;
		
		public function PongAnimator( elapsedTime:Number, numFrames:int, frameDuration:Number ) {
			super( elapsedTime, numFrames, frameDuration );
		}

		override public function tick( deltaTime:Number ):int {
			super.tick( deltaTime );
			if ( _elapsedTime >= _frameDuration ) {
				if ( _currCol == 0 )
				{
					_dir = 1;
				}
				else if ( _currCol >= _numFrames - 1 )
				{
					_dir = -1;
				}
				_currCol += _dir;
				_elapsedTime = 0;
			}
			if ( _currCol > _numFrames - 1 ) {
				trace(_currCol);
			}
			return _currCol;
		}
	}
}
