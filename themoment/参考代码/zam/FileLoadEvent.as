﻿package com.zam
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

        public function FileLoadEvent(param1:String, param2:String, param3:int = -1, param4:int = -1, param5:String = null)
        {
            super(param1);
            this._type = param1;
            this._url = param2;
            this._currentBytes = param3;
            this._totalBytes = param4;
            this._errorMessage = param5;
            return;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

        public function get currentBytes() : int
        {
            return this._currentBytes;
        }// end function

        public function get totalBytes() : int
        {
            return this._totalBytes;
        }// end function

        public function get errorMessage() : String
        {
            return this._errorMessage;
        }// end function

    }
}
