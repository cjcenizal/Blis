package com.cenizal.blisDemo
{
	public class Building
	{
		private static var count:int = 0;
		
		private var _id:String;
		public var x:Number = 0;
		public var y:Number = 0;
		public var view:IIsoBuilding;
		
		public function Building()
		{
			_id = "building" + count.toString();
			count++;
		}
		
		public function get id():String {
			return _id;
		}
	}
}