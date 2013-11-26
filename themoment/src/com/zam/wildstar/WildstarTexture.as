package com.zam.wildstar
{
    import com.zam.*;
    import flash.utils.*;

    public class WildstarTexture extends ZamTexture
    {
        protected var _type:int;

        public function WildstarTexture(param1:Viewer, param2:String, param3:Boolean = true)
        {
            super(param1, param2, param3);
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this._type = param1.readShort();
            url = param1.readUTF().replace(".tex", ".png");
            return;
        }// end function

    }
}
