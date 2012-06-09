package com.cenizal.blisDemo.pbe
{
	import flash.display.BitmapData;

	public class SoldierController extends BlisController
	{
		private var _isWalking:Boolean = false;
		private var _isShooting:Boolean = false;
		private var _moveX:Number = 0;
		private var _moveY:Number = 0;
		private var _walkLeft:Boolean = false;
		private var _walkRight:Boolean = false;
		private var _walkUp:Boolean = false;
		private var _walkDown:Boolean = false;
		private var _speed:Number = 4;
		private var _diagSpeed:Number = 5.65;

		public function SoldierController( id:String, colorId:String, w:int, h:int ) {
			super( id, colorId, w, h );
			isAnimated = true;
		}

		override public function tick( deltaTime:Number ):void {
			if ( _isWalking ) {
				isoX += _moveX;
				isoY += _moveY;
			}
			( owner as BlisGameObject ).renderer.tick( deltaTime );
		}

		override public function draw( canvas:BitmapData, mouseCanvas:BitmapData, cameraX:Number, cameraY:Number, mouseCullX:int, mouseCullY:int, mouseCullW:int, mouseCullH:int ):void {
			( owner as BlisGameObject ).renderer.draw( isOver, color, x, y, canvas, mouseCanvas, cameraX, cameraY, mouseCullX, mouseCullY, mouseCullW, mouseCullH );
		}

		public function walkRight( val:Boolean ):void {
			if ( _walkRight != val ) {
				_walkRight = val;
				updateWalk();
			}
		}

		public function walkDown( val:Boolean ):void {
			if ( _walkDown != val ) {
				_walkDown = val;
				updateWalk();
			}
		}

		public function walkLeft( val:Boolean ):void {
			if ( _walkLeft != val ) {
				_walkLeft = val;
				updateWalk();
			}
		}

		public function walkUp( val:Boolean ):void {
			if ( _walkUp != val ) {
				_walkUp = val;
				updateWalk();
			}
		}

		private function updateWalk():void {
			if ( _walkRight || _walkDown || _walkLeft || _walkUp ) {
				_isWalking = true;
				if ( ( owner as BlisGameObject ).renderer.cycle != "walk" ) {
					( owner as BlisGameObject ).renderer.cycle = "walk";
				}
				if ( _walkRight ) {
					if ( _walkUp ) {
						( owner as BlisGameObject ).renderer.direction = 315;
						_moveX = 0;
						_moveY = -_speed;
					} else if ( _walkDown ) {
						( owner as BlisGameObject ).renderer.direction = 45;
						_moveX = _speed;
						_moveY = 0;
					} else {
						( owner as BlisGameObject ).renderer.direction = 0;
						_moveX = _diagSpeed;
						_moveY = -_diagSpeed;
					}
				} else if ( _walkLeft ) {
					if ( _walkUp ) {
						( owner as BlisGameObject ).renderer.direction = 225;
						_moveX = -_speed;
						_moveY = 0;
					} else if ( _walkDown ) {
						( owner as BlisGameObject ).renderer.direction = 135;
						_moveX = 0;
						_moveY = _speed;
					} else {
						( owner as BlisGameObject ).renderer.direction = 180;
						_moveX = -_diagSpeed;
						_moveY = _diagSpeed;
					}
				} else if ( _walkUp ) {
					( owner as BlisGameObject ).renderer.direction = 270;
					_moveX = -_diagSpeed;
					_moveY = -_diagSpeed;
				} else if ( _walkDown ) {
					( owner as BlisGameObject ).renderer.direction = 90;
					_moveX = _diagSpeed;
					_moveY = _diagSpeed;
				}
			} else {
				_isWalking = false;
				( owner as BlisGameObject ).renderer.cycle = "idle";
			}
		}

		public function shoot():void {
			_isShooting = true;
			if ( ( owner as BlisGameObject ).renderer.cycle != "fire" ) {
				( owner as BlisGameObject ).renderer.cycle = "fire";
			}
		}

		public function stopShooting():void {
			_isShooting = false;
			( owner as BlisGameObject ).renderer.cycle = "idle";
		}

		public function set speed( val:Number ):void {
			_speed = val;
			_diagSpeed = _speed * .5;
		}
	}
}
