package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import flash.utils.*;

    public class WowParticleEmitter extends Shader
    {
        public var id:int;
        public var flags:uint;
        public var flags2:uint;
        public var position:Vector3D;
        public var bone:int;
        public var texture:int;
        public var blendMode:int;
        public var emitterType:int;
        public var particleType:int;
        public var headTail:int;
        public var tileRotation:uint;
        public var tileRows:uint;
        public var tileColumns:uint;
        public var scale:Vector3D;
        public var slowdown:Number;
        public var rotation:Vector3D;
        public var modelRotation1:Vector3D;
        public var modelRotation2:Vector3D;
        public var modelTranslation:Vector3D;
        public var modelPath:String;
        public var particlePath:String;
        public var emissionSpeed:Vector.<AnimatedFloat>;
        public var speedVariation:Vector.<AnimatedFloat>;
        public var verticalRange:Vector.<AnimatedFloat>;
        public var horizontalRange:Vector.<AnimatedFloat>;
        public var gravity:Vector.<AnimatedFloat>;
        public var lifespan:Vector.<AnimatedFloat>;
        public var emissionRate:Vector.<AnimatedFloat>;
        public var areaLength:Vector.<AnimatedFloat>;
        public var areaWidth:Vector.<AnimatedFloat>;
        public var gravity2:Vector.<AnimatedFloat>;
        public var color:AnimatedSimpleVector3D;
        public var alpha:AnimatedSimpleUShort;
        public var size:AnimatedSimpleVector2D;
        public var intensity:AnimatedSimpleUShort;
        public var enabled:Vector.<AnimatedByte>;
        public var mesh:WowModel;
        public var parent:WowBone;
        public var particles:Vector.<Particle>;
        public var unusedParticles:Vector.<int>;
        public var textureCoords:Vector.<Array>;
        private var _vb:VertexBuffer3D;
        private var _ib:IndexBuffer3D;
        private var _vbData:Vector.<Number>;
        private var _numTriangles:int;
        private var _hasTexture:Boolean;
        private var spawnRemainder:Number;
        private var spreadMat:Matrix3D;
        private var tmpMat1:Matrix3D;
        private var tmpMat2:Matrix3D;
        private var tmpVec:Vector3D;
        private var tmpVec1:Vector3D;
        private var tmpVec2:Vector3D;
        private var tmpData:Vector.<Number>;
        private var tmpColors:Vector.<Color>;
        public const MAX_PARTICLES:int = 500;

        public function WowParticleEmitter(param1:WowModel)
        {
            super(param1.viewer);
            this.mesh = param1;
            this.spreadMat = new Matrix3D();
            this.tmpMat1 = new Matrix3D();
            this.tmpMat2 = new Matrix3D();
            this.tmpVec = new Vector3D();
            this.tmpVec1 = new Vector3D();
            this.tmpVec2 = new Vector3D();
            this.tmpData = new Vector.<Number>(16);
            this.tmpColors = this.Vector.<Color>([new Color(), new Color(), new Color()]);
            this._vbData = new Vector.<Number>(this.MAX_PARTICLES * 4 * 11);
            this.particles = new Vector.<Particle>(this.MAX_PARTICLES);
            this.unusedParticles = new Vector.<int>;
            var _loc_2:* = this.MAX_PARTICLES - 1;
            while (_loc_2 >= 0)
            {
                
                this.unusedParticles.push(_loc_2);
                _loc_2 = _loc_2 - 1;
            }
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
            upload();
            return;
        }// end function

        public function init() : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            if (this.scale.z == 519)
            {
                this.scale.z = 1.5;
            }
            var _loc_1:* = this.tileRows * this.tileColumns;
            this.textureCoords = new Vector.<Array>(_loc_1);
            var _loc_2:* = {x:0, y:0};
            var _loc_3:* = {x:0, y:0};
            _loc_4 = 0;
            while (_loc_4 < _loc_1)
            {
                
                _loc_6 = _loc_4 % this.tileColumns;
                _loc_7 = Math.floor(_loc_4 / this.tileColumns);
                _loc_2.x = _loc_6 * (1 / this.tileColumns);
                _loc_3.x = (_loc_6 + 1) * (1 / this.tileColumns);
                _loc_2.y = _loc_7 * (1 / this.tileRows);
                _loc_3.y = (_loc_7 + 1) * (1 / this.tileRows);
                this.textureCoords[_loc_4] = [{x:_loc_2.x, y:_loc_2.y, z:-1, w:1}, {x:_loc_3.x, y:_loc_2.y, z:1, w:1}, {x:_loc_2.x, y:_loc_3.y, z:-1, w:-1}, {x:_loc_3.x, y:_loc_3.y, z:1, w:-1}];
                _loc_4++;
            }
            upload();
            return;
        }// end function

        public function update(param1:int, param2:int, param3:Number) : void
        {
            var _loc_6:* = NaN;
            var _loc_7:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            var _loc_17:* = null;
            var _loc_18:* = null;
            var _loc_19:* = null;
            var _loc_20:* = null;
            var _loc_21:* = null;
            var _loc_22:* = null;
            var _loc_23:* = NaN;
            var _loc_24:* = NaN;
            var _loc_25:* = NaN;
            var _loc_26:* = 0;
            var _loc_27:* = NaN;
            var _loc_28:* = NaN;
            var _loc_29:* = NaN;
            var _loc_30:* = NaN;
            var _loc_31:* = NaN;
            var _loc_32:* = false;
            var _loc_4:* = AnimatedFloat.getValueFrom(this.gravity, param1, param2);
            var _loc_5:* = AnimatedFloat.getValueFrom(this.gravity2, param1, param2);
            if (this.emitterType == 1 || this.emitterType == 2)
            {
                _loc_23 = AnimatedFloat.getValueFrom(this.emissionRate, param1, param2);
                _loc_24 = AnimatedFloat.getValueFrom(this.lifespan, param1, param2);
                _loc_25 = 0;
                if (_loc_24 != 0)
                {
                    _loc_25 = param3 * _loc_23 / _loc_24 + this.spawnRemainder;
                }
                else
                {
                    _loc_25 = this.spawnRemainder;
                }
                if (_loc_25 < 1)
                {
                    this.spawnRemainder = _loc_25;
                    if (this.spawnRemainder < 0)
                    {
                        this.spawnRemainder = 0;
                    }
                }
                else
                {
                    _loc_26 = Math.floor(_loc_25);
                    if (_loc_26 > this.unusedParticles.length)
                    {
                        _loc_26 = this.unusedParticles.length;
                    }
                    this.spawnRemainder = _loc_25 - _loc_26;
                    _loc_27 = AnimatedFloat.getValueFrom(this.areaWidth, param1, param2) * 0.5;
                    _loc_28 = AnimatedFloat.getValueFrom(this.areaLength, param1, param2) * 0.5;
                    _loc_6 = AnimatedFloat.getValueFrom(this.emissionSpeed, param1, param2);
                    _loc_29 = AnimatedFloat.getValueFrom(this.speedVariation, param1, param2);
                    _loc_30 = AnimatedFloat.getValueFrom(this.verticalRange, param1, param2);
                    _loc_31 = AnimatedFloat.getValueFrom(this.horizontalRange, param1, param2);
                    _loc_32 = true;
                    if (AnimatedByte.isUsed(this.enabled, param1))
                    {
                        _loc_32 = AnimatedByte.getValueFrom(this.enabled, param1, param2) != 0;
                    }
                    if (_loc_32 && _loc_26 > 0)
                    {
                        _loc_7 = 0;
                        while (_loc_7 < _loc_26)
                        {
                            
                            if (this.emitterType == 1)
                            {
                                this.spawnPlaneParticle(_loc_27, _loc_28, _loc_6, _loc_29, _loc_24);
                            }
                            else if (this.emitterType == 2)
                            {
                                this.spawnSphereParticle(_loc_27, _loc_28, _loc_6, _loc_29, _loc_30, _loc_31, _loc_24);
                            }
                            _loc_7++;
                        }
                    }
                }
                if (isNaN(this.spawnRemainder))
                {
                    this.spawnRemainder = 0;
                }
            }
            _loc_6 = 1;
            var _loc_8:* = _loc_4 * param3;
            var _loc_9:* = _loc_5 * param3;
            var _loc_10:* = _loc_6 * param3;
            _loc_18 = this.size._data[0];
            if (this.size._data.length > 2)
            {
                _loc_19 = this.size._data[1];
                _loc_20 = this.size._data[2];
            }
            else if (this.size._data.length > 1)
            {
                _loc_19 = this.size._data[1];
                _loc_20 = _loc_19;
            }
            else
            {
                var _loc_33:* = _loc_18;
                _loc_19 = _loc_18;
                _loc_20 = _loc_33;
            }
            _loc_7 = 0;
            while (_loc_7 < this.MAX_PARTICLES)
            {
                
                _loc_11 = this.particles[_loc_7];
                if (!_loc_11 || _loc_11.maxLife == 0)
                {
                }
                else
                {
                    _loc_11.life = _loc_11.life + param3;
                    _loc_12 = _loc_11.life / _loc_11.maxLife;
                    if (_loc_12 >= 1)
                    {
                        _loc_11.maxLife = 0;
                        this.unusedParticles.push(_loc_7);
                    }
                    else
                    {
                        _loc_11.speed.x = _loc_11.speed.x + (_loc_11.down.x * _loc_8 - _loc_11.direction.x * _loc_9);
                        _loc_11.speed.y = _loc_11.speed.y + (_loc_11.down.y * _loc_8 - _loc_11.direction.y * _loc_9);
                        _loc_11.speed.z = _loc_11.speed.z + (_loc_11.down.z * _loc_8 - _loc_11.direction.z * _loc_9);
                        if (this.slowdown > 0)
                        {
                            _loc_6 = Math.exp(-1 * this.slowdown * _loc_11.life);
                            _loc_10 = _loc_6 * param3;
                        }
                        _loc_11.position.x = _loc_11.position.x + _loc_11.speed.x * _loc_10;
                        _loc_11.position.y = _loc_11.position.y + _loc_11.speed.y * _loc_10;
                        _loc_11.position.z = _loc_11.position.z + _loc_11.speed.z * _loc_10;
                        if (_loc_12 <= 0.5)
                        {
                            _loc_11.size = VectorUtil.interpolate(_loc_18, _loc_19, _loc_12 / 0.5, _loc_11.size);
                        }
                        else
                        {
                            _loc_11.size = VectorUtil.interpolate(_loc_19, _loc_20, (_loc_12 - 0.5) / 0.5, _loc_11.size);
                        }
                        _loc_11.size.x = _loc_11.size.x * this.scale.x;
                        _loc_11.size.y = _loc_11.size.y * this.scale.z;
                        _loc_16 = Math.min(3, this.color._data.length);
                        _loc_15 = 0;
                        while (_loc_15 < _loc_16)
                        {
                            
                            _loc_17 = this.color._data[_loc_15];
                            this.tmpColors[_loc_15].reset(_loc_17.x / 255, _loc_17.y / 255, _loc_17.z / 255, this.alpha._data[_loc_15] / 32767);
                            _loc_15++;
                        }
                        if (_loc_16 < 3)
                        {
                            _loc_17 = this.color._data[(_loc_16 - 1)];
                            _loc_15 = _loc_16;
                            while (_loc_15 < 3)
                            {
                                
                                this.tmpColors[_loc_15].reset(_loc_17.x / 255, _loc_17.y / 255, _loc_17.z / 255, this.alpha._data[_loc_15] / 32767);
                                _loc_15++;
                            }
                        }
                        if (_loc_12 <= 0.5)
                        {
                            _loc_21 = this.tmpColors[0];
                            _loc_22 = this.tmpColors[1];
                            _loc_13 = _loc_12 / 0.5;
                        }
                        else
                        {
                            _loc_21 = this.tmpColors[1];
                            _loc_22 = this.tmpColors[2];
                            _loc_13 = (_loc_12 - 0.5) / 0.5;
                        }
                        _loc_11.color.r = _loc_21.r + (_loc_22.r - _loc_21.r) * _loc_13;
                        _loc_11.color.g = _loc_21.g + (_loc_22.g - _loc_21.g) * _loc_13;
                        _loc_11.color.b = _loc_21.b + (_loc_22.b - _loc_21.b) * _loc_13;
                        _loc_11.color.a = _loc_21.a + (_loc_22.a - _loc_21.a) * _loc_13;
                    }
                }
                _loc_7++;
            }
            this.updateBuffers();
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            op("m44 vt0, va0, vc12");
            op("add vt0.xy, vt0.xy, va2.zw");
            op("m44 op, vt0, vc20");
            op("mov v0, va2.xy");
            op("mov v1, va1");
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
            op("mul ft0, ft0, v1");
            if (this.blendMode == 1)
            {
                op("sub ft1.w, ft0.w, fc7.x");
                op("kil ft1.w");
            }
            op("mov oc, ft0");
            return;
        }// end function

        public function render() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (this.unusedParticles.length == this.MAX_PARTICLES)
            {
                return;
            }
            if (this.texture > -1 && this.texture < this.mesh._materials.length)
            {
                _loc_2 = this.mesh._materials[this.texture];
                if (_loc_2._texture && _loc_2._texture.good)
                {
                    _loc_1 = _loc_2._texture.texture;
                }
                if (_loc_1 && !this._hasTexture)
                {
                    this._hasTexture = true;
                    upload();
                }
                context.setTextureAt(0, _loc_1);
            }
            context.setProgram(_program);
            context.setCulling(Context3DTriangleFace.NONE);
            context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
            switch(this.blendMode)
            {
                case 0:
                case 1:
                {
                    context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
                    break;
                }
                case 2:
                {
                    context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
                    break;
                }
                case 3:
                {
                    context.setBlendFactors(Context3DBlendFactor.SOURCE_COLOR, Context3DBlendFactor.ONE);
                    break;
                }
                case 4:
                {
                    context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
                    break;
                }
                case 5:
                case 6:
                {
                    context.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.SOURCE_COLOR);
                    break;
                }
                default:
                {
                    context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                    break;
                    break;
                }
            }
            context.setVertexBufferAt(0, this._vb, 0, "float3");
            context.setVertexBufferAt(1, this._vb, 3, "float4");
            context.setVertexBufferAt(2, this._vb, 7, "float4");
            context.drawTriangles(this._ib, 0, this._numTriangles);
            return;
        }// end function

        public function updateBuffers() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            if (!this._ib)
            {
                this._ib = context.createIndexBuffer(this.MAX_PARTICLES * 6);
                _loc_6 = new Vector.<uint>;
                _loc_7 = 0;
                _loc_1 = 0;
                while (_loc_1 < this.MAX_PARTICLES)
                {
                    
                    _loc_6.push(_loc_7);
                    _loc_6.push((_loc_7 + 1));
                    _loc_6.push(_loc_7 + 2);
                    _loc_6.push(_loc_7 + 2);
                    _loc_6.push((_loc_7 + 1));
                    _loc_6.push(_loc_7 + 3);
                    _loc_7 = _loc_7 + 4;
                    _loc_1++;
                }
                this._ib.uploadFromVector(_loc_6, 0, _loc_6.length);
            }
            if (!this._vb)
            {
                this._vb = context.createVertexBuffer(this.MAX_PARTICLES * 4, 11);
            }
            this._numTriangles = 0;
            if (this.particleType == 0 || this.particleType == 2)
            {
                _loc_1 = 0;
                while (_loc_1 < this.MAX_PARTICLES)
                {
                    
                    _loc_4 = this.particles[_loc_1];
                    if (!_loc_4 || _loc_4.maxLife == 0)
                    {
                    }
                    else
                    {
                        _loc_5 = this.textureCoords[_loc_4.tile];
                        _loc_2 = 0;
                        while (_loc_2 < 4)
                        {
                            
                            this._vbData[_loc_3] = _loc_4.position.x;
                            this._vbData[(_loc_3 + 1)] = _loc_4.position.y;
                            this._vbData[_loc_3 + 2] = _loc_4.position.z;
                            this._vbData[_loc_3 + 3] = _loc_4.color.r;
                            this._vbData[_loc_3 + 4] = _loc_4.color.g;
                            this._vbData[_loc_3 + 5] = _loc_4.color.b;
                            this._vbData[_loc_3 + 6] = _loc_4.color.a;
                            this._vbData[_loc_3 + 7] = _loc_5[_loc_2].x;
                            this._vbData[_loc_3 + 8] = _loc_5[_loc_2].y;
                            this._vbData[_loc_3 + 9] = _loc_5[_loc_2].z * _loc_4.size.x;
                            this._vbData[_loc_3 + 10] = _loc_5[_loc_2].w * _loc_4.size.y;
                            _loc_3 = _loc_3 + 11;
                            _loc_2++;
                        }
                        this._numTriangles = this._numTriangles + 2;
                    }
                    _loc_1++;
                }
            }
            else
            {
                _loc_1 = 0;
                while (_loc_1 < this.MAX_PARTICLES)
                {
                    
                    _loc_4 = this.particles[_loc_1];
                    if (!_loc_4 || _loc_4.maxLife == 0)
                    {
                    }
                    else
                    {
                        _loc_5 = this.textureCoords[_loc_4.tile];
                        this._vbData[_loc_3] = _loc_4.position.x;
                        this._vbData[(_loc_3 + 1)] = _loc_4.position.y;
                        this._vbData[_loc_3 + 2] = _loc_4.position.z;
                        this._vbData[_loc_3 + 11] = _loc_4.position.x;
                        this._vbData[_loc_3 + 12] = _loc_4.position.y;
                        this._vbData[_loc_3 + 13] = _loc_4.position.z;
                        this._vbData[_loc_3 + 22] = _loc_4.origin.x;
                        this._vbData[_loc_3 + 23] = _loc_4.origin.y;
                        this._vbData[_loc_3 + 24] = _loc_4.origin.z;
                        this._vbData[_loc_3 + 33] = _loc_4.origin.x;
                        this._vbData[_loc_3 + 34] = _loc_4.origin.y;
                        this._vbData[_loc_3 + 35] = _loc_4.origin.z;
                        _loc_2 = 0;
                        while (_loc_2 < 4)
                        {
                            
                            this._vbData[_loc_3 + 3] = _loc_4.color.r;
                            this._vbData[_loc_3 + 4] = _loc_4.color.g;
                            this._vbData[_loc_3 + 5] = _loc_4.color.b;
                            this._vbData[_loc_3 + 6] = _loc_4.color.a;
                            this._vbData[_loc_3 + 7] = _loc_5[_loc_2].x;
                            this._vbData[_loc_3 + 8] = _loc_5[_loc_2].y;
                            this._vbData[_loc_3 + 9] = _loc_5[_loc_2].z * _loc_4.size.x;
                            this._vbData[_loc_3 + 10] = _loc_5[_loc_2].w * _loc_4.size.y;
                            _loc_3 = _loc_3 + 11;
                            _loc_2++;
                        }
                        this._numTriangles = this._numTriangles + 2;
                    }
                    _loc_1++;
                }
            }
            this._vb.uploadFromVector(this._vbData, 0, this.MAX_PARTICLES * 4);
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.id = param1.readInt();
            this.flags = param1.readUnsignedInt();
            this.flags2 = param1.readUnsignedShort();
            this.position = WowUtil.readVector3D(param1);
            this.bone = param1.readShort();
            this.texture = param1.readShort();
            this.blendMode = param1.readByte();
            this.emitterType = param1.readByte();
            this.particleType = param1.readByte();
            this.headTail = param1.readByte();
            this.tileRotation = param1.readUnsignedShort();
            this.tileRows = param1.readUnsignedShort();
            this.tileColumns = param1.readUnsignedShort();
            this.scale = WowUtil.readVector3D(param1);
            this.slowdown = param1.readFloat();
            this.rotation = WowUtil.readVector3D(param1);
            this.modelRotation1 = WowUtil.readVector3D(param1);
            this.modelRotation2 = WowUtil.readVector3D(param1);
            this.modelTranslation = WowUtil.readVector3D(param1);
            this.modelPath = param1.readUTF();
            this.particlePath = param1.readUTF();
            this.emissionSpeed = WowUtil.readAnimatedFloatSet(param1);
            this.speedVariation = WowUtil.readAnimatedFloatSet(param1);
            this.verticalRange = WowUtil.readAnimatedFloatSet(param1);
            this.horizontalRange = WowUtil.readAnimatedFloatSet(param1);
            this.gravity = WowUtil.readAnimatedFloatSet(param1);
            this.lifespan = WowUtil.readAnimatedFloatSet(param1);
            this.emissionRate = WowUtil.readAnimatedFloatSet(param1);
            this.areaLength = WowUtil.readAnimatedFloatSet(param1);
            this.areaWidth = WowUtil.readAnimatedFloatSet(param1);
            this.gravity2 = WowUtil.readAnimatedFloatSet(param1);
            this.color = new AnimatedSimpleVector3D();
            this.color.read(param1, false);
            this.alpha = new AnimatedSimpleUShort();
            this.alpha.read(param1);
            this.size = new AnimatedSimpleVector2D();
            this.size.read(param1);
            this.intensity = new AnimatedSimpleUShort();
            this.intensity.read(param1);
            this.enabled = WowUtil.readAnimatedByteSet(param1);
            this.parent = this.mesh._bones[this.bone];
            this.init();
            return;
        }// end function

        public function getNextParticle() : Particle
        {
            if (this.unusedParticles.length == 0)
            {
                return null;
            }
            var _loc_1:* = this.unusedParticles.pop();
            if (!this.particles[_loc_1])
            {
                this.particles[_loc_1] = new Particle();
            }
            return this.particles[_loc_1];
        }// end function

        public function spawnPlaneParticle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Particle
        {
            var _loc_6:* = this.getNextParticle();
            _loc_6.position.copyFrom(this.position);
            this.tmpVec.setTo((-param1) / 2 + param1 * Math.random(), 0, (-param2) / 2 + param2 * Math.random());
            _loc_6.position.incrementBy(this.tmpVec);
            MatrixUtil.transformSelf(this.parent._matrix, _loc_6.position);
            _loc_6.direction.setTo(0, 1, 0);
            MatrixUtil.transformSelf(this.parent._rotMatrix, _loc_6.direction);
            _loc_6.direction.normalize();
            _loc_6.speed.copyFrom(_loc_6.direction);
            _loc_6.speed.scaleBy(ZamUtil.interpolate(param3 - param3 * param4, param3 + param3 * param4, Math.random()));
            _loc_6.down.setTo(0, -1, 0);
            _loc_6.life = 0;
            _loc_6.maxLife = param5 || 1;
            _loc_6.origin.copyFrom(_loc_6.position);
            _loc_6.tile = Math.floor(Math.random() * this.tileRows * this.tileColumns);
            _loc_6.color.reset(1, 1, 1, 1);
            return _loc_6;
        }// end function

        public function spawnSphereParticle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Particle
        {
            var _loc_8:* = this.getNextParticle();
            var _loc_9:* = Math.random();
            var _loc_10:* = 0;
            if (param5 == 0)
            {
                _loc_10 = Math.random() * Math.PI * 2 - Math.PI;
            }
            else
            {
                _loc_10 = Math.random() * param5 * 2 - param5;
            }
            this.tmpMat1.copyFrom(this.parent._rotMatrix);
            this.calcSpread(param5 * 2, param5 * 2, param1, param2);
            this.tmpMat1.prepend(this.spreadMat);
            if ((this.flags & 57) == 57 || (this.flags & 313) == 313)
            {
                _loc_8.position.copyFrom(this.position);
                _loc_8.direction.setTo(param1 * Math.cos(_loc_10) * 1.6, 0, param2 * Math.sin(_loc_10) * 1.6);
                _loc_8.position.x = _loc_8.position.x + _loc_8.direction.x;
                _loc_8.position.z = _loc_8.position.z + _loc_8.direction.z;
                MatrixUtil.transformSelf(this.parent._matrix, _loc_8.position);
                if (_loc_8.direction.lengthSquared == 0)
                {
                    _loc_8.speed.setTo(0, 0, 0);
                }
                else
                {
                    MatrixUtil.transformSelf(this.parent._rotMatrix, _loc_8.direction);
                    _loc_8.direction.normalize();
                    _loc_8.speed.copyFrom(_loc_8.direction);
                    _loc_8.speed.scaleBy(param3 * (1 + Math.random() * param4 * 2 - param4));
                }
            }
            else
            {
                _loc_8.direction.setTo(0, 1, 0);
                MatrixUtil.transformSelf(this.tmpMat1, _loc_8.direction);
                _loc_8.direction.scaleBy(_loc_9);
                _loc_8.position.copyFrom(this.position);
                _loc_8.position.incrementBy(_loc_8.direction);
                MatrixUtil.transformSelf(this.parent._matrix, _loc_8.position);
                if (_loc_8.direction.lengthSquared == 0 && (this.flags & 256) == 0)
                {
                    _loc_8.speed.setTo(0, 0, 0);
                    _loc_8.direction.setTo(0, 1, 0);
                    MatrixUtil.transformSelf(this.parent._rotMatrix, _loc_8.direction);
                    _loc_8.direction.normalize();
                }
                else
                {
                    if ((this.flags & 256) > 0)
                    {
                        _loc_8.direction.setTo(0, 1, 0);
                        MatrixUtil.transformSelf(this.parent._rotMatrix, _loc_8.direction);
                    }
                    _loc_8.direction.normalize();
                    _loc_8.speed.copyFrom(_loc_8.direction);
                    _loc_8.speed.scaleBy(param3 * (1 + (Math.random() * param4 * 2 - param4)));
                }
            }
            _loc_8.down.setTo(0, -1, 0);
            _loc_8.life = 0;
            _loc_8.maxLife = param7;
            if (_loc_8.maxLife == 0)
            {
                _loc_8.maxLife = 1;
            }
            _loc_8.origin.copyFrom(_loc_8.position);
            _loc_8.tile = Math.floor(Math.random() * this.tileRows * this.tileColumns);
            _loc_8.color.reset(1, 1, 1, 1);
            return _loc_8;
        }// end function

        public function calcSpread(param1:Number, param2:Number, param3:Number, param4:Number) : Matrix3D
        {
            var _loc_5:* = (Math.random() * (param1 * 2) - param1) / 2;
            var _loc_6:* = (Math.random() * (param2 * 2) - param2) / 2;
            var _loc_7:* = Math.cos(_loc_5);
            var _loc_8:* = Math.cos(_loc_6);
            var _loc_9:* = Math.sin(_loc_5);
            var _loc_10:* = Math.sin(_loc_6);
            this.spreadMat.identity();
            var _loc_12:* = 1;
            this.tmpData[15] = 1;
            this.tmpData[10] = _loc_12;
            this.tmpData[5] = _loc_12;
            this.tmpData[0] = _loc_12;
            var _loc_12:* = 0;
            this.tmpData[14] = 0;
            this.tmpData[13] = _loc_12;
            this.tmpData[12] = _loc_12;
            this.tmpData[11] = _loc_12;
            this.tmpData[9] = _loc_12;
            this.tmpData[8] = _loc_12;
            this.tmpData[7] = _loc_12;
            this.tmpData[6] = _loc_12;
            this.tmpData[4] = _loc_12;
            this.tmpData[3] = _loc_12;
            this.tmpData[2] = _loc_12;
            this.tmpData[1] = _loc_12;
            var _loc_12:* = _loc_7;
            this.tmpData[10] = _loc_7;
            this.tmpData[5] = _loc_12;
            this.tmpData[9] = _loc_9;
            this.tmpData[6] = -_loc_9;
            this.tmpMat2.copyRawDataFrom(this.tmpData);
            this.spreadMat.prepend(this.tmpMat2);
            var _loc_12:* = 1;
            this.tmpData[15] = 1;
            this.tmpData[10] = _loc_12;
            this.tmpData[5] = _loc_12;
            this.tmpData[0] = _loc_12;
            var _loc_12:* = 0;
            this.tmpData[14] = 0;
            this.tmpData[13] = _loc_12;
            this.tmpData[12] = _loc_12;
            this.tmpData[11] = _loc_12;
            this.tmpData[9] = _loc_12;
            this.tmpData[8] = _loc_12;
            this.tmpData[7] = _loc_12;
            this.tmpData[6] = _loc_12;
            this.tmpData[4] = _loc_12;
            this.tmpData[3] = _loc_12;
            this.tmpData[2] = _loc_12;
            this.tmpData[1] = _loc_12;
            var _loc_12:* = _loc_8;
            this.tmpData[5] = _loc_8;
            this.tmpData[0] = _loc_12;
            this.tmpData[4] = _loc_10;
            this.tmpData[1] = -_loc_10;
            this.tmpMat2.copyRawDataFrom(this.tmpData);
            this.spreadMat.prepend(this.tmpMat2);
            var _loc_11:* = Math.abs(_loc_7) * param4 * Math.abs(_loc_9) * param3;
            this.spreadMat.copyRawDataTo(this.tmpData);
            this.tmpData[0] = this.tmpData[0] * _loc_11;
            this.tmpData[1] = this.tmpData[1] * _loc_11;
            this.tmpData[2] = this.tmpData[2] * _loc_11;
            this.tmpData[4] = this.tmpData[4] * _loc_11;
            this.tmpData[5] = this.tmpData[5] * _loc_11;
            this.tmpData[6] = this.tmpData[6] * _loc_11;
            this.tmpData[8] = this.tmpData[8] * _loc_11;
            this.tmpData[9] = this.tmpData[9] * _loc_11;
            this.tmpData[10] = this.tmpData[10] * _loc_11;
            this.spreadMat.copyRawDataFrom(this.tmpData);
            return this.spreadMat;
        }// end function

    }
}

import __AS3__.vec.*;

import com.zam.*;

import flash.display3D.*;

import flash.display3D.textures.*;

import flash.geom.*;

import flash.utils.*;

class Particle extends Object
{
    public var position:Vector3D;
    public var origin:Vector3D;
    public var speed:Vector3D;
    public var direction:Vector3D;
    public var down:Vector3D;
    public var color:Color;
    public var size:Vector3D;
    public var life:Number;
    public var maxLife:Number;
    public var tile:int;

    function Particle()
    {
        this.position = new Vector3D(0, 0, 0, 1);
        this.origin = new Vector3D(0, 0, 0, 1);
        this.speed = new Vector3D(0, 0, 0, 0);
        this.direction = new Vector3D(0, 0, 0, 0);
        this.down = new Vector3D(0, 0, 0, 0);
        this.color = new Color(1, 1, 1, 1);
        this.size = new Vector3D(0, 0, 0, 0);
        return;
    }// end function

}

