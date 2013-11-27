package com.zam.wow
{
    import flash.utils.*;

    public class WowFace extends Object
    {
        public var lowerTexture:String;
        public var upperTexture:String;

        public function WowFace()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.lowerTexture = param1.readUTF();
            this.upperTexture = param1.readUTF();
            return;
        }// end function

    }
}
