package com.zam.wow
{
    import flash.utils.*;

    public class WowRenderFlag extends Object
    {
        public var flags:uint;
        public var blend:uint;

        public function WowRenderFlag()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.flags = param1.readUnsignedShort();
            this.blend = param1.readUnsignedShort();
            return;
        }// end function

    }
}
