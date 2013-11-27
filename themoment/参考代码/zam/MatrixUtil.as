package com.zam
{
    import __AS3__.vec.*;
    import flash.geom.*;

    public class MatrixUtil extends Object
    {
        public static const n11:int = 0;
        public static const n12:int = 1;
        public static const n13:int = 2;
        public static const n14:int = 3;
        public static const n21:int = 4;
        public static const n22:int = 5;
        public static const n23:int = 6;
        public static const n24:int = 7;
        public static const n31:int = 8;
        public static const n32:int = 9;
        public static const n33:int = 10;
        public static const n34:int = 11;
        public static const n41:int = 12;
        public static const n42:int = 13;
        public static const n43:int = 14;
        public static const n44:int = 15;
        public static var v1:Vector.<Number> = new Vector.<Number>(16);
        public static var v2:Vector.<Number> = new Vector.<Number>(16);
        public static var v3:Vector.<Number> = new Vector.<Number>(16);
        public static var tmpVec:Vector3D = new Vector3D();

        public function MatrixUtil()
        {
            return;
        }// end function

        public static function setBasisTransform(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Matrix3D) : Matrix3D
        {
            v1[n11] = param1.x;
            v1[n12] = param1.y;
            v1[n13] = param1.z;
            v1[n21] = param2.x;
            v1[n22] = param2.y;
            v1[n23] = param2.z;
            v1[n31] = param3.x;
            v1[n32] = param3.y;
            v1[n33] = param3.z;
            var _loc_5:* = 0;
            v1[n43] = 0;
            v1[n42] = _loc_5;
            v1[n41] = _loc_5;
            v1[n34] = _loc_5;
            v1[n24] = _loc_5;
            v1[n14] = _loc_5;
            v1[n44] = 1;
            param4.copyRawDataFrom(v1);
            param4.invert();
            return param4;
        }// end function

        public static function reset33(param1:Matrix3D) : Matrix3D
        {
            var _loc_2:int = 1;
            param1.rawData[n33] = 1;
            param1.rawData[n22] = _loc_2;
            param1.rawData[n11] = _loc_2;
            _loc_2 = 0;
            param1.rawData[n32] = 0;
            param1.rawData[n31] = _loc_2;
            param1.rawData[n23] = _loc_2;
            param1.rawData[n21] = _loc_2;
            param1.rawData[n13] = _loc_2;
            param1.rawData[n12] = _loc_2;
            return param1;
        }// end function

        public static function transpose33(param1:Matrix3D) : Matrix3D
        {
            param1.copyRawDataTo(v1);
            param1.rawData[n12] = v1[n21];
            param1.rawData[n13] = v1[n31];
            param1.rawData[n21] = v1[n12];
            param1.rawData[n23] = v1[n32];
            param1.rawData[n31] = v1[n13];
            param1.rawData[n32] = v1[n23];
            return param1;
        }// end function

        public static function invert(param1:Matrix3D) : Matrix3D
        {
            param1.copyRawDataTo(v1);
            var _loc_2:* = v1[n11] * (v1[n22] * v1[n33] - v1[n23] * v1[n32]) + v1[n21] * (v1[n13] * v1[n32] - v1[n12] * v1[n33]) + v1[n31] * (v1[n12] * v1[n23] - v1[n13] * v1[n22]);
            if (_loc_2 == 0)
            {
                return null;
            }
            var _loc_3:* = 1 / _loc_2;
            v2[n11] = (v1[n22] * v1[n33] - v1[n23] * v1[n32]) * _loc_3;
            v2[n12] = (v1[n32] * v1[n13] - v1[n33] * v1[n12]) * _loc_3;
            v2[n13] = (v1[n12] * v1[n23] - v1[n13] * v1[n22]) * _loc_3;
            v2[n21] = (v1[n23] * v1[n31] - v1[n21] * v1[n33]) * _loc_3;
            v2[n22] = (v1[n33] * v1[n11] - v1[n31] * v1[n13]) * _loc_3;
            v2[n23] = (v1[n13] * v1[n21] - v1[n11] * v1[n23]) * _loc_3;
            v2[n31] = (v1[n21] * v1[n32] - v1[n22] * v1[n31]) * _loc_3;
            v2[n32] = (v1[n31] * v1[n12] - v1[n32] * v1[n11]) * _loc_3;
            v2[n33] = (v1[n11] * v1[n22] - v1[n12] * v1[n21]) * _loc_3;
            tmpVec.x = -v1[n14];
            tmpVec.y = -v1[n24];
            tmpVec.z = -v1[n34];
            tmpVec.w = 1;
            v2[n14] = v2[n11] * tmpVec.x + v2[n12] * tmpVec.y + v2[n13] * tmpVec.z;
            v2[n24] = v2[n21] * tmpVec.x + v2[n22] * tmpVec.y + v2[n23] * tmpVec.z;
            v2[n34] = v2[n31] * tmpVec.x + v2[n32] * tmpVec.y + v2[n33] * tmpVec.z;
            var _loc_4:* = 0;
            v2[n43] = 0;
            v2[n42] = _loc_4;
            v2[n41] = _loc_4;
            v2[n44] = 1;
            param1.copyRawDataFrom(v2);
            return param1;
        }// end function

        public static function scale(param1:Matrix3D, param2:Number) : Matrix3D
        {
            param1.copyRawDataTo(v1);
            v1[n11] = v1[n11] * param2;
            v1[n12] = v1[n12] * param2;
            v1[n13] = v1[n13] * param2;
            v1[n14] = v1[n14] * param2;
            v1[n21] = v1[n21] * param2;
            v1[n22] = v1[n22] * param2;
            v1[n23] = v1[n23] * param2;
            v1[n24] = v1[n24] * param2;
            v1[n31] = v1[n31] * param2;
            v1[n32] = v1[n32] * param2;
            v1[n33] = v1[n33] * param2;
            v1[n34] = v1[n34] * param2;
            param1.copyRawDataFrom(v1);
            return param1;
        }// end function

        public static function prependTranslation(param1:Matrix3D, param2:Vector3D) : Matrix3D
        {
            param1.copyRawDataTo(v1);
            v1[n14] = v1[n14] + (param2.x * v1[n11] + param2.y * v1[n12] + param2.z * v1[n13]);
            v1[n24] = v1[n24] + (param2.x * v1[n21] + param2.y * v1[n22] + param2.z * v1[n23]);
            v1[n34] = v1[n34] + (param2.x * v1[n31] + param2.y * v1[n32] + param2.z * v1[n33]);
            v1[n44] = v1[n44] + (param2.x * v1[n41] + param2.y * v1[n42] + param2.z * v1[n43]);
            param1.copyRawDataFrom(v1);
            return param1;
        }// end function

        public static function appendTranslation(param1:Matrix3D, param2:Vector3D) : Matrix3D
        {
            param1.copyRawDataTo(v1);
            v1[n11] = v1[n11] + param2.x * v1[n41];
            v1[n12] = v1[n12] + param2.x * v1[n42];
            v1[n13] = v1[n13] + param2.x * v1[n43];
            v1[n14] = v1[n14] + param2.x * v1[n44];
            v1[n21] = v1[n21] + param2.y * v1[n41];
            v1[n22] = v1[n22] + param2.y * v1[n42];
            v1[n23] = v1[n23] + param2.y * v1[n43];
            v1[n24] = v1[n24] + param2.y * v1[n44];
            v1[n31] = v1[n31] + param2.z * v1[n41];
            v1[n32] = v1[n32] + param2.z * v1[n42];
            v1[n33] = v1[n33] + param2.z * v1[n43];
            v1[n34] = v1[n34] + param2.z * v1[n44];
            param1.copyRawDataFrom(v1);
            return param1;
        }// end function

        public static function multiply(param1:Matrix3D, param2:Matrix3D, param3:Matrix3D) : Matrix3D
        {
            param1.copyRawDataTo(v1);
            param2.copyRawDataTo(v2);
            v3[n11] = v1[n11] * v2[n11] + v1[n12] * v2[n21] + v1[n13] * v2[n31] + v1[n14] * v2[n41];
            v3[n12] = v1[n11] * v2[n12] + v1[n12] * v2[n22] + v1[n13] * v2[n32] + v1[n14] * v2[n42];
            v3[n13] = v1[n11] * v2[n13] + v1[n12] * v2[n23] + v1[n13] * v2[n33] + v1[n14] * v2[n43];
            v3[n14] = v1[n11] * v2[n14] + v1[n12] * v2[n24] + v1[n13] * v2[n34] + v1[n14] * v2[n44];
            v3[n21] = v1[n21] * v2[n11] + v1[n22] * v2[n21] + v1[n23] * v2[n31] + v1[n24] * v2[n41];
            v3[n22] = v1[n21] * v2[n12] + v1[n22] * v2[n22] + v1[n23] * v2[n32] + v1[n24] * v2[n42];
            v3[n23] = v1[n21] * v2[n13] + v1[n22] * v2[n23] + v1[n23] * v2[n33] + v1[n24] * v2[n43];
            v3[n24] = v1[n21] * v2[n14] + v1[n22] * v2[n24] + v1[n23] * v2[n34] + v1[n24] * v2[n44];
            v3[n31] = v1[n31] * v2[n11] + v1[n32] * v2[n21] + v1[n33] * v2[n31] + v1[n34] * v2[n41];
            v3[n32] = v1[n31] * v2[n12] + v1[n32] * v2[n22] + v1[n33] * v2[n32] + v1[n34] * v2[n42];
            v3[n33] = v1[n31] * v2[n13] + v1[n32] * v2[n23] + v1[n33] * v2[n33] + v1[n34] * v2[n43];
            v3[n34] = v1[n31] * v2[n14] + v1[n32] * v2[n24] + v1[n33] * v2[n34] + v1[n34] * v2[n44];
            v3[n41] = v1[n41] * v2[n11] + v1[n42] * v2[n21] + v1[n43] * v2[n31] + v1[n44] * v2[n41];
            v3[n42] = v1[n41] * v2[n12] + v1[n42] * v2[n22] + v1[n43] * v2[n32] + v1[n44] * v2[n42];
            v3[n43] = v1[n41] * v2[n13] + v1[n42] * v2[n23] + v1[n43] * v2[n33] + v1[n44] * v2[n43];
            v3[n44] = v1[n41] * v2[n14] + v1[n42] * v2[n24] + v1[n43] * v2[n34] + v1[n44] * v2[n44];
            param3.copyRawDataFrom(v3);
            return param3;
        }// end function

        public static function transform(param1:Matrix3D, param2:Vector3D, param3:Vector3D) : Vector3D
        {
            param1.copyRawDataTo(v1);
            param3.x = v1[n11] * param2.x + v1[n21] * param2.y + v1[n31] * param2.z + v1[n41] * param2.w;
            param3.y = v1[n12] * param2.x + v1[n22] * param2.y + v1[n32] * param2.z + v1[n42] * param2.w;
            param3.z = v1[n13] * param2.x + v1[n23] * param2.y + v1[n33] * param2.z + v1[n43] * param2.w;
            param3.w = v1[n14] * param2.x + v1[n24] * param2.y + v1[n34] * param2.z + v1[n44] * param2.w;
            return param3;
        }// end function

        public static function transform2(param1:Matrix3D, param2:Vector3D, param3:Vector3D) : Vector3D
        {
            param1.copyRawDataTo(v1);
            param3.x = v1[n11] * param2.x + v1[n12] * param2.y + v1[n13] * param2.z + v1[n14] * param2.w;
            param3.y = v1[n21] * param2.x + v1[n22] * param2.y + v1[n23] * param2.z + v1[n24] * param2.w;
            param3.z = v1[n31] * param2.x + v1[n32] * param2.y + v1[n33] * param2.z + v1[n34] * param2.w;
            param3.w = v1[n41] * param2.x + v1[n42] * param2.y + v1[n43] * param2.z + v1[n44] * param2.w;
            return param3;
        }// end function

        public static function transformSelf(param1:Matrix3D, param2:Vector3D) : Vector3D
        {
            var _loc_3:* = param2.x;
            var _loc_4:* = param2.y;
            var _loc_5:* = param2.z;
            var _loc_6:* = param2.w;
            param1.copyRawDataTo(v1);
            param2.x = v1[n11] * _loc_3 + v1[n21] * _loc_4 + v1[n31] * _loc_5 + v1[n41] * _loc_6;
            param2.y = v1[n12] * _loc_3 + v1[n22] * _loc_4 + v1[n32] * _loc_5 + v1[n42] * _loc_6;
            param2.z = v1[n13] * _loc_3 + v1[n23] * _loc_4 + v1[n33] * _loc_5 + v1[n43] * _loc_6;
            param2.w = v1[n14] * _loc_3 + v1[n24] * _loc_4 + v1[n34] * _loc_5 + v1[n44] * _loc_6;
            return param2;
        }// end function

        public static function fromQuaternion(param1:Matrix3D, param2:Quaternion) : Matrix3D
        {
            var _loc_3:* = param2.x * 2;
            var _loc_4:* = param2.y * 2;
            var _loc_5:* = param2.z * 2;
            var _loc_6:* = param2.w * _loc_3;
            var _loc_7:* = param2.w * _loc_4;
            var _loc_8:* = param2.w * _loc_5;
            var _loc_9:* = param2.x * _loc_3;
            var _loc_10:* = param2.x * _loc_4;
            var _loc_11:* = param2.x * _loc_5;
            var _loc_12:* = param2.y * _loc_4;
            var _loc_13:* = param2.y * _loc_5;
            var _loc_14:* = param2.z * _loc_5;
            v1[n11] = 1 - (_loc_12 + _loc_14);
            v1[n12] = _loc_10 - _loc_8;
            v1[n13] = _loc_11 + _loc_7;
            v1[n14] = 0;
            v1[n21] = _loc_10 + _loc_8;
            v1[n22] = 1 - (_loc_9 + _loc_14);
            v1[n23] = _loc_13 - _loc_6;
            v1[n24] = 0;
            v1[n31] = _loc_11 - _loc_7;
            v1[n32] = _loc_13 + _loc_6;
            v1[n33] = 1 - (_loc_9 + _loc_12);
            v1[n34] = 0;
            v1[n41] = 0;
            v1[n42] = 0;
            v1[n43] = 0;
            v1[n44] = 1;
            param1.copyRawDataFrom(v1);
            return param1;
        }// end function

        public static function toQuaternion(param1:Matrix3D, param2:Quaternion) : Quaternion
        {
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            param1.copyRawDataTo(v1);
            var _loc_3:* = v1[n11] + v1[n22] + v1[n33];
            if (_loc_3 > 0)
            {
                _loc_4 = Math.sqrt((_loc_3 + 1));
                param2.w = _loc_4 * 0.5;
                _loc_4 = 0.5 / _loc_4;
                param2.x = (v1[n23] - v1[n32]) * _loc_4;
                param2.y = (v1[n31] - v1[n13]) * _loc_4;
                param2.z = (v1[n12] - v1[n21]) * _loc_4;
            }
            else
            {
                _loc_5 = 1;
                _loc_6 = n11;
                _loc_7 = n22;
                _loc_8 = n33;
                if (v1[n22] > v1[n11])
                {
                    _loc_5 = 2;
                    _loc_6 = n22;
                    _loc_7 = n33;
                    _loc_8 = n11;
                }
                if (v1[n33] > v1[_loc_6])
                {
                    _loc_5 = 3;
                    _loc_6 = n33;
                    _loc_7 = n11;
                    _loc_8 = n22;
                }
                _loc_4 = Math.sqrt(v1[_loc_6] - v1[_loc_7] + v1[_loc_8] + 1);
                if (_loc_5 == 1)
                {
                    param2.x = _loc_4 * 0.5;
                    _loc_4 = 0.5 / _loc_4;
                    param2.y = (v1[n12] + v1[n21]) * _loc_4;
                    param2.z = (v1[n13] + v1[n31]) * _loc_4;
                    param2.w = (v1[n23] - v1[n32]) * _loc_4;
                }
                else if (_loc_5 == 2)
                {
                    param2.y = _loc_4 * 0.5;
                    _loc_4 = 0.5 / _loc_4;
                    param2.z = (v1[n23] + v1[n32]) * _loc_4;
                    param2.x = (v1[n21] + v1[n12]) * _loc_4;
                    param2.w = (v1[n31] + v1[n13]) * _loc_4;
                }
                else if (_loc_5 == 3)
                {
                    param2.z = _loc_4 * 0.5;
                    _loc_4 = 0.5 / _loc_4;
                    param2.x = (v1[n31] + v1[n13]) * _loc_4;
                    param2.y = (v1[n32] + v1[n23]) * _loc_4;
                    param2.w = (v1[n12] + v1[n21]) * _loc_4;
                }
            }
            return param2;
        }// end function

    }
}
