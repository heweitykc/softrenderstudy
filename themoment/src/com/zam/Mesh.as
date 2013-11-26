package com.zam
{

    public class Mesh extends Shader
    {
        protected var _contentPath:String;
        protected var _params:Object;

        public function Mesh(param1:String, param2:Viewer, param3:Object)
        {
            super(param2);
            this._contentPath = param1;
            this._params = param3;
            return;
        }// end function

        public function get contentPath() : String
        {
            return this._contentPath;
        }// end function

        public function get params() : Object
        {
            return this._params;
        }// end function

        public function registerExternalInterface() : void
        {
            return;
        }// end function

        public function load(param1:int, param2:String, param3:int = -1, param4:int = -1) : void
        {
            return;
        }// end function

        public function update(param1:Number) : void
        {
            return;
        }// end function

        public function render(param1:Number, param2:Boolean = true) : void
        {
            return;
        }// end function

        public function refresh() : void
        {
            return;
        }// end function

    }
}
