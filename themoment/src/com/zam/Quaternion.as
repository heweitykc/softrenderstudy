package com.zam
{
    import flash.geom.*;

    public class Quaternion extends Object
    {
        public var x:Number;
        public var y:Number;
        public var z:Number;
        public var w:Number;
        private static var rawVec:Vector.<Number> = new Vector.<Number>(16);
        private static var tmpQuat:Quaternion = new Quaternion;
        private static var tmpQuat2:Quaternion = new Quaternion;
        private static var tmpVec:Vector3D = new Vector3D();
        private static var tmpVec2:Vector3D = new Vector3D();
        private static var tmpVec3:Vector3D = new Vector3D();

        public function Quaternion(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1)
        {
            this.x = param1;
            this.y = param2;
            this.z = param3;
            this.w = param4;
            return;
        }// end function

        public function clone() : Quaternion
        {
            return new Quaternion(this.x, this.y, this.z, this.w);
        }// end function

        public function setTo(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1) : Quaternion
        {
            this.x = param1;
            this.y = param2;
            this.z = param3;
            this.w = param4;
            return this;
        }// end function

        public function copyFrom(param1:Quaternion) : Quaternion
        {
            this.x = param1.x;
            this.y = param1.y;
            this.z = param1.z;
            this.w = param1.w;
            return this;
        }// end function

        public function toMatrix(param1:Matrix3D = null, param2:Vector3D = null) : Matrix3D
        {
            this.normalize();
            var _loc_3:* = this.x * this.x;
            var _loc_4:* = this.x * this.y;
            var _loc_5:* = this.x * this.z;
            var _loc_6:* = this.x * this.w;
            var _loc_7:* = this.y * this.y;
            var _loc_8:* = this.y * this.z;
            var _loc_9:* = this.y * this.w;
            var _loc_10:* = this.z * this.z;
            var _loc_11:* = this.z * this.w;
            if (!param1)
            {
                param1 = new Matrix3D();
            }
            rawVec[0] = 1 - 2 * (_loc_7 + _loc_10);
            rawVec[1] = 2 * (_loc_4 - _loc_11);
            rawVec[2] = 2 * (_loc_5 + _loc_9);
            rawVec[4] = 2 * (_loc_4 + _loc_11);
            rawVec[5] = 1 - 2 * (_loc_3 + _loc_10);
            rawVec[6] = 2 * (_loc_8 - _loc_6);
            rawVec[8] = 2 * (_loc_5 - _loc_9);
            rawVec[9] = 2 * (_loc_8 + _loc_6);
            rawVec[10] = 1 - 2 * (_loc_3 + _loc_7);
            var _loc_12:* = 0;
            rawVec[14] = 0;
            rawVec[13] = _loc_12;
            rawVec[12] = _loc_12;
            rawVec[11] = _loc_12;
            rawVec[7] = _loc_12;
            rawVec[3] = _loc_12;
            rawVec[15] = 1;
            if (param2)
            {
                rawVec[3] = param2.x;
                rawVec[7] = param2.y;
                rawVec[11] = param2.z;
            }
            param1.copyRawDataFrom(rawVec);
            return param1;
        }// end function

        public function add(param1:Quaternion) : Quaternion
        {
            this.x = this.x + param1.x;
            this.y = this.y + param1.y;
            this.z = this.z + param1.z;
            this.w = this.w + param1.w;
            return this;
        }// end function

        public function invert() : Quaternion
        {
            var _loc_2:* = NaN;
            var _loc_1:* = this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w;
            if (_loc_1 == 1)
            {
                this.x = -this.x;
                this.y = -this.y;
                this.z = -this.z;
            }
            else
            {
                _loc_2 = 1;
                if (_loc_1 != 0)
                {
                    _loc_2 = 1 / _loc_1;
                }
                this.x = this.x * _loc_2;
                this.y = this.y * _loc_2;
                this.z = this.z * _loc_2;
                this.w = this.w * _loc_2;
            }
            return this;
        }// end function

        public function multiply(param1:Quaternion) : Quaternion
        {
            this.x = this.x * param1.w + this.w * param1.x + this.z * param1.y - this.y * param1.z;
            this.y = this.y * param1.w + this.w * param1.y + this.x * param1.z - this.z * param1.x;
            this.z = this.z * param1.w + this.w * param1.z + this.y * param1.x - this.x * param1.y;
            this.w = this.w * param1.w - this.x * param1.x - this.y * param1.y - this.z * param1.z;
            return this;
        }// end function

        public function mulPoint(param1:Vector3D) : Vector3D
        {
            tmpVec.setTo(this.x, this.y, this.z);
            VectorUtil.crossProduct(tmpVec, param1, tmpVec2);
            VectorUtil.crossProduct(tmpVec, tmpVec2, tmpVec3);
            tmpVec2.scaleBy(2 * this.w);
            tmpVec3.scaleBy(2);
            param1.setTo(param1.x + tmpVec2.x + tmpVec3.x, param1.y + tmpVec2.y + tmpVec3.y, param1.z + tmpVec2.z + tmpVec3.z);
            return param1;
        }// end function

        public function transformSelf(param1:Vector3D) : Vector3D
        {
            tmpQuat.copyFrom(this);
            tmpQuat.invert();
            tmpQuat2.setTo(param1.x, param1.y, param1.z, 0);
            tmpQuat.multiply(tmpQuat2);
            tmpQuat.multiply(this);
            param1.setTo(tmpQuat.x, tmpQuat.y, tmpQuat.z);
            return param1;
        }// end function

        public function scale(param1:Number) : Quaternion
        {
            this.x = this.x * param1;
            this.y = this.y * param1;
            this.z = this.z * param1;
            this.w = this.w * param1;
            return this;
        }// end function

        public function dot(param1:Quaternion) : Number
        {
            return this.x * param1.x + this.y * param1.y + this.z * param1.z + this.w * param1.w;
        }// end function

        public function normalize() : void
        {
            var _loc_1:* = Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
            if (_loc_1 == 0)
            {
                var _loc_2:* = 0;
                this.z = 0;
                this.y = _loc_2;
                this.x = _loc_2;
                this.w = 1;
            }
            else if (_loc_1 != 1)
            {
                this.x = this.x / _loc_1;
                this.y = this.y / _loc_1;
                this.z = this.z / _loc_1;
                this.w = this.w / _loc_1;
            }
            return;
        }// end function

        public function toString() : String
        {
            return "Quaternion(" + this.x + ", " + this.y + ", " + this.z + ", " + this.w + ")";
        }// end function

        public static function fromAxisAngle(param1:Number, param2:Number, param3:Number, param4:Number) : Quaternion
        {
            var _loc_5:* = param4 / 180 * Math.PI;
            var _loc_6:* = Math.sin(_loc_5 / 2);
            return new Quaternion(param1 * _loc_6, param2 * _loc_6, param3 * _loc_6, Math.cos(_loc_5 / 2));
        }// end function

        public static function mul(param1:Quaternion, param2:Quaternion, param3:Quaternion) : Quaternion
        {
            param3.x = param1.x * param2.w + param1.w * param2.x + param1.z * param2.y - param1.y * param2.z;
            param3.y = param1.y * param2.w + param1.w * param2.y + param1.x * param2.z - param1.z * param2.x;
            param3.z = param1.z * param2.w + param1.w * param2.z + param1.y * param2.x - param1.x * param2.y;
            param3.w = param1.w * param2.w - param1.x * param2.x - param1.y * param2.y - param1.z * param2.z;
            return param3;
        }// end function

        public static function slerp(param1:Quaternion, param2:Quaternion, param3:Number, param4:Quaternion = null) : Quaternion
        {
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            if (!param4)
            {
                param4 = new Quaternion;
            }
            var _loc_5:* = param1.x * param2.x + param1.y * param2.y + param1.z * param2.z + param1.w * param2.w;
            var _loc_6:* = 1;
            if (_loc_5 < 0)
            {
                _loc_5 = -_loc_5;
                _loc_6 = -1;
            }
            if (1 - _loc_5 > 0.0001)
            {
                _loc_9 = Math.acos(_loc_5);
                _loc_10 = Math.sin(_loc_9);
                _loc_7 = Math.sin((1 - param3) * _loc_9) / _loc_10;
                _loc_8 = _loc_6 * Math.sin(param3 * _loc_9) / _loc_10;
            }
            else
            {
                _loc_7 = 1 - param3;
                _loc_8 = _loc_6 * param3;
            }
            param4.x = _loc_7 * param1.x + _loc_8 * param2.x;
            param4.y = _loc_7 * param1.y + _loc_8 * param2.y;
            param4.z = _loc_7 * param1.z + _loc_8 * param2.z;
            param4.w = _loc_7 * param1.w + _loc_8 * param2.w;
            return param4;
        }// end function

    }
}
