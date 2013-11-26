package com.zam.wow
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class WowFaceFeature extends Object
    {
        public var geoset1:int;
        public var geoset2:int;
        public var geoset3:int;
        public var textures:Vector.<WowFaceFeatureTexture>;

        public function WowFaceFeature()
        {
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this.geoset1 = param1.readInt();
            this.geoset2 = param1.readInt();
            this.geoset3 = param1.readInt();
            return;
        }// end function

        public function readTextures(param1:ByteArray) : void
        {
            var _loc_2:* = param1.readInt();
            this.textures = new Vector.<WowFaceFeatureTexture>(_loc_2);
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                this.textures[_loc_3] = new WowFaceFeatureTexture();
                this.textures[_loc_3].read(param1);
                _loc_3++;
            }
            return;
        }// end function

    }
}
