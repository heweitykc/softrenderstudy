package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import flash.utils.*;

    public class WowRibbonEmitter extends Shader
    {
        public var id:int;
        public var bone:int;
        public var position:Vector3D;
        public var resolution:Number;
        public var length:Number;
        public var emissionAngle:Number;
        public var s1:int;
        public var s2:int;
        public var textures:Vector.<int>;
        public var color:Vector.<AnimatedVector3D>;
        public var alpha:Vector.<AnimatedUShort>;
        public var above:Vector.<AnimatedFloat>;
        public var below:Vector.<AnimatedFloat>;
        public var totalLength:Number;
        public var mesh:WowModel;
        public var parent:WowBone;
        public var material:WowMaterial;
        public var segments:Vector.<RibbonSegment>;
        public var currentPosition:Vector3D;
        public var currentColor:Color;
        public var currentAbove:Number;
        public var currentBelow:Number;
        public var currentLength:Number;
        private var tmpPosition:Vector3D;
        private var tmpUp:Vector3D;
        private var tmpVec:Vector3D;
        private var _hasTexture:Boolean;
        private var _ib:IndexBuffer3D;
        private var _vb:VertexBuffer3D;
        private var _vbData:Vector.<Number>;
        private var _colorVector:Vector.<Number>;
        public const MAX_SEGMENTS:int = 50;
        public var currentSegment:int;
        public var numSegments:int;

        public function WowRibbonEmitter(param1:WowModel)
        {
            super(param1.viewer);
            this.mesh = param1;
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
            this.segments = new Vector.<RibbonSegment>(this.MAX_SEGMENTS);
            var _loc_1:* = 0;
            while (_loc_1 < this.MAX_SEGMENTS)
            {
                
                this.segments[_loc_1] = new RibbonSegment();
                _loc_1++;
            }
            this.currentPosition = this.position.clone();
            this.currentColor = new Color();
            this.tmpPosition = new Vector3D(0, 0, 0, 1);
            this.tmpUp = new Vector3D(0, 1, 0, 0);
            this.tmpVec = new Vector3D();
            this._vbData = new Vector.<Number>((this.MAX_SEGMENTS * 2 + 2) * 5);
            this._colorVector = this.Vector.<Number>([1, 1, 1, 1]);
            if (this.textures)
            {
                this.material = this.mesh._materials[this.textures[0]];
            }
            if (this.bone > -1)
            {
                this.parent = this.mesh._bones[this.bone];
            }
            this.totalLength = this.resolution / this.length;
            upload();
            return;
        }// end function

        public function update(param1:int, param2:int, param3:Number) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = NaN;
            MatrixUtil.transform(this.parent._matrix, this.position, this.tmpPosition);
            this.tmpUp.setTo(0, 1, 0);
            MatrixUtil.transformSelf(this.parent._rotMatrix, this.tmpUp);
            this.tmpUp.normalize();
            if (this.numSegments == 0)
            {
                _loc_4 = this.pushSegment();
                _loc_4.start.copyFrom(this.tmpPosition);
                _loc_4.position.copyFrom(this.tmpPosition);
                _loc_4.up.copyFrom(this.tmpUp);
                _loc_4.length = 0;
            }
            else
            {
                _loc_8 = (this.currentSegment + this.numSegments - 1) % this.MAX_SEGMENTS;
                _loc_4 = this.segments[_loc_8];
                _loc_4.position.copyFrom(this.tmpPosition);
                _loc_4.up.copyFrom(this.tmpUp);
                VectorUtil.subtract(_loc_4.position, this.currentPosition, this.tmpVec);
                _loc_9 = this.tmpVec.length;
                _loc_4.length = _loc_4.length + _loc_9;
                if (_loc_4.length >= this.length)
                {
                    _loc_4 = this.pushSegment();
                    _loc_4.start.copyFrom(this.tmpPosition);
                    _loc_4.position.copyFrom(this.tmpPosition);
                    _loc_4.up.copyFrom(this.tmpUp);
                    _loc_4.length = 0;
                }
            }
            this.currentLength = 0;
            var _loc_6:* = 0;
            while (_loc_6 < this.numSegments)
            {
                
                _loc_5 = (this.currentSegment + _loc_6) % this.MAX_SEGMENTS;
                this.currentLength = this.currentLength + this.segments[_loc_5].length;
                _loc_6++;
            }
            if (this.currentLength > this.totalLength + 0.1)
            {
                this.currentLength = this.currentLength - this.segments[this.currentSegment].length;
                this.shiftSegment();
            }
            this.currentPosition.copyFrom(this.tmpPosition);
            AnimatedVector3D.getValueFrom(this.color, param1, param2, this.tmpVec);
            var _loc_7:* = AnimatedUShort.getValueFrom(this.alpha, param1, param2) / 32767;
            this.currentColor.reset(this.tmpVec.x, this.tmpVec.y, this.tmpVec.z, _loc_7);
            this.currentAbove = AnimatedFloat.getValueFrom(this.above, param1, param2);
            this.currentBelow = AnimatedFloat.getValueFrom(this.below, param1, param2);
            this.updateBuffers();
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            op("m44 op, va0, vc0");
            op("mov v0, va1.xy");
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
            op("mul oc, ft0, fc16");
            return;
        }// end function

        public function render() : void
        {
            var _loc_1:* = null;
            if (this.numSegments == 0)
            {
                return;
            }
            if (this.material && this.material._texture.good)
            {
                if (!this._hasTexture)
                {
                    this._hasTexture = true;
                    upload();
                }
                _loc_1 = this.material._texture.texture;
            }
            context.setTextureAt(0, _loc_1);
            context.setProgram(_program);
            context.setCulling(Context3DTriangleFace.NONE);
            context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
            this._colorVector[0] = this.currentColor.r;
            this._colorVector[1] = this.currentColor.g;
            this._colorVector[2] = this.currentColor.b;
            this._colorVector[3] = this.currentColor.a;
            context.setProgramConstantsFromVector("fragment", 16, this._colorVector);
            context.setVertexBufferAt(0, this._vb, 0, "float3");
            context.setVertexBufferAt(1, this._vb, 3, "float2");
            context.setVertexBufferAt(2, null);
            context.drawTriangles(this._ib, 0, this.numSegments * 2);
            return;
        }// end function

        public function updateBuffers() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            if (!this._ib)
            {
                this._ib = context.createIndexBuffer(this.MAX_SEGMENTS * 6);
                _loc_8 = new Vector.<uint>;
                _loc_9 = 0;
                _loc_1 = 0;
                while (_loc_1 < this.MAX_SEGMENTS)
                {
                    
                    _loc_8.push(_loc_9);
                    _loc_8.push((_loc_9 + 1));
                    _loc_8.push(_loc_9 + 2);
                    _loc_8.push(_loc_9 + 2);
                    _loc_8.push((_loc_9 + 1));
                    _loc_8.push(_loc_9 + 3);
                    _loc_9 = _loc_9 + 2;
                    _loc_1++;
                }
                this._ib.uploadFromVector(_loc_8, 0, _loc_8.length);
            }
            if (!this._vb)
            {
                this._vb = context.createVertexBuffer(this.MAX_SEGMENTS * 2 + 2, 5);
            }
            var _loc_3:* = this.segments[this.currentSegment];
            var _loc_7:* = 0;
            this._vbData[_loc_4] = _loc_3.start.x + _loc_3.up.x * this.currentAbove;
            this._vbData[(_loc_4 + 1)] = _loc_3.start.y + _loc_3.up.y * this.currentAbove;
            this._vbData[_loc_4 + 2] = _loc_3.start.z + _loc_3.up.z * this.currentAbove;
            this._vbData[_loc_4 + 3] = 1;
            this._vbData[_loc_4 + 4] = 0;
            _loc_4 = _loc_4 + 5;
            this._vbData[_loc_4] = _loc_3.start.x - _loc_3.up.x * this.currentBelow;
            this._vbData[(_loc_4 + 1)] = _loc_3.start.y - _loc_3.up.y * this.currentBelow;
            this._vbData[_loc_4 + 2] = _loc_3.start.z - _loc_3.up.z * this.currentBelow;
            this._vbData[_loc_4 + 3] = 1;
            this._vbData[_loc_4 + 4] = 1;
            _loc_4 = _loc_4 + 5;
            _loc_1 = 0;
            while (_loc_1 < this.numSegments)
            {
                
                _loc_3 = this.segments[(this.currentSegment + _loc_1) % this.MAX_SEGMENTS];
                _loc_5 = 1 - (this.currentLength != 0 ? (_loc_7 / this.currentLength) : (0));
                _loc_6 = 1 - (this.currentLength != 0 ? ((_loc_7 + _loc_3.length) / this.currentLength) : (1));
                this._vbData[_loc_4] = _loc_3.position.x + _loc_3.up.x * this.currentAbove;
                this._vbData[(_loc_4 + 1)] = _loc_3.position.y + _loc_3.up.y * this.currentAbove;
                this._vbData[_loc_4 + 2] = _loc_3.position.z + _loc_3.up.z * this.currentAbove;
                this._vbData[_loc_4 + 3] = _loc_6;
                this._vbData[_loc_4 + 4] = 0;
                _loc_4 = _loc_4 + 5;
                this._vbData[_loc_4] = _loc_3.position.x - _loc_3.up.x * this.currentBelow;
                this._vbData[(_loc_4 + 1)] = _loc_3.position.y - _loc_3.up.y * this.currentBelow;
                this._vbData[_loc_4 + 2] = _loc_3.position.z - _loc_3.up.z * this.currentBelow;
                this._vbData[_loc_4 + 3] = _loc_6;
                this._vbData[_loc_4 + 4] = 1;
                _loc_4 = _loc_4 + 5;
                _loc_7 = _loc_7 + _loc_3.length;
                _loc_1++;
            }
            this._vb.uploadFromVector(this._vbData, 0, this.MAX_SEGMENTS * 2 + 2);
            return;
        }// end function

        public function pushSegment() : RibbonSegment
        {
            if (this.numSegments < this.MAX_SEGMENTS)
            {
                var _loc_1:* = this;
                var _loc_2:* = this.numSegments + 1;
                _loc_1.numSegments = _loc_2;
            }
            else
            {
                this.currentSegment = (this.currentSegment + 1) % this.MAX_SEGMENTS;
            }
            return this.segments[this.currentSegment];
        }// end function

        public function popSegment() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this.numSegments - 1;
            _loc_1.numSegments = _loc_2;
            return;
        }// end function

        public function shiftSegment() : void
        {
            this.currentSegment = (this.currentSegment + 1) % this.MAX_SEGMENTS;
            var _loc_1:* = this;
            var _loc_2:* = this.numSegments - 1;
            _loc_1.numSegments = _loc_2;
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            var _loc_3:* = 0;
            this.id = param1.readInt();
            this.bone = param1.readInt();
            this.position = WowUtil.readVector3D(param1);
            this.position.w = 1;
            this.resolution = param1.readFloat();
            this.length = param1.readFloat();
            this.emissionAngle = param1.readFloat();
            this.s1 = param1.readShort();
            this.s2 = param1.readShort();
            var _loc_2:* = param1.readInt();
            if (_loc_2 > 0)
            {
                this.textures = new Vector.<int>(_loc_2);
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    this.textures[_loc_3] = param1.readInt();
                    _loc_3++;
                }
            }
            this.color = WowUtil.readAnimatedVector3DSet(param1, false);
            this.alpha = WowUtil.readAnimatedUShortSet(param1);
            this.above = WowUtil.readAnimatedFloatSet(param1);
            this.below = WowUtil.readAnimatedFloatSet(param1);
            this.init();
            return;
        }// end function

    }
}

import __AS3__.vec.*;

import com.zam.*;

import flash.display3D.*;

import flash.display3D.textures.*;

import flash.geom.*;

import flash.utils.*;

class RibbonSegment extends Object
{
    public var position:Vector3D;
    public var start:Vector3D;
    public var up:Vector3D;
    public var length:Number;

    function RibbonSegment()
    {
        this.position = new Vector3D(0, 0, 0, 1);
        this.start = new Vector3D(0, 0, 0, 1);
        this.up = new Vector3D(0, 0, 0, 0);
        this.length = 0;
        return;
    }// end function

}

