package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.geom.*;
    import flash.utils.*;

    public class WowBone extends Object
    {
        public var _keyId:int;
        public var _parent:int;
        public var _flags:uint;
        public var _mesh:uint;
        public var _pivot:Vector3D;
        public var _index:int;
        public var _transformedPivot:Vector3D;
        public var _matrix:Matrix3D;
        public var _rotMatrix:Matrix3D;
        public var _rot:Matrix3D;
        public var _calc:Boolean;
        protected var _hasRot:Boolean;
        protected var _model:WowModel;
        private var m:Matrix3D;
        private var tmpVec:Vector3D;
        private var tmpMat:Matrix3D;
        private var tmpQuat:Quaternion;

        public function WowBone(param1:WowModel, param2:int)
        {
            this._parent = -1;
            this._model = param1;
            this._index = param2;
            this._matrix = new Matrix3D();
            this._rotMatrix = new Matrix3D();
            this._rot = new Matrix3D();
            this.m = new Matrix3D();
            this.tmpVec = new Vector3D();
            this.tmpMat = new Matrix3D();
            this.tmpQuat = new Quaternion();
            return;
        }// end function

        public function calcMatrix(param1:int) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            if (this._calc)
            {
                return;
            }
            this._calc = true;
            if (this._model == null || this._model.animations == null)
            {
                return;
            }
            this.m.identity();
            this.tmpMat.identity();
            this._hasRot = false;
            var _loc_2:* = this._model.currentAnimation;
            if (_loc_2._translation.length == 0 || _loc_2._rotation.length == 0 || _loc_2._scale.length == 0)
            {
                this._matrix.identity();
                this._rotMatrix.identity();
                return;
            }
            var _loc_3:* = (this._flags & 8) > 0;
            var _loc_4:* = _loc_2._translation[this._index]._used || _loc_2._rotation[this._index]._used || _loc_2._scale[this._index]._used || _loc_3;
            if (_loc_2._translation[this._index]._used || _loc_2._rotation[this._index]._used || _loc_2._scale[this._index]._used || _loc_3)
            {
                this.m.prependTranslation(this._pivot.x, this._pivot.y, this._pivot.z);
                if (_loc_2._translation[this._index]._used)
                {
                    this.tmpVec.setTo(0, 0, 0);
                    _loc_2._translation[this._index].getValue(param1, this.tmpVec);
                    this.m.prependTranslation(this.tmpVec.x, this.tmpVec.y, this.tmpVec.z);
                }
                if (_loc_2._rotation[this._index]._used)
                {
                    this.tmpQuat.setTo();
                    _loc_2._rotation[this._index].getValue(param1, this.tmpQuat);
                    this.tmpQuat.toMatrix(this._rot);
                    this._rot.transpose();
                    this.m.prepend(this._rot);
                    this._hasRot = true;
                }
                if (_loc_2._scale[this._index]._used)
                {
                    this.tmpVec.setTo(1, 1, 1);
                    _loc_2._scale[this._index].getValue(param1, this.tmpVec);
                    if (this.tmpVec.x > 10 || Math.abs(this.tmpVec.x) < 1e-006)
                    {
                        this.tmpVec.x = 1;
                    }
                    if (this.tmpVec.y > 10 || Math.abs(this.tmpVec.y) < 1e-006)
                    {
                        this.tmpVec.y = 1;
                    }
                    if (this.tmpVec.z > 10 || Math.abs(this.tmpVec.z) < 1e-006)
                    {
                        this.tmpVec.z = 1;
                    }
                    this.m.prependScale(this.tmpVec.x, this.tmpVec.y, this.tmpVec.z);
                }
                if (_loc_3)
                {
                    _loc_5 = this.m.decompose();
                    _loc_6 = 0;
                    _loc_7 = this._model.camera._xAngle * 180 / Math.PI;
                    _loc_8 = this._model.camera._yAngle * 180 / Math.PI;
                    if (Math.abs(_loc_5[1].y) < 0.01 && Math.abs(_loc_5[1].z) < 0.01)
                    {
                        _loc_6 = _loc_5[1].x * 180 / Math.PI;
                    }
                    this.m.identity();
                    this.m.appendRotation(_loc_6, Vector3D.X_AXIS, this._pivot);
                    this.m.appendRotation(_loc_8, Vector3D.Z_AXIS, this._pivot);
                    if (this._model._modelType == WowModel.TypeHelm || this._model._modelType == WowModel.TypeShoulder || this._model._modelType == WowModel.TypeItem)
                    {
                        this.m.appendRotation(270 - _loc_7, Vector3D.Y_AXIS, this._pivot);
                    }
                    else
                    {
                        this.m.appendRotation(-_loc_7, Vector3D.Y_AXIS, this._pivot);
                    }
                }
                else
                {
                    this.m.prependTranslation(-this._pivot.x, -this._pivot.y, -this._pivot.z);
                }
            }
            else
            {
                this._hasRot = false;
            }
            this._matrix = this.m;
            if (this._parent > -1)
            {
                this._model.bones[this._parent].calcMatrix(param1);
                this._matrix.append(this._model.bones[this._parent]._matrix);
            }
            if (this._hasRot)
            {
                this._rotMatrix.copyFrom(this._rot);
                if (this._parent > -1)
                {
                    this._rotMatrix.append(this._model.bones[this._parent]._rotMatrix);
                }
            }
            else
            {
                this._rotMatrix.identity();
            }
            MatrixUtil.transform(this._matrix, this._pivot, this._transformedPivot);
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this._keyId = param1.readInt();
            this._parent = param1.readShort();
            this._mesh = param1.readUnsignedShort();
            this._flags = param1.readUnsignedInt();
            this._pivot = WowUtil.readVector3D(param1);
            this._pivot.w = 1;
            this._transformedPivot = this._pivot.clone();
            return;
        }// end function

    }
}
