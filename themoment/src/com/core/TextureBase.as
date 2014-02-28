package com.core 
{
	import flash.display.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.events.*;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author callee
	 */
	public class TextureBase 
	{
		public var ok:Boolean = false;
		
		protected var context3D:Context3D;
		private var _bitmap:Bitmap;
        private var _texture:Texture;
		public function TextureBase(context3d:Context3D)
		{
			this.context3D = context3d;
		}
		
		public function load(url:String):void
		{
			 var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaded, false, 0, true);
			loader.load(new URLRequest(url));
		}
		
		private function onLoaded(event:Event) : void
        {
			_bitmap = event.target.content;
            _texture = context3D.createTexture(this._bitmap.width, this._bitmap.height, Context3DTextureFormat.BGRA,false);
            _texture.uploadFromBitmapData(_bitmap.bitmapData);
			ok = true;
        }
		
		public function get texture():Texture 
		{
			return _texture;
		}
	}

}