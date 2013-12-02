package com.zam.lol
{
    import com.zam.*;
    import flash.geom.*;
    import flash.utils.*;

    public class AnimationBone extends Object
    {
        public var bone:String;
        public var flags:uint;
        public var frames:Vector.<Object>;
        public var idx:int;
        private var _mesh:LolMesh;
        private var _anim:Animation;
        private var _parent:int;
        private var _scale:Number;
        public var matrix:Matrix3D;
        private static var tmpMat:Matrix3D = new Matrix3D();
        private static var tmpVec:Vector3D = new Vector3D();
        private static var tmpQuat:Quaternion = new Quaternion();

        public function AnimationBone(param1:LolMesh, param2:Animation)
        {
            this._mesh = param1;
            this._anim = param2;
            this.matrix = new Matrix3D();
        }

        public function calc(param1:int, param2:Animation, param3:int, param4:Number) : void
        {
            this._parent = this._mesh.bones[param1].parent;
            this._scale = this._mesh.bones[param1].scale;
            this.matrix.identity();
            if (param3 >= (this.frames.length - 1))
            {
                VectorUtil.interpolate(this.frames[(this.frames.length - 1)].pos, this.frames[0].pos, param4, tmpVec);
                Quaternion.slerp(this.frames[(this.frames.length - 1)].rot, this.frames[0].rot, param4, tmpQuat);
            }
            else
            {
                VectorUtil.interpolate(this.frames[param3].pos, this.frames[(param3 + 1)].pos, param4, tmpVec);
                Quaternion.slerp(this.frames[param3].rot, this.frames[(param3 + 1)].rot, param4, tmpQuat);
            }
            MatrixUtil.prependTranslation(this.matrix, tmpVec);
            MatrixUtil.fromQuaternion(tmpMat, tmpQuat);
            MatrixUtil.multiply(this.matrix, tmpMat, this.matrix);
            this.matrix.transpose();
            if (this._parent != -1)
            {
                MatrixUtil.multiply(this.matrix, this._mesh.transforms[this._parent], this.matrix);
            }
            this.idx = param1;
            this._mesh.transforms[param1].copyFrom(this.matrix);
        }

        public function dump(param1:int) : void
        {
            VectorUtil.interpolate(this.frames[0].pos, this.frames[1].pos, 0.5, tmpVec);
            Quaternion.slerp(this.frames[0].rot, this.frames[1].rot, 0.5, tmpQuat);
            
        }

        public function read(param1:ByteArray) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = param1.readUnsignedInt();
            this.bone = param1.readUTF();
            this.bone = this.bone.toLowerCase();
            this.flags = param1.readUnsignedInt();
            this.frames = new Vector.<Object>(_loc_2);
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = new Vector3D();
                _loc_4.x = param1.readFloat();
                _loc_4.y = param1.readFloat();
                _loc_4.z = param1.readFloat();
                _loc_4.w = 1;
                _loc_5 = new Quaternion();
                _loc_5.x = param1.readFloat();
                _loc_5.y = param1.readFloat();
                _loc_5.z = param1.readFloat();
                _loc_5.w = param1.readFloat();
                this.frames[_loc_3] = {pos:_loc_4, rot:_loc_5};
                _loc_3 = _loc_3 + 1;
            }
        }

    }
}
