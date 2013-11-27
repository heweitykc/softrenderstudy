package com.zam.gw2
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class Gw2Model extends Mesh
    {
        public var _model:String;
        protected var _modelType:int;
        protected var _ready:Boolean;
        protected var _boundsMin:Vector3D;
        protected var _boundsMax:Vector3D;
        protected var _boundsSize:Vector3D;
        protected var _boundsCenter:Vector3D;
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
        protected var _meshes:Vector.<Gw2Mesh>;
        protected var _materials:Vector.<Material>;
        protected var _textures:Array;
        private var _checks:Object;
        private static var _numChecks:int = 0;

        public function Gw2Model(param1:String, param2:Viewer, param3:Object)
        {
            this._textures = new Array();
            this._checks = {};
            super(param1, param2, param3);
            this._matrix = new Matrix3D();
            var _loc_4:* = new Vector3D(5, 5, -5);
            _loc_4.normalize();
            var _loc_5:* = new Vector3D(5, 5, 5);
            _loc_5.normalize();
            var _loc_6:* = new Vector3D(-5, -5, -5);
            _loc_6.normalize();
            this._constants = this.Vector.<Number>([0, 1, 2, Math.PI]);
            this._constants2 = this.Vector.<Number>([0.7, 0.1, 0, 0]);
            this._lightPos1 = this.Vector.<Number>([_loc_4.x, _loc_4.y, _loc_4.z, 0]);
            this._lightPos2 = this.Vector.<Number>([_loc_5.x, _loc_5.y, _loc_5.z, 0]);
            this._lightPos3 = this.Vector.<Number>([_loc_6.x, _loc_6.y, _loc_6.z, 0]);
            this._ambientColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this._primaryColor = this.Vector.<Number>([1, 1, 1, 1]);
            this._secondColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this.mvpMatrix = new Matrix3D();
            this.mvMatrix = new Matrix3D();
            this.normalMatrix = new Matrix3D();
            this.matVector = new Vector.<Number>(16);
            this.tmpVec = new Vector3D();
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

        public function getMaterialSet(param1:int) : MaterialSet
        {
            if (this._textures[param1] === undefined)
            {
                this._textures[param1] = new MaterialSet();
            }
            return this._textures[param1];
        }// end function

        override public function refresh() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            _loc_1 = 0;
            while (this._meshes && _loc_1 < this._meshes.length)
            {
                
                this._meshes[_loc_1].refresh();
                _loc_1++;
            }
            for each (_loc_2 in this._textures)
            {
                
                if (_loc_2.diffuse)
                {
                    _loc_2.diffuse.refresh();
                }
                if (_loc_2.lightmap)
                {
                    _loc_2.lightmap.refresh();
                }
                if (_loc_2.normal)
                {
                    _loc_2.normal.refresh();
                }
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
            var loader:* = new ZamLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.onLoaded, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
            try
            {
                url = "models/" + model + ".gwm?9";
                loader.load(new URLRequest(_contentPath + url));
            }
            catch (ex:Error)
            {
            }
            return;
        }// end function

        override public function update(param1:Number) : void
        {
            if (!this._ready)
            {
                return;
            }
            return;
        }// end function

        override public function render(param1:Number, param2:Boolean = true) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (!this._ready)
            {
                return;
            }
            this.mvpMatrix.copyFrom(camera.matrix);
            this.mvpMatrix.prepend(camera.modelMatrix);
            this.mvpMatrix.prepend(this._matrix);
            this.mvMatrix.copyFrom(camera.viewMatrix);
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
            var _loc_5:* = this._meshes.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                if (this._meshes[_loc_3]._show && !this._meshes[_loc_3]._delay)
                {
                    this._meshes[_loc_3].render();
                }
                _loc_3++;
            }
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                if (this._meshes[_loc_3]._show && this._meshes[_loc_3]._delay)
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

        private function onLoaded(event:FileLoadEvent) : void
        {
            var magic:uint;
            var version:uint;
            var numMaterials:uint;
            var numMeshes:uint;
            var e:* = event;
            var i:uint;
            var data:* = e.target.data;
            data.endian = Endian.LITTLE_ENDIAN;
            try
            {
                magic = data.readUnsignedInt();
                if (magic != 604210093)
                {
                    throw new Error("Magic number doesn\'t match");
                }
                version = data.readUnsignedInt();
                numMaterials = data.readUnsignedInt();
                this._materials = new Vector.<Material>(numMaterials);
                i;
                while (i < numMaterials)
                {
                    
                    this._materials[i] = new Material();
                    this._materials[i].read(data);
                    i = (i + 1);
                }
                numMeshes = data.readUnsignedInt();
                this._meshes = new Vector.<Gw2Mesh>(numMeshes);
                i;
                while (i < numMeshes)
                {
                    
                    this._meshes[i] = new Gw2Mesh(this);
                    this._meshes[i].read(data);
                    i = (i + 1);
                }
            }
            catch (ex:Error)
            {
            }
            this.calcBounds();
            this.loadTextures();
            this._ready = true;
            return;
        }// end function

        public function onCheck(event:MouseEvent) : void
        {
            var _loc_2:* = parseInt(event.target.text);
            var _loc_3:* = event.target.textColor == 65280;
            if (this._meshes[_loc_2]._show && _loc_3)
            {
                this._meshes[_loc_2]._show = false;
                event.target.textColor = 16711680;
            }
            else if (!this._meshes[_loc_2]._show && !_loc_3)
            {
                this._meshes[_loc_2]._show = true;
                event.target.textColor = 65280;
            }
            return;
        }// end function

        private function calcBounds() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_4:* = NaN;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            this._boundsMin = new Vector3D(9999, 9999, 9999);
            this._boundsMax = new Vector3D(-9999, -9999, -9999);
            this._boundsCenter = new Vector3D();
            this._boundsSize = new Vector3D();
            var _loc_3:* = this._meshes.length;
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                _loc_1 = this._meshes[_loc_2]._minBounds;
                this._boundsMin.x = Math.min(this._boundsMin.x, _loc_1.x);
                this._boundsMin.y = Math.min(this._boundsMin.y, _loc_1.y);
                this._boundsMin.z = Math.min(this._boundsMin.z, _loc_1.z);
                _loc_1 = this._meshes[_loc_2]._maxBounds;
                this._boundsMax.x = Math.max(this._boundsMax.x, _loc_1.x);
                this._boundsMax.y = Math.max(this._boundsMax.y, _loc_1.y);
                this._boundsMax.z = Math.max(this._boundsMax.z, _loc_1.z);
                _loc_2++;
            }
            this._boundsSize.setTo(this._boundsMax.x - this._boundsMin.x, this._boundsMax.y - this._boundsMin.y, this._boundsMax.z - this._boundsMin.z);
            _loc_4 = this._boundsSize.z;
            _loc_5 = this._boundsSize.x;
            _loc_6 = Math.max(_loc_4, _loc_5);
            this._boundsCenter.setTo(this._boundsMin.x + this._boundsSize.x * 0.5, this._boundsMin.y + this._boundsSize.y * 0.5, this._boundsMin.z + this._boundsSize.z * 0.5);
            var _loc_7:* = viewer.stage.stageWidth / viewer.stage.stageHeight;
            var _loc_8:* = 2 * Math.tan(45 / 2);
            var _loc_9:* = 2 * Math.tan(45 / 2) * camera.zNear;
            var _loc_10:* = 2 * Math.tan(45 / 2) * camera.zNear * _loc_7;
            var _loc_11:* = _loc_8 * camera.zFar;
            var _loc_12:* = _loc_8 * camera.zFar * _loc_7;
            var _loc_13:* = (_loc_11 - _loc_9) / camera.zFar;
            var _loc_14:* = (_loc_12 - _loc_10) / camera.zFar;
            var _loc_15:* = (_loc_4 * 1.5 - _loc_9 + _loc_5 / 2) / _loc_13;
            var _loc_16:* = (Math.max(this._boundsSize.x, this._boundsSize.y) * 1.5 + _loc_4 / 2 - _loc_10) / _loc_14;
            var _loc_17:* = Math.max(_loc_15, _loc_16);
            if (params.initialZoom)
            {
                _loc_17 = parseFloat(params.initialZoom);
            }
            camera.setDistance(_loc_17);
            if (_loc_17 > 500)
            {
                camera.setClipDistance(_loc_17 * 2);
            }
            else
            {
                camera.setClipDistance(1000);
            }
            this._matrix.identity();
            this._matrix.prependTranslation(-this._boundsCenter.x, -this._boundsCenter.y, -this._boundsCenter.z);
            this._matrix.appendRotation(90, Vector3D.X_AXIS);
            this._matrix.appendRotation(180, Vector3D.Y_AXIS);
            return;
        }// end function

        private function loadTextures() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            var _loc_2:* = this._materials.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_2)
            {
                
                _loc_3 = this._materials[_loc_1];
                if (this._textures[_loc_3.index] === undefined)
                {
                    this._textures[_loc_3.index] = new MaterialSet();
                }
                if (_loc_3.type == Gw2Texture.DIFFUSE && !this._textures[_loc_3.index].diffuse)
                {
                    this._textures[_loc_3.index].diffuse = new Gw2Texture(this, _loc_1, "" + _loc_3.fileId + ".png", Gw2Texture.DIFFUSE);
                }
                else if (_loc_3.type == Gw2Texture.NORMAL && !this._textures[_loc_3.index].normal)
                {
                    this._textures[_loc_3.index].normal = new Gw2Texture(this, _loc_1, "" + _loc_3.fileId + ".png", Gw2Texture.NORMAL);
                }
                else if (_loc_3.type == Gw2Texture.LIGHTMAP && !this._textures[_loc_3.index].lightmap)
                {
                    this._textures[_loc_3.index].lightmap = new Gw2Texture(this, _loc_1, "" + _loc_3.fileId + ".png", Gw2Texture.LIGHTMAP);
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        public function onTextureLoaded(param1:Gw2Texture, param2:int, param3:int) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (param2 == Gw2Texture.DIFFUSE || param2 == Gw2Texture.NORMAL || param2 == Gw2Texture.LIGHTMAP)
            {
                _loc_4 = this._materials[param3];
                for each (_loc_5 in this._meshes)
                {
                    
                    if (_loc_5._matIndex == _loc_4.index)
                    {
                        _loc_5.onTextureLoaded(param2);
                    }
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
