package com.zam.lol
{
    import com.zam.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class LolMesh extends Mesh
    {
        public var model:String;
        public var skinId:int;
        protected var _ready:Boolean;
        protected var _animsLoading:Boolean;
        protected var _version:uint;
        protected var _children:Vector.<LolMesh>;
        protected var _boundsMin:Vector3D;
        protected var _boundsMax:Vector3D;
        protected var _boundsSize:Vector3D;
        protected var _boundsCenter:Vector3D;
        protected var _boundsAnimated:Boolean;
        protected var _texture:LolTexture;
        protected var _hasTexture:Boolean;
        protected var _meshes:Vector.<Object>;
        protected var _vertices:Vector.<Vertex>;
        protected var _indices:Vector.<uint>;
        protected var _bones:Vector.<Bone>;
        protected var _boneLookup:Dictionary;
        protected var _animations:Vector.<Animation>;
        protected var _currentAnimation:int = -1;
        protected var _animName:String;
        protected var _animTime:int;
        protected var _vbData:Vector.<Number>;
        protected var _vb:VertexBuffer3D;
        protected var _ib:IndexBuffer3D;
        protected var _matrix:Matrix3D;
        protected var _constants:Vector.<Number>;
        protected var _constants2:Vector.<Number>;
        protected var _lightPos1:Vector.<Number>;
        protected var _lightPos2:Vector.<Number>;
        protected var _lightPos3:Vector.<Number>;
        protected var _ambientColor:Vector.<Number>;
        protected var _primaryColor:Vector.<Number>;
        protected var _secondColor:Vector.<Number>;
        protected var _metaData:Object;
        protected var _meshTextures:Dictionary;
        private var mvpMatrix:Matrix3D;
        private var mvMatrix:Matrix3D;
        private var normalMatrix:Matrix3D;
        private var matVector:Vector.<Number>;
        private var tmpVec:Vector3D;
        private var offset:Vector3D;
        private var offsetAdjust:Vector3D;
        public var transforms:Vector.<Matrix3D>;
        private var _checks:Object;
        private var _debugLookup:Object;
        protected var _fixedModelBones:Object;
        private static var _numChecks:int = 0;

        public function LolMesh(param1:String, param2:Viewer, param3:Object)
        {
            this._checks = {};
            this._debugLookup = {};
            this._fixedModelBones = {
				43: { 
					0: { r_thumb1:1, r_hand:1 },
					1: { r_thumb1:1, r_hand:1, r_fan1:1, r_fan3:1 },
					2: { r_thumb1:1, r_thumb2:1, r_index1:1, r_hand:1, r_fan:1, r_fan2:1, l_fan:1, l_fan2:1, l_fan3:1, l_fan4:1, r_foot:1 },
					3: { r_thumb1:1, r_hand:1 }
				}
			};
            super(param1, param2, param3);
            var _loc_4:* = new Vector3D(5, 5, -5);
            _loc_4.normalize();
            var _loc_5:* = new Vector3D(5, 5, 5);
            _loc_5.normalize();
            var _loc_6:* = new Vector3D(-5, -5, -5);
            _loc_6.normalize();
            this._constants = Vector.<Number>([0, 1, 2, Math.PI]);
            this._constants2 = Vector.<Number>([0.7, 0, 0, 0]);
            this._lightPos1 = Vector.<Number>([_loc_4.x, _loc_4.y, _loc_4.z, 0]);
            this._lightPos2 = Vector.<Number>([_loc_5.x, _loc_5.y, _loc_5.z, 0]);
            this._lightPos3 = Vector.<Number>([_loc_6.x, _loc_6.y, _loc_6.z, 0]);
            this._ambientColor = Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this._primaryColor = Vector.<Number>([1, 1, 1, 1]);
            this._secondColor = Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this._matrix = new Matrix3D();
            this.mvpMatrix = new Matrix3D();
            this.mvMatrix = new Matrix3D();
            this.normalMatrix = new Matrix3D();
            this.matVector = new Vector.<Number>(16);
            this.tmpVec = new Vector3D();
            this.offset = new Vector3D();
            this.offsetAdjust = new Vector3D();
            this._boneLookup = new Dictionary();
            this._metaData = null;
            this._meshTextures = new Dictionary();
            
        }

        public function get ready() : Boolean
        {
            return this._ready;
        }

        public function get modelMatrix() : Matrix3D
        {
            return this._matrix;
        }

        public function get bones() : Vector.<Bone>
        {
            return this._bones;
        }

        public function get boneLookup() : Dictionary
        {
            return this._boneLookup;
        }

        public function get currentAnim() : Animation
        {
            return this._animations[this._currentAnimation];
        }

        override public function refresh() : void
        {
            var _loc_1:* = 0;
            if (this._texture)
            {
                this._texture.refresh();
            }
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
            upload();
            if (this._children)
            {
                _loc_1 = 0;
                while (_loc_1 < this._children.length)
                {
                    
                    this._children[_loc_1].refresh();
                    _loc_1++;
                }
            }
            
        }

        override public function load(param1:int, param2:String, param3:int = -1, param4:int = -1) : void
        {
            var info:Array;
            var numModels:int;
            var i:int;
            var skin:* = param1;
            var m:* = param2;
            var foo1:* = param3;
            var foo2:* = param4;
            this.model = m;
            this.skinId = skin;
            if (params.otherModels)
            {
                info = params.otherModels.split(",");
                if (info.length % 2 != 0)
                {
                    info.pop();
                }
                if (info.length > 0)
                {
                    numModels = info.length / 2;
                    this._children = new Vector.<LolMesh>(numModels);
                    i;
                    while (i < numModels)
                    {
                        
                        this._children[i] = new LolMesh(contentPath, viewer, {_parentModel:this});
                        this._children[i].load(parseInt(info[i * 2 + 1]), info[i * 2]);
                        i = (i + 1);
                    }
                }
            }
            var metaLoader:* = new ZamLoader();
            metaLoader.dataFormat = URLLoaderDataFormat.TEXT;
            metaLoader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.readMeta, false, 0, true);
            var metaUrl:* = "meta/" + this.model + "_" + this.skinId + ".json";
            try
            {
                metaLoader.load(new URLRequest(_contentPath + metaUrl.toLowerCase()));
            }
            catch (ex:Error)
            {
            }
			
            var loader:* = new ZamLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.readMesh, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
            var url:* = "models/" + this.model + "_" + this.skinId + ".png";
            try
            {
                loader.load(new URLRequest(_contentPath + url.toLowerCase()));
            }
            catch (ex:Error)
            {
            }
            
        }

        public function setAnimation(param1:String) : void
        {
            var _loc_2:* = 0;
            var _loc_4:* = null;
            param1 = param1.toLowerCase();
            this._currentAnimation = -1;
            var _loc_3:* = this._animations.length;
            if (param1 == "idle" || param1 == "attack")
            {
                _loc_4 = new Vector.<int>;
                _loc_2 = 0;
                while (_loc_2 < _loc_3)
                {
                    
                    if (this._animations[_loc_2].name.indexOf(param1) == 0)
                    {
                        _loc_4.push(_loc_2);
                    }
                    _loc_2++;
                }
                if (_loc_4.length > 0)
                {
                    this._currentAnimation = _loc_4[ZamUtil.randomInt(0, _loc_4.length)];
                }
            }
            else
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_3)
                {
                    
                    if (this._animations[_loc_2].name == param1)
                    {
                        this._currentAnimation = _loc_2;
                        break;
                    }
                    _loc_2++;
                }
            }
            if (this._currentAnimation == -1)
            {
                if (param1 == "idle")
                {
                    this._currentAnimation = 0;
                    if (this._currentAnimation < this._animations.length)
                    {
                        this._animName = this._animations[this._currentAnimation].name;
                    }
                }
                else
                {
                    this.setAnimation("idle");
                }
            }
            else
            {
                this._animName = param1;
            }
            this._animTime = viewer.time;
            
        }

        override public function update(param1:Number) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = NaN;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = NaN;
            var _loc_14:* = 0;
            var _loc_15:* = null;
            var _loc_16:* = 0;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = false;
            if (!this._ready || !this._animations || this._animations.length == 0)
            {
                return;
            }
            if (this._currentAnimation == -1)
            {
                this.setAnimation("idle");
            }
            var _loc_2:* = this._animations[this._currentAnimation];
            var _loc_3:* = viewer.time - this._animTime;
            if (_loc_3 >= _loc_2.duration)
            {
                this.setAnimation(this._animName);
                _loc_2 = this._animations[this._currentAnimation];
                _loc_3 = 0;
            }
            _loc_6 = 1000 / _loc_2.fps;
            _loc_7 = Math.floor(_loc_3 / _loc_6);
            _loc_8 = _loc_3 % _loc_2.fps / _loc_6;
            if (this._version >= 2)
            {
                _loc_9 = this._bones.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_9)
                {
                    
                    if (this._bones[_loc_4].fixed || _loc_2.lookup[this._bones[_loc_4].name] === undefined)
                    {
                        if (this._bones[_loc_4].parent != -1)
                        {
                            MatrixUtil.multiply(this._bones[_loc_4].incrMatrix, this.transforms[this._bones[_loc_4].parent], this.transforms[_loc_4]);
                        }
                        else
                        {
                            this.transforms[_loc_4].copyFrom(this._bones[_loc_4].incrMatrix);
                        }
                    }
                    else
                    {
                        _loc_2.bones[_loc_2.lookup[this._bones[_loc_4].name]].calc(_loc_4, _loc_2, _loc_7, _loc_8);
                    }
                    _loc_4++;
                }
            }
            else
            {
                _loc_9 = _loc_2.bones.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_9)
                {
                    
                    if (this._boneLookup[_loc_2.bones[_loc_4].bone] !== undefined)
                    {
                        _loc_10 = this._boneLookup[_loc_2.bones[_loc_4].bone];
                        _loc_2.bones[_loc_4].calc(_loc_10, _loc_2, _loc_7, _loc_8);
                    }
                    else
                    {
                        _loc_15 = _loc_2.bones[(_loc_4 - 1)];
                        if ((_loc_15.idx + 1) < this.transforms.length)
                        {
                            this.transforms[(_loc_15.idx + 1)].copyFrom(this.transforms[_loc_15.idx]);
                        }
                        _loc_2.bones[_loc_4].idx = _loc_15.idx + 1;
                    }
                    _loc_4++;
                }
            }
            _loc_9 = Math.min(this.transforms.length, this.bones.length);
            _loc_4 = 0;
            while (_loc_4 < _loc_9)
            {
                
                MatrixUtil.multiply(this._bones[_loc_4].baseMatrix, this.transforms[_loc_4], this.transforms[_loc_4]);
                _loc_4++;
            }
            _loc_14 = this._vertices.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_14)
            {
                
                _loc_11 = this._vertices[_loc_4];
                _loc_10 = _loc_4 * 8;
                var _loc_20:* = 0;
                this._vbData[_loc_10 + 5] = 0;
                this._vbData[_loc_10 + 4] = _loc_20;
                this._vbData[_loc_10 + 3] = _loc_20;
                this._vbData[_loc_10 + 2] = _loc_20;
                this._vbData[(_loc_10 + 1)] = _loc_20;
                this._vbData[_loc_10] = _loc_20;
                _loc_5 = 0;
                while (_loc_5 < 4)
                {
                    
                    if (_loc_11.weights[_loc_5] > 0)
                    {
                        _loc_13 = _loc_11.weights[_loc_5];
                        _loc_12 = this.transforms[_loc_11.bones[_loc_5]];
                        MatrixUtil.transform(_loc_12, _loc_11.position, this.tmpVec);
                        this._vbData[_loc_10] = this._vbData[_loc_10] + this.tmpVec.x * _loc_13;
                        this._vbData[(_loc_10 + 1)] = this._vbData[(_loc_10 + 1)] + this.tmpVec.y * _loc_13;
                        this._vbData[_loc_10 + 2] = this._vbData[_loc_10 + 2] + this.tmpVec.z * _loc_13;
                        MatrixUtil.transform(_loc_12, _loc_11.normal, this.tmpVec);
                        this._vbData[_loc_10 + 3] = this._vbData[_loc_10 + 3] + this.tmpVec.x * _loc_13;
                        this._vbData[_loc_10 + 4] = this._vbData[_loc_10 + 4] + this.tmpVec.y * _loc_13;
                        this._vbData[_loc_10 + 5] = this._vbData[_loc_10 + 5] + this.tmpVec.z * _loc_13;
                    }
                    _loc_5++;
                }
                _loc_4++;
            }
            if (!this._boundsAnimated)
            {
                this._boundsMin = new Vector3D(9999, 9999, 9999);
                this._boundsMax = new Vector3D(-9999, -9999, -9999);
                this._boundsAnimated = true;
                if (this._meshes && this._meshes.length > 0)
                {
                    _loc_16 = this._meshes.length;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_16)
                    {
                        _loc_17 = this._meshes[_loc_4].iStart;
                        _loc_18 = this._meshes[_loc_4].iCount;
                        _loc_5 = 0;
                        while (_loc_5 < _loc_18)
                        {
                            
                            _loc_11 = this._vertices[this._indices[_loc_17 + _loc_5]];
                            _loc_10 = this._indices[_loc_17 + _loc_5] * 8;
                            this._boundsMin.x = Math.min(this._boundsMin.x, this._vbData[_loc_10]);
                            this._boundsMin.y = Math.min(this._boundsMin.y, Math.max(0, this._vbData[(_loc_10 + 1)]));
                            this._boundsMin.z = Math.min(this._boundsMin.z, this._vbData[_loc_10 + 2]);
                            this._boundsMax.x = Math.max(this._boundsMax.x, this._vbData[_loc_10]);
                            this._boundsMax.y = Math.max(this._boundsMax.y, this._vbData[(_loc_10 + 1)]);
                            this._boundsMax.z = Math.max(this._boundsMax.z, this._vbData[_loc_10 + 2]);
                            _loc_5++;
                        }
                        _loc_4++;
                    }
                }
                else
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_14)
                    {
                        
                        _loc_11 = this._vertices[_loc_4];
                        _loc_10 = _loc_4 * 8;
                        this._boundsMin.x = Math.min(this._boundsMin.x, this._vbData[_loc_10]);
                        this._boundsMin.y = Math.min(this._boundsMin.y, Math.max(0, this._vbData[(_loc_10 + 1)]));
                        this._boundsMin.z = Math.min(this._boundsMin.z, this._vbData[_loc_10 + 2]);
                        this._boundsMax.x = Math.max(this._boundsMax.x, this._vbData[_loc_10]);
                        this._boundsMax.y = Math.max(this._boundsMax.y, this._vbData[(_loc_10 + 1)]);
                        this._boundsMax.z = Math.max(this._boundsMax.z, this._vbData[_loc_10 + 2]);
                        _loc_4++;
                    }
                }
                this._calcBounds();
            }
            this.updateBuffers(false);
            if (this._children)
            {
                _loc_4 = 0;
                while (_loc_4 < this._children.length)
                {
                    
                    this._children[_loc_4].update(param1);
                    _loc_4++;
                }
            }
            
        }

        override public function render(param1:Number, param2:Boolean = true) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = false;
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
            context.setVertexBufferAt(0, this._vb, 0, "float3");
            context.setVertexBufferAt(1, this._vb, 3, "float3");
            context.setVertexBufferAt(2, this._vb, 6, "float2");
            var _loc_3:* = null;
            if (this._texture && this._texture.good)
            {
                if (!this._hasTexture)
                {
                    this._hasTexture = true;
                    upload();
                }
                _loc_3 = this._texture.texture;
            }
            context.setProgram(_program);
            if (this._meshes && this._meshes.length > 0)
            {
                _loc_4 = null;
                if (this._animations)
                {
                    _loc_4 = this._animations[this._currentAnimation];
                }
                _loc_5 = 0;
                while (_loc_5 < this._meshes.length)
                {
                    
                    if (this._metaData != null)
                    {
                        _loc_6 = this._metaData.meshVis[this._meshes[_loc_5].name];
                        if (_loc_4 != null && this._metaData.animMeshVis[_loc_4.name] !== undefined && this._metaData.animMeshVis[_loc_4.name][this._meshes[_loc_5].name] !== undefined)
                        {
                            _loc_6 = this._metaData.animMeshVis[_loc_4.name][this._meshes[_loc_5].name];
                        }
                        if (!_loc_6)
                        {
                        }
                        if (this._meshTextures[this._meshes[_loc_5].name] !== undefined && _loc_3 && this._meshTextures[this._meshes[_loc_5].name].good)
                        {
                            context.setTextureAt(0, this._meshTextures[this._meshes[_loc_5].name].texture);
                        }
                        else
                        {
                            context.setTextureAt(0, _loc_3);
                        }
                    }
                    else
                    {
                        context.setTextureAt(0, _loc_3);
                    }
                    context.drawTriangles(this._ib, this._meshes[_loc_5].iStart, this._meshes[_loc_5].iCount / 3);
                    _loc_5++;
                }
            }
            else
            {
                context.setTextureAt(0, _loc_3);
                context.drawTriangles(this._ib);
            }
            if (this._children)
            {
                _loc_5 = 0;
                while (_loc_5 < this._children.length)
                {
                    
                    this._children[_loc_5].render(param1, false);
                    _loc_5++;
                }
            }
            
        }

        override protected function _vertexShader() : void
        {
            op("m44 op, va0, vc0");
            op("mov v0, va2");
            op("m44 v1, va1, vc4");
            
        }

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
            
        }

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
            if (!this._vb)
            {
                this._vb = context.createVertexBuffer(this._vertices.length, _loc_2);
            }
            this._vb.uploadFromVector(this._vbData, 0, this._vertices.length);
            if (!this._ib)
            {
                this._ib = context.createIndexBuffer(this._indices.length);
                this._ib.uploadFromVector(this._indices, 0, this._indices.length);
            }
            this._ready = true;
            
        }

        private function readMeta(event:FileLoadEvent) : void
        {
			trace("readMeta." + (event.target.data));
            var _loc_2:* = null;
            this._metaData = JSON.parse(event.target.data);
            if (this._animations)
            {
                this.calcBounds();
            }
            for (_loc_2 in this._metaData.meshTextures)
            {
                //this._meshTextures[_loc_2] = new LolTexture(viewer, this.model + "/" + _loc_4[_loc_2] + ".png");
            }
        }

        private function readMesh(event:FileLoadEvent) : void
        {
			trace("readMesh.");
            var i:int;
            var textureFile:String;
            var animFile:String;
            var magic:uint;
            var numMeshes:uint;
            var numVerts:uint;
            var numIndices:uint;
            var numBones:uint;
            var name:String;
            var vertexStart:uint;
            var vertexCount:uint;
            var indexStart:uint;
            var indexCount:uint;
            var loader:ZamLoader;
            var url:String;
            var e:* = event;
            var data:* = e.target.data;
            data.endian = Endian.LITTLE_ENDIAN;

			magic = data.readUnsignedInt();
			if (magic != 604210091)
			{
				
			}
			this._version = data.readUnsignedInt();
			animFile = data.readUTF();
			textureFile = data.readUTF();
			numMeshes = data.readUnsignedInt();
			if (numMeshes > 0)
			{
				this._meshes = new Vector.<Object>(numMeshes);
				i=0;
				while (i < numMeshes)
				{
					
					name = data.readUTF().toLowerCase();
					vertexStart = data.readUnsignedInt();
					vertexCount = data.readUnsignedInt();
					indexStart = data.readUnsignedInt();
					indexCount = data.readUnsignedInt();
					this._meshes[i] = {name:name, vStart:vertexStart, vCount:vertexCount, iStart:indexStart, iCount:indexCount};
					i = (i + 1);
				}
			}
			numVerts = data.readUnsignedInt();
			this._vertices = new Vector.<Vertex>(numVerts);
			i=0;
			while (i < numVerts)
			{
				
				this._vertices[i] = new Vertex();
				this._vertices[i].read(data);
				i = (i + 1);
			}
			numIndices = data.readUnsignedInt();
			this._indices = new Vector.<uint>(numIndices);
			i=0;
			while (i < numIndices)
			{
				
				this._indices[i] = data.readUnsignedShort();
				i = (i + 1);
			}
			numBones = data.readUnsignedInt();
			this.transforms = new Vector.<Matrix3D>(numBones);
			this._bones = new Vector.<Bone>(numBones);
			i=0;
			while (i < numBones)
			{
				
				this._bones[i] = new Bone(this, i);
				this._bones[i].read(data, this._version);
				if (this._boneLookup[this._bones[i].name] !== undefined)
				{
					this.bones[i].name = this.bones[i].name + "2";
				}
				if (this._fixedModelBones[this.model] && this._fixedModelBones[this.model][this.skinId] && this._fixedModelBones[this.model][this.skinId][this.bones[i].name])
				{
					this.bones[i].fixed = true;
				}
				this._boneLookup[this._bones[i].name] = i;
				this.transforms[i] = new Matrix3D();
				i = (i + 1);
			}

            if (animFile && animFile.length > 0)
            {
                loader = new ZamLoader();
                loader.dataFormat = URLLoaderDataFormat.BINARY;
                loader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.readAnim, false, 0, true);
                loader.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
                loader.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
                loader.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
                url = "models/" + animFile + ".jpg";
				loader.load(new URLRequest(_contentPath + url.toLowerCase()));
				this._animsLoading = true;
            }
            if (textureFile && textureFile.length > 0)
            {
                this._texture = new LolTexture(viewer, this.model + "/" + textureFile + ".png");
            }
            upload();
            this.updateBuffers();
            this.calcBounds();
            
        }

        private function readAnim(event:FileLoadEvent) : void
        {
            var i:int;
            var magic:uint;
            var version:uint;
            var numAnims:uint;
            var newData:ByteArray;
            var e:* = event;
            var data:* = e.target.data;
            data.endian = Endian.LITTLE_ENDIAN;

			magic = data.readUnsignedInt();
			if (magic != 604210092)
			{
				
			}
			version = data.readUnsignedInt();
			if (version >= 2)
			{
				newData = new ByteArray();
				newData.endian = Endian.LITTLE_ENDIAN;
				data.readBytes(newData);
				newData.uncompress();
				data = newData;
			}
			numAnims = data.readUnsignedInt();
			this._animations = new Vector.<Animation>(numAnims);
			i;
			while (i < numAnims)
			{
				
				this._animations[i] = new Animation(this);
				this._animations[i].read(data);
				i = (i + 1);
			}

            this._animsLoading = false;
            
        }

        public function onClickBone(event:MouseEvent) : void
        {
            var _loc_2:* = this._debugLookup[event.target.text];
            this._bones[_loc_2].fixed = !this._bones[_loc_2].fixed;
            var _loc_3:* = this._bones[_loc_2].incrMatrix;
            var _loc_4:* = this._animations[this._currentAnimation];
            if (_loc_4.lookup[this._bones[_loc_2].name] !== undefined)
            {
                _loc_4.bones[_loc_4.lookup[this._bones[_loc_2].name]].dump(_loc_2);
            }
            
        }

        public function onClickAnim(event:MouseEvent) : void
        {
            this.setAnimation(event.target.text);
            
        }

        private function calcBounds() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = false;
            var _loc_8:* = 0;
            this._boundsMin = new Vector3D(9999, 9999, 9999);
            this._boundsMax = new Vector3D(-9999, -9999, -9999);
            this._boundsCenter = new Vector3D();
            this._boundsSize = new Vector3D();
            if (this._meshes && this._meshes.length > 0)
            {
                _loc_4 = this._meshes.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_4)
                {
                    _loc_5 = this._meshes[_loc_2].iStart;
                    _loc_6 = this._meshes[_loc_2].iCount;
                    _loc_3 = 0;
                    while (_loc_3 < _loc_6)
                    {
                        
                        _loc_1 = this._vertices[this._indices[_loc_5 + _loc_3]].position;
                        this._boundsMin.x = Math.min(this._boundsMin.x, _loc_1.x);
                        this._boundsMin.y = Math.min(this._boundsMin.y, _loc_1.y);
                        this._boundsMin.z = Math.min(this._boundsMin.z, _loc_1.z);
                        this._boundsMax.x = Math.max(this._boundsMax.x, _loc_1.x);
                        this._boundsMax.y = Math.max(this._boundsMax.y, _loc_1.y);
                        this._boundsMax.z = Math.max(this._boundsMax.z, _loc_1.z);
                        _loc_3++;
                    }
                    _loc_2++;
                }
            }
            else
            {
                _loc_8 = this._vertices.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_8)
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
            }
            this._calcBounds();
            
        }

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
            var _loc_18:* = null;
            var _loc_19:* = null;
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
                if (this._children)
                {
                    _loc_18 = null;
                    if (params.otherOffsets)
                    {
                        _loc_18 = params.otherOffsets.split(",");
                        _loc_1 = 0;
                        while (_loc_1 < _loc_18.length)
                        {
                            
                            _loc_18[_loc_1] = _loc_18[_loc_1].split(" ");
                            if (_loc_18[_loc_1].length != 3)
                            {
                                _loc_18[_loc_1] = [0, 0, 0];
                            }
                            _loc_1++;
                        }
                    }
                    _loc_19 = this.Vector.<int>([1, -1, 2, -2, 3, -3, 4, -4]);
                    _loc_1 = 0;
                    while (_loc_1 < this._children.length)
                    {
                        
                        if (_loc_18 && _loc_18[_loc_1])
                        {
                            this._children[_loc_1].offset.setTo(_loc_18[_loc_1][0], _loc_18[_loc_1][1], _loc_18[_loc_1][2]);
                        }
                        else
                        {
                            this._children[_loc_1].offset.setTo(this._boundsSize.x * 1.75 * _loc_19[_loc_1], 0, (-this._boundsSize.z) * Math.abs(_loc_19[_loc_1]));
                        }
                        _loc_1++;
                    }
                    _loc_16 = _loc_16 + Math.ceil(this._children.length / 2);
                }
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
            
        }

        override public function registerExternalInterface() : void
        {
            ExternalInterface.addCallback("getNumAnimations", this.extGetNumAnimations);
            ExternalInterface.addCallback("getAnimation", this.extGetAnimation);
            ExternalInterface.addCallback("setAnimation", this.extSetAnimation);
            ExternalInterface.addCallback("isLoaded", this.extIsLoaded);
            
        }

        public function extGetNumAnimations() : int
        {
            return this._animations ? (this._animations.length) : (0);
        }

        public function extGetAnimation(param1:int) : String
        {
            if (this._animations && param1 > -1 && param1 < this._animations.length)
            {
                return this._animations[param1].name;
            }
            return "";
        }

        public function extSetAnimation(param1:String) : void
        {
            this.setAnimation(param1.toLowerCase());
            
        }

        public function extIsLoaded() : Boolean
        {
            return this._ready && !this._animsLoading;
        }

        private function onLoadStart(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_START, event.url);
            _viewer.dispatchEvent(_loc_2);
            
        }

        private function onLoadProgress(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, event.url, event.currentBytes, event.totalBytes);
            _viewer.dispatchEvent(_loc_2);
            
        }

        private function onLoadError(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, event.url, -1, -1, event.errorMessage);
            _viewer.dispatchEvent(_loc_2);
            
        }

    }
}
