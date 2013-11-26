package com.zam.tor
{
    import com.zam.*;
    import flash.display.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.events.*;
    import flash.net.*;

    public class TorTexture extends Object
    {
        private var _slot:String;
        private var _url:String;
        private var _loaded:Boolean = false;
        private var _failed:Boolean = false;
        private var _viewer:Viewer;
        private var _mesh:TorMesh;
        private var _bitmap:Bitmap;
        private var _texture:Texture;

        public function TorTexture(param1:Viewer, param2:TorMesh, param3:String, param4:String)
        {
            var event:FileLoadEvent;
            var viewer:* = param1;
            var mesh:* = param2;
            var slot:* = param3;
            var url:* = param4;
            this._viewer = viewer;
            this._mesh = mesh;
            this._slot = slot;
            this._url = url;
            var loader:* = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaded, false, 0, true);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress, false, 0, true);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadError, false, 0, true);
            try
            {
                url = url + ".png";
                loader.load(new URLRequest(this._viewer.contentPath + url));
                event = new FileLoadEvent(FileLoadEvent.LOAD_START, this._url);
                this._viewer.dispatchEvent(event);
            }
            catch (ex:Error)
            {
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

        public function get texture() : Texture
        {
            return this._texture;
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
            this._texture = this._viewer.context.createTexture(this._bitmap.width, this._bitmap.height, Context3DTextureFormat.BGRA, false);
            this._texture.uploadFromBitmapData(this._bitmap.bitmapData);
            this._loaded = true;
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE, this._url);
            this._viewer.dispatchEvent(_loc_2);
            this._mesh.onTextureLoaded(this._slot);
            return;
        }// end function

        private function onLoadError(event:IOErrorEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this._url, -1, -1, event.text);
            this._viewer.dispatchEvent(_loc_2);
            this._failed = true;
            this._loaded = true;
            return;
        }// end function

        private function onLoadProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, this._url, event.bytesLoaded, event.bytesTotal);
            this._viewer.dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
