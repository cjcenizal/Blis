/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.animation
{
	public class SpriteSheetCycle
	{
		private var _id:String;
		private var _type:String;
		private var _startFrame:int;
		private var _endFrame:int;
		private var _duration:Number;
		private var _numFrames:Number;
		private var _frameDuration:Number;
		private var _mustComplete:Boolean;
		
		public function SpriteSheetCycle( id:String, type:String, startFrame:int, endFrame:int, duration:Number, mustComplete:Boolean = false )
		{
			_id = id;
			_type = type;
			_startFrame = startFrame;
			_endFrame = endFrame;
			_duration = duration;
			_numFrames = _endFrame - _startFrame + 1;
			_frameDuration = _duration / _numFrames;
			_mustComplete = mustComplete;
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get startFrame():int {
			return _startFrame;
		}
		
		public function get endFrame():int {
			return _endFrame;
		}
		
		public function get duration():Number {
			return _duration;
		}
		
		public function get numFrames():int {
			return _numFrames;
		}
		
		public function get frameDuration():Number {
			return _frameDuration;
		}
		
		public function get mustComplete():Boolean {
			return _mustComplete;
		}
	}
}