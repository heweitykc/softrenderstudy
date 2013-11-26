package com.zam.tor
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.display3D.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class TorMesh extends Mesh
    {
        protected var _vertices:Vector.<TorVertex>;
        protected var _indices:Vector.<uint>;
        protected var _numVertices:uint = 0;
        protected var _numIndices:uint = 0;
        protected var _boundsMin:Vector3D;
        protected var _boundsMax:Vector3D;
        protected var _boundsSize:Vector3D;
        protected var _boundsCenter:Vector3D;
        protected var _ready:Boolean = false;
        protected var _model:String;
        protected var _json:Object = null;
        protected var _vb:VertexBuffer3D;
        protected var _ib:IndexBuffer3D;
        protected var _matrix:Matrix3D;
        protected var _diffuseMap:TorTexture = null;
        protected var _rotationMap:TorTexture = null;
        protected var _glossMap:TorTexture = null;
        protected var _useNormalMap:Boolean = false;
        protected var _useGlossMap:Boolean = false;
        protected var _constants:Vector.<Number>;
        protected var _lightPos1:Vector.<Number>;
        protected var _lightPos2:Vector.<Number>;
        protected var _lightPos3:Vector.<Number>;
        protected var _ambientColor:Vector.<Number>;
        protected var _primaryColor:Vector.<Number>;
        protected var _secondColor:Vector.<Number>;
        private var mvpMatrix:Matrix3D;
        private var normalMatrix:Matrix3D;

        public function TorMesh(param1:String, param2:Viewer, param3:Object)
        {
            super(param1, param2, param3);
            this._matrix = new Matrix3D();
            var _loc_4:* = new Vector3D(5, 5, -5, 0);
            _loc_4.normalize();
            var _loc_5:* = new Vector3D(5, 5, 5, 0);
            _loc_5.normalize();
            var _loc_6:* = new Vector3D(-5, -5, -5, 0);
            _loc_6.normalize();
            this._constants = this.Vector.<Number>([0, 1, 2, Math.PI]);
            this._lightPos1 = this.Vector.<Number>([_loc_4.x, _loc_4.y, _loc_4.z, 0]);
            this._lightPos2 = this.Vector.<Number>([_loc_5.x, _loc_5.y, _loc_5.z, 0]);
            this._lightPos3 = this.Vector.<Number>([_loc_6.x, _loc_6.y, _loc_6.z, 0]);
            this._ambientColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this._primaryColor = this.Vector.<Number>([1, 1, 1, 1]);
            this._secondColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this.mvpMatrix = new Matrix3D();
            this.normalMatrix = new Matrix3D();
            return;
        }// end function

        override public function refresh() : void
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
            if (this._diffuseMap)
            {
                this._diffuseMap.refresh();
            }
            if (this._rotationMap)
            {
                this._rotationMap.refresh();
            }
            if (this._glossMap)
            {
                this._glossMap.refresh();
            }
            this.updateBuffers();
            return;
        }// end function

        override public function load(param1:int, param2:String, param3:int = -1, param4:int = -1) : void
        {
            var url:String;
            var type:* = param1;
            var model:* = param2;
            var race:* = param3;
            var gender:* = param4;
            this._model = model;
            var loader:* = new ZamLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.onMetaLoaded, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
            try
            {
                url = "json/" + model + ".json";
                loader.load(new URLRequest(_contentPath + url));
            }
            catch (ex:Error)
            {
            }
            return;
        }// end function

        override public function update(param1:Number) : void
        {
            return;
        }// end function

        override public function render(param1:Number, param2:Boolean = true) : void
        {
            if (!this._ready)
            {
                return;
            }
            this.mvpMatrix.copyFrom(camera.matrix);
            this.mvpMatrix.prepend(camera.modelMatrix);
            this.mvpMatrix.prepend(this._matrix);
            this.normalMatrix.copyFrom(camera.viewMatrix);
            this.normalMatrix.prepend(camera.modelMatrix);
            this.normalMatrix.prepend(this._matrix);
            this.normalMatrix.invert();
            this.normalMatrix.transpose();
            context.setProgramConstantsFromMatrix("vertex", 0, this.mvpMatrix, true);
            context.setProgramConstantsFromMatrix("vertex", 4, this.normalMatrix, true);
            context.setProgramConstantsFromVector("vertex", 8, this._constants);
            context.setProgramConstantsFromVector("fragment", 0, this._constants);
            context.setProgramConstantsFromVector("fragment", 1, this._lightPos1);
            context.setProgramConstantsFromVector("fragment", 2, this._lightPos2);
            context.setProgramConstantsFromVector("fragment", 3, this._lightPos3);
            context.setProgramConstantsFromVector("fragment", 4, this._ambientColor);
            context.setProgramConstantsFromVector("fragment", 5, this._primaryColor);
            context.setProgramConstantsFromVector("fragment", 6, this._secondColor);
            context.setVertexBufferAt(0, this._vb, 0, "float3");
            if (this._diffuseMap && this._diffuseMap.loaded)
            {
                context.setTextureAt(0, this._diffuseMap.texture);
                if (this._useNormalMap && this._rotationMap && this._rotationMap.loaded)
                {
                    context.setTextureAt(1, this._rotationMap.texture);
                    context.setVertexBufferAt(3, this._vb, 9, "float4");
                }
            }
            context.setVertexBufferAt(1, this._vb, 3, "float2");
            context.setVertexBufferAt(2, this._vb, 5, "float4");
            context.setProgram(_program);
            context.drawTriangles(this._ib);
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            op("m44 op, va0, vc0");
            op("mov v0, va1");
            if (this._useNormalMap && this._diffuseMap && this._diffuseMap.loaded && this._rotationMap && this._rotationMap.loaded)
            {
                op("m44 vt0, va2, vc4");
                op("m44 vt1, va3, vc4");
                op("crs vt2.xyz, vt0, vt1");
                op("mov vt2.w, vc8.x");
                op("mov v1, vt0");
                op("mov v2, vt1");
                op("mov v3, vt2");
            }
            else
            {
                op("m44 v1, va2, vc4");
            }
            return;
        }// end function

        override protected function _fragmentShader() : void
        {
            if (this._diffuseMap && this._diffuseMap.loaded)
            {
                op("tex ft0, v0, fs0 <2d, linear, nomip, wrap>");
            }
            else
            {
                op("mov ft0.xy, v0.xy");
                op("mov ft0.zw, fc0.xy");
            }
            if (this._useNormalMap && this._diffuseMap && this._diffuseMap.loaded && this._rotationMap && this._rotationMap.loaded)
            {
                op("nrm ft2.xyz, v1.xyz");
                op("nrm ft1.xyz, v2.xyz");
                op("nrm ft3.xyz, v3.xyz");
                op("tex ft4, v0, fs1 <2d, linear, nomip, wrap>");
                op("mul ft4, ft4, fc0.z");
                op("sub ft4, ft4, fc0.y");
                op("mov ft7, fc4");
                op("dp3 ft5.x, ft1.xyz, fc1.xyz");
                op("dp3 ft5.y, ft2.xyz, fc1.xyz");
                op("dp3 ft5.z, ft3.xyz, fc1.xyz");
                op("dp3 ft6.x, ft4.xyz, ft5.xyz");
                op("max ft6.x, ft6.x, fc0.x");
                op("mul ft6.xyz, ft6.x, fc5.rgb");
                op("add ft7.rgb, ft7.rgb, ft6.rgb");
                op("dp3 ft5.x, ft1.xyz, fc2.xyz");
                op("dp3 ft5.y, ft2.xyz, fc2.xyz");
                op("dp3 ft5.z, ft3.xyz, fc2.xyz");
                op("dp3 ft6.x, ft4.xyz, ft5.xyz");
                op("max ft6.x, ft6.x, fc0.x");
                op("mul ft6.xyz, ft6.x, fc6.rgb");
                op("add ft7.rgb, ft7.rgb, ft6.rgb");
                op("dp3 ft5.x, ft1.xyz, fc3.xyz");
                op("dp3 ft5.y, ft2.xyz, fc3.xyz");
                op("dp3 ft5.z, ft3.xyz, fc3.xyz");
                op("dp3 ft6.x, ft4.xyz, ft5.xyz");
                op("max ft6.x, ft6.x, fc0.x");
                op("mul ft6.xyz, ft6.x, fc6.rgb");
                op("add ft7.rgb, ft7.rgb, ft6.rgb");
                op("mul ft0, ft0, ft7");
            }
            else
            {
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
                op("mul ft0, ft0, ft1");
            }
            op("mov oc, ft0");
            return;
        }// end function

        private function updateBuffers() : void
        {
            var _loc_4:* = 0;
            var _loc_1:* = 13;
            var _loc_2:* = this._numVertices * _loc_1;
            var _loc_3:* = new Vector.<Number>(_loc_2);
            _loc_4 = 0;
            while (_loc_4 < this._numVertices)
            {
                
                _loc_3[_loc_4 * _loc_1 + 0] = this._vertices[_loc_4].position.x;
                _loc_3[_loc_4 * _loc_1 + 1] = this._vertices[_loc_4].position.y;
                _loc_3[_loc_4 * _loc_1 + 2] = this._vertices[_loc_4].position.z;
                _loc_3[_loc_4 * _loc_1 + 3] = this._vertices[_loc_4].u;
                _loc_3[_loc_4 * _loc_1 + 4] = this._vertices[_loc_4].v;
                _loc_3[_loc_4 * _loc_1 + 5] = this._vertices[_loc_4].normal.x;
                _loc_3[_loc_4 * _loc_1 + 6] = this._vertices[_loc_4].normal.y;
                _loc_3[_loc_4 * _loc_1 + 7] = this._vertices[_loc_4].normal.z;
                _loc_3[_loc_4 * _loc_1 + 8] = 0;
                _loc_3[_loc_4 * _loc_1 + 9] = this._vertices[_loc_4].tangent.x;
                _loc_3[_loc_4 * _loc_1 + 10] = this._vertices[_loc_4].tangent.y;
                _loc_3[_loc_4 * _loc_1 + 11] = this._vertices[_loc_4].tangent.z;
                _loc_3[_loc_4 * _loc_1 + 12] = 0;
                _loc_4 = _loc_4 + 1;
            }
            if (!this._vb)
            {
                this._vb = context.createVertexBuffer(this._numVertices, _loc_1);
            }
            this._vb.uploadFromVector(_loc_3, 0, this._numVertices);
            if (!this._ib)
            {
                this._ib = context.createIndexBuffer(this._numIndices);
            }
            this._ib.uploadFromVector(this._indices, 0, this._numIndices);
            upload();
            this._ready = true;
            return;
        }// end function

        private function onMeshLoaded(event:FileLoadEvent) : void
        {
            var magic:uint;
            var version:uint;
            var bytesPerVert:uint;
            var i:uint;
            var indicesOffset:uint;
            var bytesPerIndex:uint;
            var v:TorVertex;
            var e:* = event;
            var data:* = e.target.data;
            data.endian = Endian.LITTLE_ENDIAN;
            try
            {
                magic = data.readUnsignedInt();
                if (magic != 604210090)
                {
                    throw new Error("Magic number doesn\'t match");
                }
                version = data.readUnsignedInt();
                this._numVertices = data.readUnsignedInt();
                bytesPerVert = data.readUnsignedInt();
                i;
                indicesOffset = 16 + this._numVertices * bytesPerVert;
                this._vertices = new Vector.<TorVertex>(this._numVertices);
                this._boundsMin = new Vector3D(1000, 1000, 1000);
                this._boundsMax = new Vector3D(-1000, -1000, -1000);
                i;
                while (i < this._numVertices)
                {
                    
                    v = new TorVertex();
                    v.position.x = data.readFloat();
                    v.position.y = data.readFloat();
                    v.position.z = data.readFloat();
                    v.normal.x = data.readFloat();
                    v.normal.y = data.readFloat();
                    v.normal.z = data.readFloat();
                    v.tangent.x = data.readFloat();
                    v.tangent.y = data.readFloat();
                    v.tangent.z = data.readFloat();
                    v.u = data.readFloat();
                    v.v = data.readFloat();
                    data.position = data.position + 8;
                    this._boundsMin.x = Math.min(this._boundsMin.x, v.position.x);
                    this._boundsMax.x = Math.max(this._boundsMax.x, v.position.x);
                    this._boundsMin.y = Math.min(this._boundsMin.y, v.position.y);
                    this._boundsMax.y = Math.max(this._boundsMax.y, v.position.y);
                    this._boundsMin.z = Math.min(this._boundsMin.z, v.position.z);
                    this._boundsMax.z = Math.max(this._boundsMax.z, v.position.z);
                    this._vertices[i] = v;
                    i = (i + 1);
                }
                if (data.position != indicesOffset)
                {
                    data.position = indicesOffset;
                }
                this._numIndices = data.readUnsignedInt();
                bytesPerIndex = data.readUnsignedInt();
                this._indices = new Vector.<uint>(this._numIndices);
                i;
                while (i < this._numIndices)
                {
                    
                    this._indices[i] = data.readUnsignedShort();
                    i = (i + 1);
                }
            }
            catch (ex:Error)
            {
            }
            this._boundsSize = new Vector3D(this._boundsMax.x - this._boundsMin.x, this._boundsMax.y - this._boundsMin.y, this._boundsMax.z - this._boundsMin.z);
            var maxSize:* = Math.max(this._boundsSize.x, this._boundsSize.y);
            maxSize = Math.max(maxSize, this._boundsSize.z);
            this._boundsCenter = this._boundsSize.clone();
            this._boundsCenter.scaleBy(0.5);
            this._boundsCenter.incrementBy(this._boundsMin);
            this._matrix.appendTranslation(-this._boundsCenter.x, -this._boundsCenter.y, -this._boundsCenter.z);
            if (this._json.weapon)
            {
                this._matrix.appendRotation(90, Vector3D.X_AXIS);
                this._matrix.appendRotation(90, Vector3D.Y_AXIS);
            }
            this.updateBuffers();
            camera.setDistance(maxSize * 1.5);
            return;
        }// end function

        private function onMetaLoaded(event:FileLoadEvent) : void
        {
            var slot:String;
            var e:* = event;
            this._json = JSON.parse(e.target.data);
            if (!this._json.model)
            {
                return;
            }
            var loader:* = new ZamLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(FileLoadEvent.LOAD_START, this.onLoadStart, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.onMeshLoaded, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
            try
            {
                loader.load(new URLRequest(_contentPath + this._json.model));
            }
            catch (ex:Error)
            {
            }
            var _loc_3:* = 0;
            var _loc_4:* = this._json.textures;
            while (_loc_4 in _loc_3)
            {
                
                slot = _loc_4[_loc_3];
                if (slot == "DiffuseMap")
                {
                    this._diffuseMap = this.loadTexture(_loc_4[slot], slot);
                    continue;
                }
                if (this._useNormalMap && slot == "RotationMap1")
                {
                    this._rotationMap = this.loadTexture(_loc_4[slot], slot);
                    continue;
                }
                if (this._useGlossMap && slot == "GlossMap")
                {
                    this._glossMap = this.loadTexture(_loc_4[slot], slot);
                }
            }
            return;
        }// end function

        private function loadTexture(param1:String, param2:String) : TorTexture
        {
            return new TorTexture(_viewer, this, param2, param1);
        }// end function

        public function onTextureLoaded(param1:String) : void
        {
            upload();
            return;
        }// end function

        private function onLoadStart(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_START, event.url);
            _viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onLoadProgress(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, event.url, event.currentBytes, event.totalBytes);
            _viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onLoadError(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, event.url, -1, -1, event.errorMessage);
            _viewer.dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
