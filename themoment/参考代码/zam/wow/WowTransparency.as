package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class WowTransparency extends Object
    {
        public var alpha:Vector.<AnimatedUShort>;

        public function WowTransparency()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.alpha = WowUtil.readAnimatedUShortSet(param1);
            return;
        }// end function

        public function used(param1:int) : Boolean
        {
            if (this.alpha.length == 0)
            {
                return false;
            }
            if (param1 < this.alpha.length)
            {
                return this.alpha[param1]._used;
            }
            return this.alpha[0]._used;
        }// end function

        public function getValue(param1:int, param2:int) : Number
        {
            var _loc_3:* = NaN;
            if (this.used(param1))
            {
                _loc_3 = AnimatedUShort.getValueFrom(this.alpha, param1, param2) / 32767;
            }
            else
            {
                _loc_3 = 1;
            }
            if (_loc_3 > 1)
            {
                _loc_3 = 1;
            }
            else if (_loc_3 < 0)
            {
                _loc_3 = 0;
            }
            return _loc_3;
        }// end function

    }
}
