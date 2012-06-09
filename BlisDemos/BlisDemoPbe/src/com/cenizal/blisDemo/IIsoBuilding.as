package com.cenizal.blisDemo
{
	import com.cenizal.blis.display.IBlisDisplayObject;

	public interface IIsoBuilding extends IBlisDisplayObject
	{
		function setNewTarget( range:int ):void;
		function out():void;
		function over():void;
		function get isDragging():Boolean;
		function set isDragging( val:Boolean ):void;
		function setTarget( x:Number, y:Number ):void;
	}
}