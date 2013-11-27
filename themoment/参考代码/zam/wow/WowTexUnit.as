package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.display3D.*;
    import flash.geom.*;
    import flash.utils.*;

    public class WowTexUnit extends Shader
    {
        public var flags:uint;
        public var shading1:uint;
        public var shading2:uint;
        public var mesh:uint;
        public var mode:uint;
        public var color:int;
        public var alpha:int;
        public var texture:int;
        public var textureAnim:int;
        public var renderFlag:uint;
        public var texUnit:uint;
        public var _meshId:uint;
        public var _swrap:Boolean;
        public var _twrap:Boolean;
        public var _unlit:Boolean;
        public var _cull:Boolean;
        public var _billboard:Boolean;
        public var _noZWrite:Boolean;
        public var _textureIdx:int = -1;
        public var _texAnimIdx:int = -1;
        public var _alphaIdx:int = -1;
        public var _texUnitIdx:int = -1;
        public var _show:Boolean = false;
        public var _mesh:WowMesh;
        public var _renderFlag:WowRenderFlag;
        public var _texture:WowMaterial = null;
        public var _texAnim:WowTextureAnimation = null;
        public var _color:WowColor = null;
        public var _alpha:WowTransparency = null;
        protected var _model:WowModel;
        protected var _indices:Vector.<uint>;
        protected var _ib:IndexBuffer3D;
        protected var _textureMat:Matrix3D;
        protected var _hasTexture:Boolean;
        public var _usedTexture:WowTexture;
        private var tmpColor:Color;
        private var tmpVec:Vector3D;
        private var tmpMat:Matrix3D;
        private var tmpQuat:Quaternion;
        private var matVector:Vector.<Number>;
        private var colorVector:Vector.<Number>;

        public function WowTexUnit(param1:WowModel)
        {
            super(param1.viewer);
            this._model = param1;
            this._textureMat = new Matrix3D();
            this.tmpColor = new Color();
            this.tmpVec = new Vector3D();
            this.tmpMat = new Matrix3D();
            this.tmpQuat = new Quaternion();
            this.matVector = new Vector.<Number>;
            this.colorVector = new Vector.<Number>([1, 1, 1, 1]);
            return;
        }// end function

        public function refresh() : void
        {
            if (this._ib)
            {
                this._ib.dispose();
                this._ib = null;
            }
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            if (this._billboard)
            {
                op("sub vt2.xyz, vc9.xyz, va0.xyz");
                op("nrm vt2.xyz, vt2.xyz");
                op("mov vt2.w, vc8.x");
                op("mov vt1.xyz, vc8.xyx");
                op("crs vt0.xyz, vt2.xyz, vt1.xyz");
                op("nrm vt0.xyz, vt0.xyz");
                op("mov vt0.w, vc8.x");
                op("crs vt1.xyz, vt0.xyz, vt0.xyz");
                op("nrm vt1.xyz, vt1.xyz");
                op("mov vt1.w, vc8.x");
                op("mov vt3, vc9");
                op("mov vt3.w, vc8.y");
                op("m44 vt4, va0, vt0");
                op("m44 vt4, vt4, vc12");
                op("m44 op, vt4, vc0");
            }
            else
            {
                op("m44 op, va0, vc0");
            }
            op("m44 v0, va2, vc16");
            op("m44 v1, va1, vc4");
            return;
        }// end function

        override protected function _fragmentShader() : void
        {
            if (this._hasTexture)
            {
                if (this._swrap || this._twrap)
                {
                    op("tex ft0, v0.xy, fs0 <2d, linear, mip, wrap>");
                }
                else
                {
                    op("tex ft0, v0.xy, fs0 <2d, linear, mip, repeat>");
                }
            }
            else
            {
                op("mov ft0.xy, v0.xy");
                op("mov ft0.zw, fc0.xy");
            }
            if (this._renderFlag.blend == 1)
            {
                op("sub ft1.w, ft0.w, fc7.x");
                op("kil ft1.w");
            }
            if (!this._unlit)
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
            op("mul oc, ft0, fc16");
            return;
        }// end function

        public function render() : void
        {
            this.tmpColor.reset();
            if (this._color)
            {
                this._color.getValue(this._model._currentAnim, this._model._time, this.tmpColor);
            }
            if (this._alpha)
            {
                this.tmpColor.a = this.tmpColor.a * this._alpha.getValue(this._model._currentAnim, this._model._time);
            }
            if (this.tmpColor.a < 0.01)
            {
                return;
            }
            this.colorVector[0] = this.tmpColor.r;
            this.colorVector[1] = this.tmpColor.g;
            this.colorVector[2] = this.tmpColor.b;
            this.colorVector[3] = this.tmpColor.a;
            context.setProgramConstantsFromVector("fragment", 16, this.colorVector);
            this._textureMat.identity();
            if (this._texAnim)
            {
                if (this._texAnim.translation && this._texAnim.translation.length > 0)
                {
                    this.tmpVec.setTo(0, 0, 0);
                    AnimatedVector3D.getValueFrom(this._texAnim.translation, this._model._currentAnim, this._model._time, this.tmpVec);
                    this._textureMat.prependTranslation(this.tmpVec.x, this.tmpVec.y, this.tmpVec.z);
                }
                if (this._texAnim.rotation && this._texAnim.rotation.length > 0)
                {
                    this.tmpQuat.setTo(0, 0, 0, 1);
                    AnimatedQuaternion.getValueFrom(this._texAnim.rotation, this._model._currentAnim, this._model._time, this.tmpQuat);
                    this.tmpQuat.toMatrix(this.tmpMat);
                    this._textureMat.prepend(this.tmpMat);
                }
                if (this._texAnim.scale && this._texAnim.scale.length > 0)
                {
                    this.tmpVec.setTo(0, 0, 0);
                    AnimatedVector3D.getValueFrom(this._texAnim.scale, this._model._currentAnim, this._model._time, this.tmpVec);
                    this._textureMat.prependScale(this.tmpVec.x || 1, this.tmpVec.y || 1, this.tmpVec.z || 1);
                }
            }
            context.setProgramConstantsFromMatrix("vertex", 16, this._textureMat, true);
            if (this._billboard)
            {
                this._model.setBillboardMatrices();
            }
            else
            {
                this._model.setDefaultMatrices();
            }
            if (this._ib == null)
            {
                this.updateBuffers();
            }
            if (this._texture)
            {
                if (this._texture._type == 1 && this._model._npcTexture && this._model._npcTexture.good)
                {
                    this._usedTexture = this._model._npcTexture;
                }
                else if (this._texture._texture && this._texture._texture.good)
                {
                    this._usedTexture = this._texture._texture;
                }
                else if (((this._model._modelType < 8 || this._model._modelType > 32) && this._texture._type == 2 || this._texture._type >= 11) && this._model._textures[this._texture._index] && this._model._textures[this._texture._index].good)
                {
                    this._usedTexture = this._model._textures[this._texture._index];
                }
                else if (this._texture._type == 2 && this._model._textures[2] && this._model._textures[2].good)
                {
                    this._usedTexture = this._model._textures[2];
                }
                else if (this._texture._type != -1 && this._model._textures[this._texture._type] && this._model._textures[this._texture._type].good)
                {
                    this._usedTexture = this._model._textures[this._texture._type];
                }
                if (this._usedTexture)
                {
                    if (!this._hasTexture)
                    {
                        this._hasTexture = true;
                        upload();
                    }
                    context.setTextureAt(0, this._usedTexture.texture);
                }
                else
                {
                    context.setTextureAt(0, null);
                }
            }
            else
            {
                context.setTextureAt(0, null);
            }
            context.setProgram(_program);
            switch(this._renderFlag.blend)
            {
                case 0:
                case 1:
                {
                    context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
                    break;
                }
                case 2:
                {
                    context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                    break;
                }
                case 3:
                {
                    context.setBlendFactors(Context3DBlendFactor.SOURCE_COLOR, Context3DBlendFactor.ONE);
                    break;
                }
                case 4:
                {
                    context.setBlendFactors(this.mode == 2 ? (Context3DBlendFactor.SOURCE_ALPHA) : (Context3DBlendFactor.ONE), Context3DBlendFactor.ONE);
                    break;
                }
                case 5:
                {
                    if (this.mode == 1)
                    {
                        context.setBlendFactors(Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_COLOR);
                    }
                    else
                    {
                        context.setBlendFactors(Context3DBlendFactor.DESTINATION_COLOR, Context3DBlendFactor.SOURCE_COLOR);
                    }
                    break;
                }
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
            if (this._cull)
            {
                context.setCulling(this._model._cullFace);
            }
            else
            {
                context.setCulling(Context3DTriangleFace.NONE);
            }
            if (this._noZWrite)
            {
                context.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
            }
            else
            {
                context.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
            }
            context.drawTriangles(this._ib);
            return;
        }// end function

        public function updateBuffers() : void
        {
            this._indices = new Vector.<uint>(this._mesh.indexCount);
            var _loc_1:* = 0;
            while (_loc_1 < this._mesh.indexCount)
            {
                
                this._indices[_loc_1] = this._model._indices[this._mesh.indexStart + _loc_1];
                _loc_1++;
            }
            this._ib = context.createIndexBuffer(this._mesh.indexCount);
            this._ib.uploadFromVector(this._indices, 0, this._mesh.indexCount);
            upload();
            return;
        }// end function

        public function setup(param1:WowModel) : void
        {
            this._mesh = param1._meshes[this.mesh];
            this._meshId = this._mesh.id;
            this._renderFlag = param1._renderFlags[this.renderFlag];
            this._unlit = (this._renderFlag.flags & 1) > 0;
            this._cull = (this._renderFlag.flags & 4) == 0;
            this._noZWrite = (this._renderFlag.flags & 16) > 0;
            if (this.texture >= 0 && this.texture < param1._materialLookup.length)
            {
                this._textureIdx = param1._materialLookup[this.texture];
                if (this._textureIdx >= 0 && this._textureIdx < param1._materials.length)
                {
                    this._texture = param1._materials[this._textureIdx];
                }
            }
            if (this.textureAnim >= 0 && this.textureAnim < param1._textureAnimLookup.length)
            {
                this._texAnimIdx = param1._textureAnimLookup[this.textureAnim];
                if (this._texAnimIdx >= 0 && this._texAnimIdx < param1._textureAnims.length)
                {
                    this._texAnim = param1._textureAnims[this._texAnimIdx];
                }
            }
            if (this.color >= 0 && this.color < param1._colors.length)
            {
                this._color = param1._colors[this.color];
            }
            if (this.alpha >= 0 && this.alpha < param1._alphaLookup.length)
            {
                this._alphaIdx = param1._alphaLookup[this.alpha];
                if (this._alphaIdx >= 0 && this._alphaIdx < param1._alphas.length)
                {
                    this._alpha = param1._alphas[this._alphaIdx];
                }
            }
            if (this.texUnit >= 0 && param1._texUnitLookup && this.texUnit < param1._texUnitLookup.length)
            {
                this._texUnitIdx = param1._texUnitLookup[this.texUnit];
            }
            else if (!param1._texUnitLookup)
            {
                this._texUnitIdx = this.texUnit;
            }
            if (this._texture)
            {
                this._swrap = (this._texture._flags & 1) > 0;
                this._twrap = (this._texture._flags & 2) > 0;
            }
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.flags = param1.readUnsignedShort();
            this.shading1 = param1.readUnsignedByte();
            this.shading2 = param1.readUnsignedByte();
            this.mesh = param1.readUnsignedShort();
            this.mode = param1.readUnsignedShort();
            this.color = param1.readShort();
            this.alpha = param1.readShort();
            this.texture = param1.readShort();
            this.textureAnim = param1.readShort();
            this.renderFlag = param1.readUnsignedShort();
            this.texUnit = param1.readUnsignedShort();
            return;
        }// end function

    }
}
