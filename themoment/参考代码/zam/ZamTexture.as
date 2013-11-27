package com.zam
{
    import flash.display.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.events.*;
    import flash.net.*;

    public class ZamTexture extends Object
    {
        public var url:String;
        private var _loaded:Boolean;
        private var _loading:Boolean;
        private var _failed:Boolean;
        private var _viewer:Viewer;
        private var _bitmap:Bitmap;
        private var _texture:Texture;

        public function ZamTexture(param1:Viewer, param2:String, param3:Boolean = true)
        {
            this._viewer = param1;
            this.url = param2;
            if (param3 && this.url)
            {
                this.load();
            }
            return;
        }// end function

        public function get loaded() : Boolean
        {
            return this._loaded;
        }// end function

        public function get loading() : Boolean
        {
            return this._loading;
        }// end function

        public function get failed() : Boolean
        {
            return this._failed;
        }// end function

        public function get good() : Boolean
        {
            return this._loaded && !this._failed;
        }// end function

        public function get bitmap() : Bitmap
        {
            return this._bitmap;
        }// end function

        public function get texture() : Texture
        {
            return this._texture;
        }// end function

        public function load() : void
        {
            var event:FileLoadEvent;
            if (this._loading)
            {
                return;
            }
            var loader:* = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaded, false, 0, true);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError, false, 0, true);
            try
            {
                this._loading = true;
                loader.load(new URLRequest(this._viewer.contentPath + this.url));
                event = new FileLoadEvent(FileLoadEvent.LOAD_START, this.url);
                this._viewer.dispatchEvent(event);
            }
            catch (ex:Error)
            {
                _loading = false;
            }
            return;
        }// end function

        public function refresh() : void
        {
            if (this._texture)
            {
                this._texture.dispose();
            }
            if (this._bitmap)
            {
                this._texture = this._viewer.context.createTexture(this._bitmap.width, this._bitmap.height, Context3DTextureFormat.BGRA, false);
                this._texture.uploadFromBitmapData(this._bitmap.bitmapData);
            }
            return;
        }// end function

        private function onLoaded(event:Event) : void
        {
            this._bitmap = event.target.content;
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE, this.url);
            this._viewer.dispatchEvent(_loc_2);
            this._texture = this._viewer.context.createTexture(this._bitmap.width, this._bitmap.height, Context3DTextureFormat.BGRA, false);
            this._texture.uploadFromBitmapData(this._bitmap.bitmapData);
            this._loaded = true;
            this._loading = false;
            return;
        }// end function

        private function onLoadError(event:IOErrorEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this.url, -1, -1, event.text);
            this._viewer.dispatchEvent(_loc_2);
            this._failed = true;
            this._loaded = true;
            this._loading = false;
            return;
        }// end function

        private function onLoadProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, this.url, event.bytesLoaded, event.bytesTotal);
            this._viewer.dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
