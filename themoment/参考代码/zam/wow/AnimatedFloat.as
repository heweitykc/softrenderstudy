package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class AnimatedFloat extends Object
    {
        public var _type:int;
        public var _seq:int;
        public var _used:Boolean;
        public var _times:Vector.<int>;
        public var _data:Vector.<Number>;

        public function AnimatedFloat()
        {
            return;
        }// end function

        public function getValue(param1:int, param2:Number = 0) : Number
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            if (this._type != 0 || this._data.length > 1)
            {
                if (this._times.length > 1)
                {
                    _loc_3 = this._times[(this._times.length - 1)];
                    if (_loc_3 > 0 && param1 > _loc_3)
                    {
                        param1 = param1 % _loc_3;
                    }
                    _loc_6 = 0;
                    _loc_7 = 0;
                    while (_loc_7 < (this._times.length - 1))
                    {
                        
                        if (param1 >= this._times[_loc_7] && param1 < this._times[(_loc_7 + 1)])
                        {
                            _loc_6 = _loc_7;
                            break;
                        }
                        _loc_7++;
                    }
                    _loc_4 = this._times[_loc_6];
                    _loc_5 = this._times[(_loc_6 + 1)];
                    _loc_8 = 0;
                    if (_loc_4 != _loc_5)
                    {
                        _loc_8 = (param1 - _loc_4) / (_loc_5 - _loc_4);
                    }
                    if (this._type == 1)
                    {
                        return this._data[_loc_6] + (this._data[(_loc_6 + 1)] - this._data[_loc_6]) * _loc_8;
                    }
                    return this._data[_loc_6];
                }
                else
                {
                    if (this._data.length > 0)
                    {
                        return this._data[0];
                    }
                    return param2;
                }
            }
            else
            {
                if (this._data.length == 0)
                {
                    return param2;
                }
            }
            return this._data[0];
        }// end function

        public function read(param1:ByteArray) : void
        {
            var _loc_2:* = 0;
            this._type = param1.readShort();
            this._seq = param1.readShort();
            this._used = param1.readBoolean();
            var _loc_3:* = param1.readInt();
            this._times = new Vector.<int>(_loc_3);
            _loc_2 = 0;
            while (_loc_2 < _loc_3)
            {
                
                this._times[_loc_2] = param1.readInt();
                _loc_2++;
            }
            _loc_3 = param1.readInt();
            this._data = new Vector.<Number>(_loc_3);
            if (_loc_3 > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_3)
                {
                    
                    this._data[_loc_2] = param1.readFloat();
                    _loc_2++;
                }
            }
            return;
        }// end function

        public static function getValueFrom(param1:Vector.<AnimatedFloat>, param2:int, param3:int) : Number
        {
            if (param1.length == 0)
            {
                return 0;
            }
            if (param2 >= param1.length)
            {
                param2 = 0;
            }
            return param1[param2].getValue(param3);
        }// end function

    }
}
