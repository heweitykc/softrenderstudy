package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class AnimatedSimpleUShort extends Object
    {
        public var _times:Vector.<uint>;
        public var _data:Vector.<uint>;

        public function AnimatedSimpleUShort()
        {
            return;
        }// end function

        public function getValue(param1:int, param2:int = 0) : int
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
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
                return this._data[_loc_4] + (this._data[(_loc_4 + 1)] - this._data[_loc_4]) * _loc_8;
            }
            else
            {
            }
            return this._data[0];
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
            this._data = new Vector.<uint>(_loc_3);
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this._data[_loc_2] = param1.readUnsignedShort();
                _loc_2++;
            }
            return;
        }// end function

    }
}
