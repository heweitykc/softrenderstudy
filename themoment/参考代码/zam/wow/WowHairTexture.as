package com.zam.wow
{
    import flash.utils.*;

    public class WowHairTexture extends Object
    {
        public var texture:String;
        public var lowerTexture:String;
        public var upperTexture:String;

        public function WowHairTexture()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.texture = param1.readUTF();
            this.lowerTexture = param1.readUTF();
            this.upperTexture = param1.readUTF();
            return;
        }// end function

    }
}
