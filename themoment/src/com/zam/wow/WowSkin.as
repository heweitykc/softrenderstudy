package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class WowSkin extends Object
    {
        public var baseTexture:String;
        public var furTexture:String;
        public var pantiesTexture:String;
        public var braTexture:String;
        public var faces:Vector.<WowFace>;

        public function WowSkin()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.baseTexture = param1.readUTF();
            this.furTexture = param1.readUTF();
            this.pantiesTexture = param1.readUTF();
            this.braTexture = param1.readUTF();
            return;
        }// end function

        public function readFaces(param1:ByteArray) : void
        {
            var _loc_2:* = param1.readInt();
            this.faces = new Vector.<WowFace>(_loc_2);
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.faces[_loc_3] = new WowFace();
                this.faces[_loc_3].read(param1);
                _loc_3++;
            }
            return;
        }// end function

    }
}
