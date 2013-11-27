package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class WowHair extends Object
    {
        public var geoset:int;
        public var index:int;
        public var textures:Vector.<WowHairTexture>;

        public function WowHair()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.geoset = param1.readInt();
            this.index = param1.readInt();
            return;
        }// end function

        public function readTextures(param1:ByteArray) : void
        {
            var _loc_2:* = param1.readInt();
            this.textures = new Vector.<WowHairTexture>(_loc_2);
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.textures[_loc_3] = new WowHairTexture();
                this.textures[_loc_3].read(param1);
                _loc_3++;
            }
            return;
        }// end function

    }
}
