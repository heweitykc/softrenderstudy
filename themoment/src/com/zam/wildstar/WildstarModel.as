package com.zam.wildstar
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class WildstarModel extends Mesh
    {
        protected var _model:String;
        protected var _type:int;
        protected var _ready:Boolean;
        protected var _version:uint;
        protected var _meta:Object;
        protected var _boundsMin:Vector3D;
        protected var _boundsMax:Vector3D;
        protected var _boundsSize:Vector3D;
        protected var _boundsCenter:Vector3D;
        public var _vertices:Vector.<Vertex>;
        public var _indices:Vector.<uint>;
        public var _meshes:Vector.<WildstarMesh>;
        public var _meshMap:Dictionary;
        public var _textures:Vector.<WildstarTexture>;
        public var _textureMap:Dictionary;
        public var _texture:WildstarTexture;
        public var _vbData:Vector.<Number>;
        protected var _matrix:Matrix3D;
        protected var _constants:Vector.<Number>;
        protected var _constants2:Vector.<Number>;
        protected var _lightPos1:Vector.<Number>;
        protected var _lightPos2:Vector.<Number>;
        protected var _lightPos3:Vector.<Number>;
        protected var _ambientColor:Vector.<Number>;
        protected var _primaryColor:Vector.<Number>;
        protected var _secondColor:Vector.<Number>;
        private var mvpMatrix:Matrix3D;
        private var mvMatrix:Matrix3D;
        private var normalMatrix:Matrix3D;
        private var matVector:Vector.<Number>;
        private var tmpVec:Vector3D;
        private var offset:Vector3D;
        private var offsetAdjust:Vector3D;
        public static const TypeModel:int = 1;
        public static const TypeMesh:int = 256;

        public function WildstarModel(param1:String, param2:Viewer, param3:Object)
        {
            super(param1, param2, param3);
            var _loc_4:* = new Vector3D(5, 5, -5);
            _loc_4.normalize();
            var _loc_5:* = new Vector3D(5, 5, 5);
            _loc_5.normalize();
            var _loc_6:* = new Vector3D(-5, -5, -5);
            _loc_6.normalize();
            this._constants = this.Vector.<Number>([0, 1, 2, Math.PI]);
            this._constants2 = this.Vector.<Number>([0.7, 0, 0, 0]);
            this._lightPos1 = this.Vector.<Number>([_loc_4.x, _loc_4.y, _loc_4.z, 0]);
            this._lightPos2 = this.Vector.<Number>([_loc_5.x, _loc_5.y, _loc_5.z, 0]);
            this._lightPos3 = this.Vector.<Number>([_loc_6.x, _loc_6.y, _loc_6.z, 0]);
            this._ambientColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this._primaryColor = this.Vector.<Number>([1, 1, 1, 1]);
            this._secondColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this._matrix = new Matrix3D();
            this.mvpMatrix = new Matrix3D();
            this.mvMatrix = new Matrix3D();
            this.normalMatrix = new Matrix3D();
            this.matVector = new Vector.<Number>(16);
            this.tmpVec = new Vector3D();
            this.offset = new Vector3D();
            this.offsetAdjust = new Vector3D();
            return;
        }// end function

        public function get ready() : Boolean
        {
            return this._ready;
        }// end function

        public function get modelMatrix() : Matrix3D
        {
            return this._matrix;
        }// end function

        override public function refresh() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            for (_loc_1 in this._textures)
            {
                
                _loc_5[_loc_1].refresh();
            }
            _loc_3 = this._meshes.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this._meshes[_loc_2].refresh();
                _loc_2++;
            }
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
            this._type = type;
            var loader:* = new ZamLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.onLoaded, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
            if (type == TypeMesh)
            {
                url = model;
                loader.dataFormat = URLLoaderDataFormat.BINARY;
            }
            else
            {
                url = "meta/" + model + ".json";
            }
            try
            {
                loader.load(new URLRequest(_contentPath + url.toLowerCase()));
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
            var _loc_3:* = 0;
            if (!this._ready)
            {
                return;
            }
            this.mvpMatrix.copyFrom(camera.matrix);
            this.mvpMatrix.prependTranslation(this.offset.x, this.offset.y, this.offset.z);
            this.mvpMatrix.prepend(camera.modelMatrix);
            this.mvpMatrix.prepend(this._matrix);
            this.mvMatrix.copyFrom(camera.viewMatrix);
            this.mvMatrix.prependTranslation(this.offset.x, this.offset.y, this.offset.z);
            this.mvMatrix.prepend(camera.modelMatrix);
            this.mvMatrix.prepend(this._matrix);
            this.normalMatrix.copyFrom(camera.viewMatrix);
            this.normalMatrix.prepend(camera.modelMatrix);
            this.normalMatrix.prepend(this._matrix);
            this.normalMatrix.invert();
            this.normalMatrix.transpose();
            context.setProgramConstantsFromMatrix("vertex", 0, this.mvpMatrix, true);
            context.setProgramConstantsFromMatrix("vertex", 4, this.normalMatrix, true);
            context.setProgramConstantsFromMatrix("vertex", 12, this.mvMatrix, true);
            context.setProgramConstantsFromMatrix("vertex", 20, camera.projMatrix, true);
            context.setProgramConstantsFromVector("vertex", 9, camera.positionVec);
            if (param2)
            {
                context.setProgramConstantsFromVector("vertex", 8, this._constants);
                context.setProgramConstantsFromVector("fragment", 0, this._constants);
                context.setProgramConstantsFromVector("fragment", 1, this._lightPos1);
                context.setProgramConstantsFromVector("fragment", 2, this._lightPos2);
                context.setProgramConstantsFromVector("fragment", 3, this._lightPos3);
                context.setProgramConstantsFromVector("fragment", 4, this._ambientColor);
                context.setProgramConstantsFromVector("fragment", 5, this._primaryColor);
                context.setProgramConstantsFromVector("fragment", 6, this._secondColor);
                context.setProgramConstantsFromVector("fragment", 7, this._constants2);
            }
            var _loc_4:* = this._meshes.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_4)
            {
                
                if (this._meshes[_loc_3]._show)
                {
                    this._meshes[_loc_3].render();
                }
                _loc_3++;
            }
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            return;
        }// end function

        override protected function _fragmentShader() : void
        {
            return;
        }// end function

        private function updateBuffers(param1:Boolean = true) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_2:* = 8;
            var _loc_3:* = this._vertices.length * _loc_2;
            if (!this._vbData)
            {
                this._vbData = new Vector.<Number>(_loc_3);
            }
            if (param1)
            {
                _loc_4 = 0;
                _loc_5 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    this._vbData[_loc_4] = this._vertices[_loc_5].position.x;
                    this._vbData[(_loc_4 + 1)] = this._vertices[_loc_5].position.y;
                    this._vbData[_loc_4 + 2] = this._vertices[_loc_5].position.z;
                    this._vbData[_loc_4 + 3] = this._vertices[_loc_5].normal.x;
                    this._vbData[_loc_4 + 4] = this._vertices[_loc_5].normal.y;
                    this._vbData[_loc_4 + 5] = this._vertices[_loc_5].normal.z;
                    this._vbData[_loc_4 + 6] = this._vertices[_loc_5].u;
                    this._vbData[_loc_4 + 7] = this._vertices[_loc_5].v;
                    _loc_4 = _loc_4 + _loc_2;
                    _loc_5++;
                }
            }
            this._ready = true;
            return;
        }// end function

        private function readMesh(event:FileLoadEvent) : void
        {
            var i:uint;
            var magic:uint;
            var version:uint;
            var compressed:int;
            var numVerts:uint;
            var numIndices:uint;
            var numMeshes:uint;
            var numMeshMap:uint;
            var numTextures:uint;
            var numTextureMap:uint;
            var newData:ByteArray;
            var color:int;
            var normal:int;
            var j:int;
            var meshId:int;
            var e:* = event;
            var data:* = e.target.data;
            data.endian = Endian.LITTLE_ENDIAN;
            try
            {
                magic = data.readUnsignedInt();
                if (magic != 872645548)
                {
                    return;
                }
                version = data.readUnsignedInt();
                compressed = data.readByte();
                if (compressed)
                {
                    newData = new ByteArray();
                    newData.endian = Endian.LITTLE_ENDIAN;
                    data.readBytes(newData);
                    newData.uncompress();
                    data = newData;
                }
                numVerts = data.readUnsignedInt();
                this._vertices = new Vector.<Vertex>(numVerts);
                i;
                while (i < numVerts)
                {
                    
                    this._vertices[i] = new Vertex();
                    this._vertices[i].read(data);
                    i = (i + 1);
                }
                numIndices = data.readUnsignedInt();
                this._indices = new Vector.<uint>(numIndices);
                i;
                while (i < numIndices)
                {
                    
                    this._indices[i] = data.readUnsignedInt();
                    i = (i + 1);
                }
                numMeshes = data.readUnsignedInt();
                this._meshes = new Vector.<WildstarMesh>(numMeshes);
                i;
                while (i < numMeshes)
                {
                    
                    this._meshes[i] = new WildstarMesh(this);
                    this._meshes[i].read(data);
                    i = (i + 1);
                }
                numMeshMap = data.readUnsignedInt();
                this._meshMap = new Dictionary();
                i;
                while (i < numMeshMap)
                {
                    
                    this._meshMap[data.readShort()] = i;
                    i = (i + 1);
                }
                numTextures = data.readUnsignedInt();
                this._textures = new Vector.<WildstarTexture>(numTextures);
                i;
                while (i < numTextures)
                {
                    
                    this._textures[i] = new WildstarTexture(viewer, null, false);
                    this._textures[i].read(data);
                    i = (i + 1);
                }
                numTextureMap = data.readUnsignedInt();
                this._textureMap = new Dictionary();
                i;
                while (i < numTextureMap)
                {
                    
                    color = data.readShort();
                    normal = data.readShort();
                    this._textureMap[i] = {color:color, normal:normal};
                    i = (i + 1);
                }
            }
            catch (ex:Error)
            {
            }
            var numMeshIds:* = this._meta.meshIds.length;
            if (numMeshIds > 0)
            {
                i;
                while (i < numMeshes)
                {
                    
                    this._meshes[i]._show = false;
                    i = (i + 1);
                }
                i;
                while (i < numMeshIds)
                {
                    
                    if (this._meshMap[this._meta.meshIds[i]] === undefined)
                    {
                    }
                    else
                    {
                        meshId = this._meshMap[this._meta.meshIds[i]];
                        j;
                        while (j < numMeshes)
                        {
                            
                            this._meshes[j]._show = this._meshes[j]._meshId == meshId;
                            j = (j + 1);
                        }
                    }
                    i = (i + 1);
                }
            }
            this.updateBuffers();
            this.calcBounds();
            return;
        }// end function

        private function calcBounds() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            this._boundsMin = new Vector3D(9999, 9999, 9999);
            this._boundsMax = new Vector3D(-9999, -9999, -9999);
            this._boundsCenter = new Vector3D();
            this._boundsSize = new Vector3D();
            var _loc_3:* = this._vertices.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_1 = this._vertices[_loc_2].position;
                this._boundsMin.x = Math.min(this._boundsMin.x, _loc_1.x);
                this._boundsMin.y = Math.min(this._boundsMin.y, _loc_1.y);
                this._boundsMin.z = Math.min(this._boundsMin.z, _loc_1.z);
                this._boundsMax.x = Math.max(this._boundsMax.x, _loc_1.x);
                this._boundsMax.y = Math.max(this._boundsMax.y, _loc_1.y);
                this._boundsMax.z = Math.max(this._boundsMax.z, _loc_1.z);
                _loc_2++;
            }
            this._calcBounds();
            return;
        }// end function

        private function _calcBounds() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            var _loc_17:* = null;
            this._boundsSize.setTo(this._boundsMax.x - this._boundsMin.x, this._boundsMax.y - this._boundsMin.y, this._boundsMax.z - this._boundsMin.z);
            _loc_2 = this._boundsSize.y;
            _loc_3 = this._boundsSize.x;
            _loc_4 = Math.max(_loc_2, _loc_3);
            this._boundsCenter.setTo(this._boundsMin.x + this._boundsSize.x * 0.5, this._boundsMin.y + this._boundsSize.y * 0.5, this._boundsMin.z + this._boundsSize.z * 0.5);
            if (!params._parentModel)
            {
                _loc_5 = viewer.stage.stageWidth / viewer.stage.stageHeight;
                _loc_6 = 2 * Math.tan(45 / 2);
                _loc_7 = _loc_6 * 0.01;
                _loc_8 = _loc_7 * _loc_5;
                _loc_9 = _loc_6 * 500;
                _loc_10 = _loc_9 * _loc_5;
                _loc_11 = (_loc_9 - _loc_7) / 500;
                _loc_12 = (_loc_10 - _loc_8) / 500;
                _loc_13 = (_loc_2 * 1.5 - _loc_7 + _loc_3 / 2) / _loc_11;
                _loc_14 = (Math.max(this._boundsSize.x, this._boundsSize.z) * 1.5 + _loc_2 / 2 - _loc_8) / _loc_12;
                _loc_15 = Math.max(_loc_13, _loc_14);
                _loc_16 = 1;
                if (params.offset)
                {
                    _loc_17 = params.offset.split(" ");
                    if (_loc_17.length != 3)
                    {
                        _loc_17 = [0, 0, 0];
                    }
                    this.offset.setTo(_loc_17[0], _loc_17[1], _loc_17[2]);
                }
                if (params.offsetAdjust)
                {
                    _loc_17 = params.offsetAdjust.split(" ");
                    if (_loc_17.length != 3)
                    {
                        _loc_17 = [0, 0, 0];
                    }
                    this.offsetAdjust.setTo(_loc_17[0], _loc_17[1], _loc_17[2]);
                }
                if (params.initialZoom)
                {
                    camera.setDistance(parseFloat(params.initialZoom));
                }
                else
                {
                    camera.setDistance(_loc_15 * _loc_16);
                }
            }
            this._matrix.identity();
            this._matrix.prependTranslation(-this._boundsCenter.x + this.offsetAdjust.x, -this._boundsCenter.y + this.offsetAdjust.y, -this._boundsCenter.z + this.offsetAdjust.z);
            return;
        }// end function

        override public function registerExternalInterface() : void
        {
            ExternalInterface.addCallback("isLoaded", this.extIsLoaded);
            return;
        }// end function

        public function extIsLoaded() : Boolean
        {
            return this._ready;
        }// end function

        private function onLoaded(event:FileLoadEvent) : void
        {
            if (this._type == TypeMesh)
            {
                this.readMesh(event);
            }
            else
            {
                this._meta = JSON.parse(event.target.data);
                if (this._meta.tex0)
                {
                    this._texture = new WildstarTexture(viewer, this._meta.tex0.replace(".tex", ".png"));
                }
                if (this._meta.model)
                {
                    this.load(TypeMesh, this._meta.model.replace(".m3", ".mesh"), this._meta.race, this._meta.sex);
                }
            }
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
