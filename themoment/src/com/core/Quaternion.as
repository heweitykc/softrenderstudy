package com.core
{
    import flash.geom.*;

    final public class Quaternion extends Object
    {
        public var x:Number;
        public var y:Number;
        public var z:Number;
        public var w:Number;
        public static const Null:Quaternion = new Quaternion;

        public function Quaternion(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1)
        {
            this.setTo(param1, param2, param3, param4);
            return;
        }// end function

        public function setTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            this.x = param1;
            this.y = param2;
            this.z = param3;
            this.w = param4;
            return;
        }// end function

        public function copyFrom(param1:Quaternion) : void
        {
            this.setTo(param1.x, param1.y, param1.z, param1.w);
            return;
        }// end function

        public function clone() : Quaternion
        {
            return new Quaternion(this.x, this.y, this.z, this.w);
        }// end function

        public function getConjugate() : Quaternion
        {
            return new Quaternion(-this.x, -this.y, -this.z, this.w);
        }// end function

        public function normalize() : void
        {
            var _loc_1:* = 1 / Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
            this.x = this.x * _loc_1;
            this.y = this.y * _loc_1;
            this.z = this.z * _loc_1;
            this.w = this.w * _loc_1;
            return;
        }// end function

        public function fromEulerAngles(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_4:* = param1 * 0.5;
            var _loc_5:* = param2 * 0.5;
            var _loc_6:* = param3 * 0.5;
            var _loc_7:* = Math.sin(_loc_4);
            var _loc_8:* = Math.cos(_loc_4);
            var _loc_9:* = Math.sin(_loc_5);
            var _loc_10:* = Math.cos(_loc_5);
            var _loc_11:* = Math.sin(_loc_6);
            var _loc_12:* = Math.cos(_loc_6);
            this.x = _loc_7 * _loc_10 * _loc_12 - _loc_8 * _loc_9 * _loc_11;
            this.y = _loc_9 * _loc_12 * _loc_8 + _loc_10 * _loc_11 * _loc_7;
            this.z = _loc_11 * _loc_8 * _loc_10 - _loc_12 * _loc_7 * _loc_9;
            this.w = _loc_8 * _loc_10 * _loc_12 + _loc_7 * _loc_9 * _loc_11;
            return;
        }// end function

        public function toEulerAngles(param1:Vector3D) : void
        {
            param1.x = Math.atan2(2 * (this.w * this.x + this.y * this.z), 1 - 2 * (this.x * this.x + this.y * this.y));
            param1.y = Math.asin(2 * (this.w * this.y - this.x * this.z));
            param1.z = Math.atan2(2 * (this.w * this.z + this.y * this.x), 1 - 2 * (this.z * this.z + this.y * this.y));
            return;
        }// end function

        public function multiply(param1:Quaternion, param2:Quaternion) : void
        {
            param2.setTo(this.w * param1.x + this.x * param1.w + this.y * param1.z - this.z * param1.y, this.w * param1.y - this.x * param1.z + this.y * param1.w + this.z * param1.x, this.w * param1.z + this.x * param1.y - this.y * param1.x + this.z * param1.w, this.w * param1.w - this.x * param1.x - this.y * param1.y - this.z * param1.z);
            return;
        }// end function

        public function rotateVector(param1:Vector3D, param2:Vector3D) : void
        {
            var _loc_3:* = this.x * this.x;
            var _loc_4:* = this.y * this.y;
            var _loc_5:* = this.z * this.z;
            var _loc_6:* = this.w * this.w;
            var _loc_7:* = 2 * this.x * this.y;
            var _loc_8:* = 2 * this.x * this.z;
            var _loc_9:* = 2 * this.x * this.w;
            var _loc_10:* = 2 * this.y * this.z;
            var _loc_11:* = 2 * this.y * this.w;
            var _loc_12:* = 2 * this.z * this.w;
            param2.setTo(param1.x * (_loc_3 + _loc_6 - _loc_4 - _loc_5) + param1.y * (_loc_7 - _loc_12) + param1.z * (_loc_8 + _loc_11), param1.y * (_loc_4 + _loc_6 - _loc_5 - _loc_3) + param1.z * (_loc_10 - _loc_9) + param1.x * (_loc_7 + _loc_12), param1.z * (_loc_5 + _loc_6 - _loc_3 - _loc_4) + param1.x * (_loc_8 - _loc_11) + param1.y * (_loc_10 + _loc_9));
            return;
        }// end function

		public static const MatrixRawData:Vector.<Number> = new Vector.<Number>(16, true);
		
        public function toMatrix(param1:Matrix3D, param2:Vector3D = null, param3:Vector3D = null) : void
        {
            var _loc_4:* = this.x * this.x;
            var _loc_5:* = this.y * this.y;
            var _loc_6:* = this.z * this.z;
            var _loc_7:* = this.w * this.w;
            var _loc_8:* = 2 * this.x * this.y;
            var _loc_9:* = 2 * this.x * this.z;
            var _loc_10:* = 2 * this.x * this.w;
            var _loc_11:* = 2 * this.y * this.z;
            var _loc_12:* = 2 * this.y * this.w;
            var _loc_13:* = 2 * this.z * this.w;
            var _loc_14:* = MatrixRawData;
            _loc_14[0] = _loc_4 + _loc_7 - _loc_5 - _loc_6;
            _loc_14[4] = _loc_8 - _loc_13;
            _loc_14[8] = _loc_9 + _loc_12;
            _loc_14[1] = _loc_8 + _loc_13;
            _loc_14[5] = _loc_5 + _loc_7 - _loc_6 - _loc_4;
            _loc_14[9] = _loc_11 - _loc_10;
            _loc_14[2] = _loc_9 - _loc_12;
            _loc_14[6] = _loc_11 + _loc_10;
            _loc_14[10] = _loc_6 + _loc_7 - _loc_4 - _loc_5;
            var _loc_15:* = 0;
            _loc_14[11] = 0;
            _loc_14[7] = _loc_15;
            _loc_14[3] = _loc_15;
            _loc_14[15] = 1;
            if (param2)
            {
                _loc_14[12] = param2.x;
                _loc_14[13] = param2.y;
                _loc_14[14] = param2.z;
            }
            else
            {
                _loc_14[14] = 0;
                _loc_14[13] = 0;
                _loc_14[12] = 0;
            }
            if (param3)
            {
                _loc_14[0] = _loc_14[0] * param3.x;
                _loc_14[5] = _loc_14[5] * param3.y;
                _loc_14[10] = _loc_14[10] * param3.z;
            }
            param1.copyRawDataFrom(_loc_14);
            return;
        }// end function

        public static function Slerp(param1:Quaternion, param2:Quaternion, param3:Number, param4:Quaternion) : void
        {
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            var _loc_17:* = NaN;
            var _loc_5:* = param1.x;
            var _loc_6:* = param1.y;
            var _loc_7:* = param1.z;
            var _loc_8:* = param1.w;
            var _loc_9:* = param2.x;
            var _loc_10:* = param2.y;
            var _loc_11:* = param2.z;
            var _loc_12:* = param2.w;
            var _loc_13:* = _loc_5 * _loc_9 + _loc_6 * _loc_10 + _loc_7 * _loc_11 + _loc_8 * _loc_12;
            if (_loc_5 * _loc_9 + _loc_6 * _loc_10 + _loc_7 * _loc_11 + _loc_8 * _loc_12 < 0)
            {
                _loc_13 = -_loc_13;
                _loc_9 = -_loc_9;
                _loc_10 = -_loc_10;
                _loc_11 = -_loc_11;
                _loc_12 = -_loc_12;
            }
            if (_loc_13 < 0.95)
            {
                _loc_14 = Math.acos(_loc_13);
                _loc_15 = 1 / Math.sin(_loc_14);
                _loc_16 = _loc_15 * Math.sin(_loc_14 * (1 - param3));
                _loc_17 = _loc_15 * Math.sin(_loc_14 * param3);
                param4.x = _loc_5 * _loc_16 + _loc_9 * _loc_17;
                param4.y = _loc_6 * _loc_16 + _loc_10 * _loc_17;
                param4.z = _loc_7 * _loc_16 + _loc_11 * _loc_17;
                param4.w = _loc_8 * _loc_16 + _loc_12 * _loc_17;
            }
            else
            {
                param4.x = _loc_5 + (_loc_9 - _loc_5) * param3;
                param4.y = _loc_6 + (_loc_10 - _loc_6) * param3;
                param4.z = _loc_7 + (_loc_11 - _loc_7) * param3;
                param4.w = _loc_8 + (_loc_12 - _loc_8) * param3;
                param4.normalize();
            }
            return;
        }// end function

        public static function FromMatrix(param1:Matrix3D) : Quaternion
        {
            var _loc_2:* = param1.decompose(Orientation3D.QUATERNION)[1];
            return new Quaternion(_loc_2.x, _loc_2.y, _loc_2.z, _loc_2.w);
        }// end function

        public static function FromAxisAngle(param1:Vector3D, param2:Number) : Quaternion
        {
            var _loc_3:* = param2 * 0.5;
            var _loc_4:* = Math.sin(_loc_3);
            return new Quaternion(param1.x * _loc_4, param1.y * _loc_4, param1.z * _loc_4, Math.cos(_loc_3));
        }// end function

    }
}
