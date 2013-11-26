package com.zam.wildstar
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.display3D.*;
    import flash.utils.*;

    public class WildstarMesh extends Shader
    {
        public var _show:Boolean;
        public var _indexStart:int;
        public var _vertexStart:int;
        public var _indexCount:int;
        public var _vertexCount:int;
        public var _textureIndex:int;
        public var _meshId:int;
        protected var _vb:VertexBuffer3D;
        protected var _ib:IndexBuffer3D;
        protected var _colorTexture:WildstarTexture;
        protected var _hasTexture:Boolean;
        protected var _model:WildstarModel;

        public function WildstarMesh(param1:WildstarModel)
        {
            super(param1.viewer);
            this._model = param1;
            return;
        }// end function

        public function refresh() : void
        {
            if (this._vb)
            {
                this._vb.dispose();
                this._vb = null;
            }
            if (this._ib)
            {
                this._ib.dispose();
                this._ib = null;
            }
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            op("m44 op, va0, vc0");
            op("mov v0, va2");
            op("m44 v1, va1, vc4");
            return;
        }// end function

        override protected function _fragmentShader() : void
        {
            if (this._hasTexture)
            {
                op("tex ft0, v0.xy, fs0 <2d, linear, mip, repeat>");
            }
            else
            {
                op("mov ft0.xy, v0.xy");
                op("mov ft0.zw, fc0.xy");
            }
            op("mov ft1, fc4");
            op("nrm ft2.xyz, v1.xyz");
            op("dp3 ft3, ft2.xyz, fc1.xyz");
            op("max ft3, ft3, fc0.x");
            op("mul ft4, ft3, fc5.rgb");
            op("add ft1.rgb, ft1.rgb, ft4.rgb");
            op("dp3 ft3, ft2.xyz, fc2.xyz");
            op("max ft3, ft3, fc0.x");
            op("mul ft4, ft3, fc6.rgb");
            op("add ft1.rgb, ft1.rgb, ft4.rgb");
            op("dp3 ft3, ft2.xyz, fc3.xyz");
            op("max ft3, ft3, fc0.x");
            op("mul ft4, ft3, fc6.rgb");
            op("add ft1.rgb, ft1.rgb, ft4.rgb");
            op("mul oc, ft0, ft1");
            return;
        }// end function

        public function render() : void
        {
            if (!this._colorTexture)
            {
                if (this._textureIndex > -1 && this._model._textureMap[this._textureIndex] !== undefined)
                {
                    this._colorTexture = this._model._textures[this._model._textureMap[this._textureIndex].color];
                }
            }
            if (!this._hasTexture && this._model._texture)
            {
                this._hasTexture = true;
                upload();
            }
            else if (this._colorTexture && !this._model._texture)
            {
                if (!this._colorTexture.loaded && !this._colorTexture.loading)
                {
                    this._colorTexture.load();
                }
                else if (this._colorTexture.loaded && !this._hasTexture)
                {
                    this._hasTexture = true;
                    upload();
                }
            }
            this.updateBuffers();
            if (this._hasTexture)
            {
                if (this._model._texture)
                {
                    context.setTextureAt(0, this._model._texture.texture);
                }
                else
                {
                    context.setTextureAt(0, this._colorTexture.texture);
                }
            }
            else
            {
                context.setTextureAt(0, null);
            }
            context.setVertexBufferAt(0, this._vb, 0, "float3");
            context.setVertexBufferAt(1, this._vb, 3, "float3");
            context.setVertexBufferAt(2, this._vb, 6, "float2");
            context.setProgram(program);
            context.drawTriangles(this._ib);
            return;
        }// end function

        private function updateBuffers() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_1:* = false;
            if (!this._vb)
            {
                _loc_4 = 8;
                _loc_5 = this._vertexCount * _loc_4;
                _loc_6 = new Vector.<Number>(_loc_5);
                _loc_2 = 0;
                _loc_3 = this._vertexStart;
                while (_loc_2 < _loc_5)
                {
                    
                    _loc_6[_loc_2] = this._model._vertices[_loc_3].position.x;
                    _loc_6[(_loc_2 + 1)] = this._model._vertices[_loc_3].position.y;
                    _loc_6[_loc_2 + 2] = this._model._vertices[_loc_3].position.z;
                    _loc_6[_loc_2 + 3] = this._model._vertices[_loc_3].normal.x;
                    _loc_6[_loc_2 + 4] = this._model._vertices[_loc_3].normal.y;
                    _loc_6[_loc_2 + 5] = this._model._vertices[_loc_3].normal.z;
                    _loc_6[_loc_2 + 6] = this._model._vertices[_loc_3].u;
                    _loc_6[_loc_2 + 7] = this._model._vertices[_loc_3].v;
                    _loc_2 = _loc_2 + _loc_4;
                    _loc_3++;
                }
                this._vb = context.createVertexBuffer(this._vertexCount, 8);
                this._vb.uploadFromVector(_loc_6, 0, this._vertexCount);
                _loc_1 = true;
            }
            if (!this._ib)
            {
                _loc_7 = new Vector.<uint>(this._indexCount);
                _loc_2 = 0;
                _loc_3 = this._indexStart;
                while (_loc_2 < this._indexCount)
                {
                    
                    _loc_7[++_loc_2] = this._model._indices[_loc_3];
                    _loc_3++;
                }
                this._ib = context.createIndexBuffer(this._indexCount);
                this._ib.uploadFromVector(_loc_7, 0, this._indexCount);
                _loc_1 = true;
            }
            if (_loc_1)
            {
                upload();
            }
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this._show = true;
            this._indexStart = param1.readInt();
            this._vertexStart = param1.readInt();
            this._indexCount = param1.readInt();
            this._vertexCount = param1.readInt();
            this._textureIndex = param1.readShort();
            this._meshId = param1.readShort();
            return;
        }// end function

    }
}
