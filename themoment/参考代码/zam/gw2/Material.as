package com.zam.gw2
{
    import flash.utils.*;

    public class Material extends Object
    {
        public var type:uint;
        public var index:uint;
        public var flags:uint;
        public var fileId:uint;

        public function Material()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.type = param1.readUnsignedByte();
            this.index = param1.readUnsignedInt();
            this.flags = param1.readUnsignedInt();
            this.fileId = param1.readUnsignedInt();
            return;
        }// end function

    }
}
