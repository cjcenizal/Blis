/**
 * Copyright (C) 2011 by CJ Cenizal
 * Use this code to do whatever you want, just don't claim it as your own, because I wrote it. Not you!
 */
package com.cenizal.blis.display
{
	import flash.display.BitmapData;

	public interface IBlisDisplayObject
	{
		function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number, mouseCullX:int, mouseCullY:int, mouseCullX2:int, mouseCullY2:int ):void;
		function update():void;
		function tick( detlaTime:Number ):void;
		function setIsoToScreenX( val:Function ):void;
		function setIsoToScreenY( val:Function ):void;
		function setDestroyCallback( val:Function ):void;
		function get isAnimated():Boolean;
		function get colorId():String;
		function set layer( layer:BlisLayer ):void;
		function get x():Number;
		function get y():Number;
		function get sortVal():Number;
		function get isoX():Number;
		function get isoY():Number;
		function set isoX( val:Number ):void;
		function set isoY( val:Number ):void;
		function get alpha():Number;
		function set alpha( val:Number ):void;
		function get width():int;
		function get height():int;
	}
}