package com.zam.wow
{
    import flash.utils.*;

    public class WowMaterial extends Object
    {
        public var _type:int;
        public var _flags:uint;
        public var _filename:String;
        public var _texture:WowTexture = null;
        protected var _mesh:WowModel;
        public var _index:int;

        public function WowMaterial(param1:WowModel, param2:int, param3:String = null)
        {
            this._mesh = param1;
            this._index = param2;
            if (param3 != null)
            {
                this._filename = param3;
                this.load();
            }
            return;
        }// end function

        public function read(param1:ByteArray) : void
        {
            this._type = param1.readInt();
            this._flags = param1.readUnsignedInt();
            this._filename = param1.readUTF();
            this.load();
            return;
        }// end function

        public function load() : void
        {
            if (this._filename.length > 0)
            {
                this._texture = new WowTexture(this._mesh, this._index, this._filename);
            }
            return;
        }// end function

    }
}
