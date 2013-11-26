package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.geom.*;
    import flash.utils.*;

    public class AnimatedSimpleVector2D extends Object
    {
        public var _times:Vector.<uint>;
        public var _data:Vector.<Vector3D>;

        public function AnimatedSimpleVector2D()
        {
            return;
        }// end function

        public function getValue(param1:int, param2:Vector3D = null) : Vector3D
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            if (!param2)
            {
                param2 = new Vector3D();
            }
            if (this._data.length > 1 && this._times.length > 1)
            {
                _loc_3 = this._times[(this._times.length - 1)];
                if (_loc_3 > 0 && param1 > _loc_3)
                {
                    param1 = param1 % _loc_3;
                }
                _loc_4 = 0;
                _loc_5 = 0;
                while (_loc_5 < (this._times.length - 1))
                {
                    
                    if (param1 >= this._times[_loc_5] && param1 < this._times[(_loc_5 + 1)])
                    {
                        _loc_4 = _loc_5;
                        break;
                    }
                    _loc_5++;
                }
                _loc_6 = this._times[_loc_4];
                _loc_7 = this._times[(_loc_4 + 1)];
                _loc_8 = 0;
                if (_loc_6 != _loc_7)
                {
                    _loc_8 = (param1 - _loc_6) / (_loc_7 - _loc_6);
                }
                return VectorUtil.interpolate(this._data[_loc_4], this._data[(_loc_4 + 1)], _loc_8, param2);
            }
            else
            {
                param2.copyFrom(this._data[0]);
            }
            return param2;
            return param2;
        }// end function

        public function read(param1:ByteArray) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = param1.readInt();
            this._times = new Vector.<uint>(_loc_3);
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this._times[_loc_2] = param1.readUnsignedInt();
                _loc_2++;
            }
            _loc_3 = param1.readInt();
            this._data = new Vector.<Vector3D>(_loc_3);
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this._data[_loc_2] = WowUtil.readVector2D(param1);
                _loc_2++;
            }
            return;
        }// end function

    }
}
