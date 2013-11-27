package com.zam
{
    import com.adobe.utils.*;
    import flash.display3D.*;
    import flash.utils.*;

    public class Shader extends Object
    {
        protected var _viewer:Viewer;
        protected var _program:Program3D = null;
        protected var _code:String = "";

        public function Shader(param1:Viewer)
        {
            this._viewer = param1;
            return;
        }// end function

        public function get viewer() : Viewer
        {
            return this._viewer;
        }// end function

        public function get camera() : Camera
        {
            return this._viewer.camera;
        }// end function

        public function get context() : Context3D
        {
            return this._viewer.context;
        }// end function

        public function get program() : Program3D
        {
            if (this._program == null)
            {
                this.upload();
            }
            return this._program;
        }// end function

        protected function _vertexShader() : void
        {
            return;
        }// end function

        protected function _fragmentShader() : void
        {
            return;
        }// end function

        protected function op(param1:String) : void
        {
            this._code = this._code + (param1 + "\n");
            return;
        }// end function

        protected function upload() : void
        {
            var assembler:* = new AGALMiniAssembler(false);
            this._code = "";
            this._vertexShader();
            assembler.assemble("vertex", this._code);
            if (assembler.error)
            {
                return;
            }
            var vertexBytecode:* = assembler.agalcode;
            this._code = "";
            this._fragmentShader();
            assembler.assemble("fragment", this._code);
            if (assembler.error)
            {
                return;
            }
            var fragmentBytecode:* = assembler.agalcode;
            if (this._program != null)
            {
                this._program.dispose();
            }
            this._program = this.context.createProgram();
            try
            {
                this._program.upload(vertexBytecode, fragmentBytecode);
            }
            catch (err:Error)
            {
                return;
            }
            return;
        }// end function

    }
}
