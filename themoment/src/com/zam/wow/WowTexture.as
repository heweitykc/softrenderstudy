package com.zam.wow
{
    import com.zam.*;
    import flash.display.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class WowTexture extends Object
    {
        public var _url:String;
        public var _fakeAlpha:Boolean;
        private var _alphaUrl:String;
        private var _loaded:Boolean;
        private var _failed:Boolean;
        private var _viewer:Viewer;
        private var _mesh:WowModel;
        public var _rgbBitmap:Bitmap;
        public var _alphaBitmap:Bitmap;
        private var _compositeBitmap:Bitmap;
        private var _texture:Texture;
        private var _index:int;
        private var _type:int;
        public static const NORMAL:int = 1;
        public static const SPECIAL:int = 2;
        public static const BAKED:int = 3;
        public static const ARMOR:int = 4;

        public function WowTexture(param1:WowModel, param2:int, param3:String, param4:int = 1)
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
                this._alphaUrl = url.replace(".png", ".alpha.png");
                rgbLoader = new Loader();
                rgbLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onRgbLoaded, false, 0, true);
                rgbLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress, false, 0, true);
                rgbLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError, false, 0, true);
                rgbLoader.contentLoaderInfo.addEventListener("securityError", this.onLoadError, false, 0, true);
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

        public function get composite() : Bitmap
        {
            if (!this._compositeBitmap)
            {
                this.generateComposite();
            }
            return this._compositeBitmap;
        }// end function

        public function refresh() : void
        {
            this.onLoaded(false);
            return;
        }// end function

        public function copyFromTexture(param1:WowTexture) : void
        {
            this._rgbBitmap = new Bitmap(param1._rgbBitmap.bitmapData.clone());
            this._alphaBitmap = new Bitmap(param1._alphaBitmap.bitmapData.clone());
            return;
        }// end function

        public function drawTexture(param1:WowTexture, param2:int) : void
        {
            var _loc_3:* = null;
            if (this._rgbBitmap.width == this._rgbBitmap.height)
            {
                _loc_3 = WowModel.TextureRegions[param2];
            }
            else
            {
                _loc_3 = WowModel.NewTextureRegions[param2];
            }
            var _loc_4:* = new Matrix();
            _loc_4.scale(this._rgbBitmap.width / (param1._rgbBitmap.width / _loc_3[2]), this._rgbBitmap.height / (param1._rgbBitmap.height / _loc_3[3]));
            _loc_4.translate(this._rgbBitmap.width * _loc_3[0], this._rgbBitmap.height * _loc_3[1]);
            this._rgbBitmap.bitmapData.draw(param1.composite.bitmapData, _loc_4, null, BlendMode.NORMAL);
            return;
        }// end function

        public function uploadTexture() : void
        {
            this.onLoaded();
            return;
        }// end function

        private function generateComposite() : Bitmap
        {
            var _loc_1:* = this._rgbBitmap.width;
            var _loc_2:* = this._rgbBitmap.height;
            var _loc_3:* = new BitmapData(_loc_1, _loc_2, true, 4294967295);
            var _loc_4:* = new Rectangle(0, 0, _loc_1, _loc_2);
            var _loc_5:* = new Point(0, 0);
            _loc_3.copyPixels(this._rgbBitmap.bitmapData, _loc_4, _loc_5);
            _loc_3.copyChannel(this._alphaBitmap.bitmapData, _loc_4, _loc_5, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
            this._compositeBitmap = new Bitmap(_loc_3);
            return this._compositeBitmap;
        }// end function

        private function createBlankAlpha() : Bitmap
        {
            this._fakeAlpha = true;
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
            var _loc_7:* = _loc_3.width;
            var _loc_8:* = _loc_3.height;
            var _loc_9:* = new ByteArray();
            _loc_9.length = _loc_7 * _loc_8 * 4;
            _loc_9.endian = Endian.LITTLE_ENDIAN;
            _loc_3.lock();
            _loc_4.lock();
            _loc_6 = 0;
            while (_loc_6 < _loc_8)
            {
                
                _loc_5 = 0;
                while (_loc_5 < _loc_7)
                {
                    
                    _loc_2 = _loc_3.getPixel(_loc_5, _loc_6);
                    _loc_2 = _loc_2 | _loc_4.getPixel(_loc_5, _loc_6) << 24;
                    _loc_9.writeUnsignedInt(_loc_2);
                    _loc_5++;
                }
                _loc_6++;
            }
            _loc_3.unlock();
            _loc_4.unlock();
            this._texture = this._mesh.context.createTexture(this._rgbBitmap.width, this._rgbBitmap.height, Context3DTextureFormat.BGRA, false);
            this._texture.uploadFromByteArray(_loc_9, 0);
            this._loaded = true;
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
            else
            {
                this._failed = true;
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
