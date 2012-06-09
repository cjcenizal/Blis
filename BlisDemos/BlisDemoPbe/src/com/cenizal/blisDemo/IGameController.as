package com.cenizal.blisDemo
{
	public interface IGameController
	{
		function initialize():void;
		function startWalking( code:int ):void;
		function stopWalking( code:int ):void;
		function shoot():void;
		function stopShooting():void;
		function get count():int;
	}
}