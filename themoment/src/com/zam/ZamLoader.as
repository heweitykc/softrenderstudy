package com.zam
{
    import flash.events.*;
    import flash.net.*;

    public class ZamLoader extends URLLoader
    {
        protected var _request:URLRequest;

        public function ZamLoader(param1:URLRequest = null)
        {
            this._request = param1;
            super(param1);
            addEventListener(Event.COMPLETE, this.loadComplete);
            addEventListener(ProgressEvent.PROGRESS, this.loadProgress);
            addEventListener(IOErrorEvent.IO_ERROR, this.loadIOError);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loadSecurityError);
            
        }

        public function get request() : URLRequest
        {
            return this._request;
        }

        override public function load(param1:URLRequest) : void
        {
            this._request = param1;
            super.load(param1);
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_START, param1.url);
            dispatchEvent(_loc_2);
            
        }

        private function loadComplete(event:Event) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE, this.request.url);
            dispatchEvent(_loc_2);
            
        }

        private function loadProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, this.request.url, event.bytesLoaded, event.bytesTotal);
            dispatchEvent(_loc_2);
            
        }

        private function loadIOError(event:IOErrorEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this.request.url, -1, -1, event.text);
            dispatchEvent(_loc_2);
            
        }

        private function loadSecurityError(event:SecurityErrorEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_SECURITY_ERROR, this.request.url, -1, -1, event.text);
            dispatchEvent(_loc_2);
            
        }

    }
}
