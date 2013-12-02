package com.zam
{

    public class Mesh extends Shader
    {
        protected var _contentPath:String;
        protected var _params:Object;

        public function Mesh(path:String, viewer:Viewer, param3:Object)
        {
            super(viewer);
            this._contentPath = path;
            this._params = param3;
        }

        public function get contentPath() : String
        {
            return this._contentPath;
        }

        public function get params() : Object
        {
            return this._params;
        }

        public function registerExternalInterface() : void
        {
            
        }

        public function load(param1:int, param2:String, param3:int = -1, param4:int = -1) : void
        {
            
        }

        public function update(param1:Number) : void
        {
           
        }

        public function render(param1:Number, param2:Boolean = true) : void
        {
            
        }

        public function refresh():void
        {
            
        }
    }
}
