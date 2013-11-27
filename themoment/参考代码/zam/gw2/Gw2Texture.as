package com.zam.gw2
{
    import com.zam.*;
    import flash.display.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class Gw2Texture extends Object
    {
        public var _url:String;
        private var _alphaUrl:String;
        private var _loaded:Boolean;
        private var _failed:Boolean;
        private var _viewer:Viewer;
        private var _mesh:Gw2Model;
        private var _rgbBitmap:Bitmap;
        private var _alphaBitmap:Bitmap;
        private var _rgbaData:ByteArray;
        private var _width:uint;
        private var _height:uint;
        private var _texture:Texture;
        private var _index:int;
        private var _type:int;
        public static const DIFFUSE:int = 1;
        public static const NORMAL:int = 2;
        public static const LIGHTMAP:int = 3;

        public function Gw2Texture(param1:Gw2Model, param2:int, param3:String, param4:int = 1)
        {
            var rgbLoader:Loader;
            var alphaLoader:Loader;
            var event:FileLoadEvent;
            var mesh:* = param1;
            var index:* = param2;
            var url:* = param3;
            var type:* = param4;
            this._mesh = mesh;
            this._index = index;
            this._type = type;
            this._url = url;
            if (url)
            {
                this._alphaUrl = url.replace(".png", ".a.png");
                rgbLoader = new Loader();
                rgbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onRgbLoaded, false, 0, true);
                rgbLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress, false, 0, true);
                rgbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError, false, 0, true);
                alphaLoader = new Loader();
                alphaLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onAlphaLoaded, false, 0, true);
                alphaLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onAlphaLoadProgress, false, 0, true);
                alphaLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onAlphaLoadError, false, 0, true);
                try
                {
                    rgbLoader.load(new URLRequest(this._mesh.viewer.contentPath + "textures/" + this._url));
                    alphaLoader.load(new URLRequest(this._mesh.viewer.contentPath + "textures/" + this._alphaUrl));
                    event = new FileLoadEvent(FileLoadEvent.LOAD_START, this._url);
                    this._mesh.viewer.dispatchEvent(event);
                }
                catch (ex:Error)
                {
                }
            }
            return;
        }// end function

        public function get loaded() : Boolean
        {
            return this._loaded;
        }// end function

        public function get failed() : Boolean
        {
            return this._failed;
        }// end function

        public function get good() : Boolean
        {
            return this._loaded && !this._failed;
        }// end function

        public function get texture() : Texture
        {
            return this._texture;
        }// end function

        public function refresh() : void
        {
            this.uploadTexture();
            return;
        }// end function

        public function uploadTexture() : void
        {
            if (!this.good)
            {
                return;
            }
            if (this._texture)
            {
                this._texture.dispose();
            }
            this._texture = this._mesh.context.createTexture(this._width, this._height, Context3DTextureFormat.BGRA, false);
            this._texture.uploadFromByteArray(this._rgbaData, 0);
            return;
        }// end function

        private function createBlankAlpha() : Bitmap
        {
            var _loc_1:* = new Bitmap(new BitmapData(this._rgbBitmap.width, this._rgbBitmap.height, false, 4294967295));
            return _loc_1;
        }// end function

        private function onRgbLoaded(event:Event) : void
        {
            this._rgbBitmap = event.target.content;
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE, this._url);
            this._mesh.viewer.dispatchEvent(_loc_2);
            if (this._failed)
            {
                this._failed = false;
                this._alphaBitmap = this.createBlankAlpha();
            }
            if (this._alphaBitmap != null)
            {
                this.onLoaded();
            }
            return;
        }// end function

        private function onAlphaLoaded(event:Event) : void
        {
            this._alphaBitmap = event.target.content;
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE, this._alphaUrl);
            this._mesh.viewer.dispatchEvent(_loc_2);
            if (this._rgbBitmap != null)
            {
                this.onLoaded();
            }
            return;
        }// end function

        private function onLoaded(param1:Boolean = true) : void
        {
            var _loc_2:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            if (this._texture)
            {
                this._texture.dispose();
                this._texture = null;
            }
            var _loc_3:* = this._rgbBitmap.bitmapData;
            var _loc_4:* = this._alphaBitmap.bitmapData;
            this._width = _loc_3.width;
            this._height = _loc_3.height;
            this._rgbaData = new ByteArray();
            this._rgbaData.length = this._width * this._height * 4;
            this._rgbaData.endian = Endian.LITTLE_ENDIAN;
            _loc_3.lock();
            _loc_4.lock();
            _loc_6 = 0;
            while (_loc_6 < this._height)
            {
                
                _loc_5 = 0;
                while (_loc_5 < this._width)
                {
                    
                    _loc_2 = _loc_3.getPixel(_loc_5, _loc_6);
                    _loc_2 = _loc_2 | _loc_4.getPixel(_loc_5, _loc_6) << 24;
                    this._rgbaData.writeUnsignedInt(_loc_2);
                    _loc_5++;
                }
                _loc_6++;
            }
            _loc_3.unlock();
            _loc_4.unlock();
            _loc_3.dispose();
            _loc_4.dispose();
            this._rgbBitmap = null;
            this._alphaBitmap = null;
            this._loaded = true;
            this.uploadTexture();
            if (param1)
            {
                this._mesh.onTextureLoaded(this, this._type, this._index);
            }
            return;
        }// end function

        private function onAlphaLoadError(event:IOErrorEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE, this._alphaUrl);
            this._mesh.viewer.dispatchEvent(_loc_2);
            if (this._rgbBitmap != null)
            {
                this._alphaBitmap = this.createBlankAlpha();
                this.onLoaded();
            }
            return;
        }// end function

        private function onLoadError(event:IOErrorEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this._url, -1, -1, event.text);
            this._mesh.viewer.dispatchEvent(_loc_2);
            this._failed = true;
            this._loaded = true;
            return;
        }// end function

        private function onAlphaLoadProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, this._alphaUrl, event.bytesLoaded, event.bytesTotal);
            this._mesh.viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onLoadProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, this._url, event.bytesLoaded, event.bytesTotal);
            this._mesh.viewer.dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
