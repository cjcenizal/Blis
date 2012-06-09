package com.cenizal.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Label extends Sprite
	{
		private var _text:TextField;
		
		private var _w:Number;
		private var _h:Number;
		
		public function Label( container:DisplayObjectContainer, w:int, h:int, text:String )
		{
			super();
			_w = w;
			_h = h;
			container.addChild( this );
			_text = new TextField();
			addChild( _text );
			_text.x = _text.y = 10;
			_text.width = width - 20;
			_text.wordWrap = _text.multiline = true;
			_text.text = text;
			var format:TextFormat = new TextFormat( "Arial", 12, 0xFFFFFF );
			_text.setTextFormat( format );
			var g:Graphics = this.graphics;
			g.beginFill( 0, .5 );
			g.drawRect( 0, 0, width, height );
			g.endFill();
		}
		
		override public function get width():Number {
			return _w;
		}
		
		override public function get height():Number {
			return _h;
		}
	}
}