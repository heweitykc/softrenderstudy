package com.zam
{
    import flash.events.*;

    public class FileLoadEvent extends Event
    {
        protected var _type:String;
        protected var _url:String;
        protected var _currentBytes:int;
        protected var _totalBytes:int;
        protected var _errorMessage:String;
        public static const LOAD_START:String = "FILE_LOAD_START";
        public static const LOAD_COMPLETE:String = "FILE_LOAD_COMPLETE";
        public static const LOAD_PROGRESS:String = "FILE_LOAD_PROGRESS";
        public static const LOAD_ERROR:String = "FILE_LOAD_ERROR";
        public static const LOAD_SECURITY_ERROR:String = "FILE_LOAD_SECURITY_ERROR";

        public function FileLoadEvent(type:String, url:String, currentBytes:int = -1, totalBytes:int = -1, errorMessage:String = null)
        {
            super(type);
            this._type = type;
            this._url = url;
            this._currentBytes = currentBytes;
            this._totalBytes = totalBytes;
            this._errorMessage = errorMessage;
        }

        public function get url() : String
        {
            return this._url;
        }

        public function get currentBytes() : int
        {
            return this._currentBytes;
        }

        public function get totalBytes() : int
        {
            return this._totalBytes;
        }

        public function get errorMessage() : String
        {
            return this._errorMessage;
        }
    }
}
