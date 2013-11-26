package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.geom.*;
    import flash.utils.*;

    public class WowUtil extends Object
    {

        public function WowUtil()
        {
            return;
        }// end function

        public static function readAnimatedFloatSet(param1:ByteArray) : Vector.<AnimatedFloat>
        {
            var _loc_2:* = param1.readInt();
            var _loc_3:* = new Vector.<AnimatedFloat>(_loc_2);
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = new AnimatedFloat();
                _loc_3[_loc_4].read(param1);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function readAnimatedQuaternionSet(param1:ByteArray) : Vector.<AnimatedQuaternion>
        {
            var _loc_2:* = param1.readInt();
            var _loc_3:* = new Vector.<AnimatedQuaternion>(_loc_2);
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = new AnimatedQuaternion();
                _loc_3[_loc_4].read(param1);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function readAnimatedVector3DSet(param1:ByteArray, param2:Boolean = true) : Vector.<AnimatedVector3D>
        {
            var _loc_3:* = param1.readInt();
            var _loc_4:* = new Vector.<AnimatedVector3D>(_loc_3);
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4[_loc_5] = new AnimatedVector3D();
                _loc_4[_loc_5].read(param1, param2);
                _loc_5++;
            }
            return _loc_4;
        }// end function

        public static function readAnimatedUShortSet(param1:ByteArray) : Vector.<AnimatedUShort>
        {
            var _loc_2:* = param1.readInt();
            var _loc_3:* = new Vector.<AnimatedUShort>(_loc_2);
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = new AnimatedUShort();
                _loc_3[_loc_4].read(param1);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function readAnimatedByteSet(param1:ByteArray) : Vector.<AnimatedByte>
        {
            var _loc_2:* = param1.readInt();
            var _loc_3:* = new Vector.<AnimatedByte>(_loc_2);
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = new AnimatedByte();
                _loc_3[_loc_4].read(param1);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function readVector2D(param1:ByteArray) : Vector3D
        {
            var _loc_2:* = param1.readFloat();
            var _loc_3:* = param1.readFloat();
            return new Vector3D(_loc_2, _loc_3);
        }// end function

        public static function readVector3D(param1:ByteArray, param2:Boolean = true) : Vector3D
        {
            var _loc_3:* = param1.readFloat();
            var _loc_4:* = param1.readFloat();
            var _loc_5:* = param1.readFloat();
            if (param2)
            {
                return new Vector3D(_loc_3, _loc_5, _loc_4);
            }
            return new Vector3D(_loc_3, _loc_4, _loc_5);
        }// end function

        public static function readQuaternion(param1:ByteArray) : Quaternion
        {
            var _loc_2:* = param1.readFloat();
            var _loc_3:* = param1.readFloat();
            var _loc_4:* = param1.readFloat();
            var _loc_5:* = param1.readFloat();
            return new Quaternion(_loc_2, _loc_4, _loc_3, _loc_5);
        }// end function

    }
}
