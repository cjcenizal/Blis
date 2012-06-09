package com.cenizal.blisDemo.basic
{
	import com.cenizal.animation.SpriteSheet;
	import com.cenizal.animation.SpriteSheetCycle;
	import com.cenizal.blis.BlisSystem;
	import com.cenizal.blisDemo.Building;
	import com.cenizal.blisDemo.Buildings;
	import com.cenizal.blisDemo.IGameController;
	
	import flash.display.BitmapData;

	public class GameController implements IGameController
	{
		
		private var _system:BlisSystem;
		private var _spriteSheetBitmapData:BitmapData;
		private var _overSpriteSheetBitmapData:BitmapData;
		private var _buildings:Buildings;
		private var _count:int = 0;
		
		public function GameController( system:BlisSystem, spriteSheet:BitmapData, overSpriteSheet:BitmapData, buildings:Buildings )
		{
			_system = system;
			_spriteSheetBitmapData = spriteSheet;
			_overSpriteSheetBitmapData = overSpriteSheet;
			_buildings = buildings;
		}
		
		public function initialize():void {
			var dim:int = 32;
			var building:Building;
			var dir:int = 1;
			for ( var i:int = dim * -.5; i < dim * .5; i++ ) {
				var frame:int = 0;
				for ( var j:int = dim * -.5; j < dim * .5; j++ ) {
					building = new Building();
					building.x = i * 31;
					building.y = j * 31;
					_buildings.add( building );
					
					var colorId:String = _system.makeNewObjectId().toString();
					var spriteSheet:SpriteSheet = new SpriteSheet( 9, 1, _spriteSheetBitmapData.width, _spriteSheetBitmapData.height );
					spriteSheet.addCycle( new SpriteSheetCycle( "idle", "pong", 1, 9, .5 ) );
					spriteSheet.offsetX = -60;
					spriteSheet.offsetY = -80;
					spriteSheet.cycle = "idle";
					frame += dir;
					if ( frame > 8 ) {
						dir = -1;
						frame = 7;
					}
					if ( frame < 0 ) {
						dir = 1;
						frame = 1;
					}
					spriteSheet.col = frame;
					var isoBuilding:IsoBuilding = new IsoBuilding( building.id, colorId, _spriteSheetBitmapData, _overSpriteSheetBitmapData, spriteSheet );
					building.view = isoBuilding;
					building.view.isoX = isoBuilding.targetX = building.x;
					building.view.isoY = isoBuilding.targetY = building.y;
					isoBuilding.offsetX = -60;
					isoBuilding.offsetY = -80;
					_system.addObject( isoBuilding, "buildings" );
					
					_count++;
				}
			}
			trace( _count + " objects" );
		}
		
		public function startWalking( code:int ):void {
			
		}
		
		public function stopWalking( code:int ):void {
			
		}
		
		public function shoot():void {
		}
		
		public function stopShooting():void {
		}
		
		public function get count():int {
			return _count;
		}
	}
}