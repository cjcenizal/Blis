package com.cenizal.blisDemo
{
	public class Buildings
	{
		private var _buildings:Array;
		
		public function Buildings()
		{
			_buildings = new Array();
		}
		
		public function add( building:Building ):void {
			_buildings.push( building );
		}
		
		public function get count():int {
			return _buildings.length;
		}
		
		public function getAt( i:int ):Building {
			return _buildings[ i ];
		}
	}
}