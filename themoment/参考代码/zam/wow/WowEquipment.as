package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.net.*;

    public class WowEquipment extends Object
    {
        public var geosets:Array;
        public var textures:Array;
        public var models:Vector.<Object>;
        public var slot:int;
        public var uniqueSlot:int;
        public var sortValue:int;
        public var geoA:int;
        public var geoB:int;
        public var geoC:int;
        public var rootModel:WowModel;
        public var modelName:String;
        public var loaded:Boolean;
        public var meta:Object;

        public function WowEquipment(param1:WowModel, param2:int, param3:String = null, param4:int = 0, param5:int = 0)
        {
            this.rootModel = param1;
            this.slot = param2;
            this.uniqueSlot = WowModel.UniqueSlots[param2];
            this.sortValue = WowModel.SlotOrder[param2];
            if (param3)
            {
                this.load(param3, param4, param5);
            }
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_1:* = 0;
            if (this.models)
            {
                _loc_1 = 0;
                while (_loc_1 < this.models.length)
                {
                    
                    if (this.models[_loc_1].model)
                    {
                        this.models[_loc_1].model.refresh();
                    }
                    _loc_1++;
                }
            }
            if (this.textures)
            {
                _loc_1 = 0;
                while (_loc_1 < this.textures.length)
                {
                    
                    if (this.textures[_loc_1].texture)
                    {
                        this.textures[_loc_1].texture.refresh();
                    }
                    _loc_1++;
                }
            }
            return;
        }// end function

        public function load(param1:String, param2:int, param3:int) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            this.modelName = param1;
            if (this.slot == WowModel.SlotShoulder)
            {
                this.models = new Vector.<Object>(2);
            }
            else if (WowModel.SlotType[this.slot] != WowModel.TypeArmor)
            {
                this.models = new Vector.<Object>(1);
            }
            if (this.models)
            {
                _loc_4 = this.slot;
                if (this.slot == WowModel.SlotRanged)
                {
                    _loc_4 = WowModel.SlotRightHand;
                }
                _loc_5 = 0;
                while (_loc_5 < this.models.length)
                {
                    
                    this.models[_loc_5] = {race:param2, gender:param3, bone:-1, attachment:null};
                    this.models[_loc_5].model = new WowModel(this.rootModel.contentPath, this.rootModel.viewer, {_parentModel:this.rootModel});
                    this.models[_loc_5].model.load(WowModel.SlotType[this.slot], param1, this.slot == WowModel.SlotShoulder ? ((_loc_5 + 1)) : (this.rootModel._race), this.rootModel._gender);
                    _loc_5++;
                }
                this.loaded = true;
                this.rootModel.updateMeshes();
            }
            else
            {
                _loc_6 = new ZamLoader();
                _loc_6.dataFormat = URLLoaderDataFormat.TEXT;
                _loc_6.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.parseMeta, false, 0, true);
                _loc_6.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
                _loc_6.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
                _loc_6.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
                _loc_7 = "meta/armor/" + this.slot + "/" + param1 + ".json";
                _loc_6.load(new URLRequest(this.rootModel.contentPath + _loc_7.toLowerCase()));
            }
            return;
        }// end function

        private function parseMeta(event:FileLoadEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            this.meta = JSON.parse(event.target.data);
            this.slot = parseInt(this.meta.Slot);
            if (this.meta.Geosets)
            {
                this.geosets = [];
                for (_loc_2 in this.meta.Geosets)
                {
                    
                    this.geosets.push({index:parseInt(_loc_2), value:_loc_10[_loc_2]});
                }
            }
            if (this.meta.GenderTextures)
            {
                this.textures = [];
                for (_loc_3 in this.meta.GenderTextures)
                {
                    
                    _loc_4 = parseInt(_loc_3);
                    if (_loc_4 == this.rootModel._gender && !this.rootModel._npcTexture)
                    {
                        _loc_5 = _loc_10[_loc_3];
                        for (_loc_6 in _loc_5)
                        {
                            
                            _loc_7 = parseInt(_loc_6);
                            _loc_8 = {region:_loc_7, gender:_loc_4, file:_loc_5[_loc_6], texture:null};
                            if (_loc_7 > 0)
                            {
                                _loc_8.texture = new WowTexture(this.rootModel, _loc_7, _loc_5[_loc_6], WowTexture.ARMOR);
                            }
                            else
                            {
                                this.rootModel._specialTextures[2] = new WowTexture(this.rootModel, 2, _loc_5[_loc_6], WowTexture.SPECIAL);
                            }
                            this.textures.push(_loc_8);
                        }
                    }
                }
            }
            this.geoA = this.meta.GeosetA;
            this.geoB = this.meta.GeosetB;
            this.geoC = this.meta.GeosetC;
            if (this.slot == WowModel.SlotHead)
            {
                this.rootModel._hairVis = this.meta.ShowHair == 0;
                this.rootModel._faceVis = this.meta.ShowFacial1 == 0;
            }
            else if (this.slot == WowModel.SlotBelt && this.meta.GenderModels && this.meta.GenderModels[this.rootModel._gender])
            {
                this.models = new Vector.<Object>(1);
                this.models[0] = {race:0, gender:0, bone:-1, attachment:null};
                this.models[0].model = new WowModel(this.rootModel.contentPath, this.rootModel.viewer, {_parentModel:this.rootModel});
                this.models[0].model.parseMeta(event);
            }
            else if (this.slot == WowModel.SlotPants && this.geoC > 0)
            {
                this.sortValue = this.sortValue + 2;
            }
            else if (this.slot == WowModel.SlotGloves && this.geoA > 0)
            {
                this.sortValue = this.sortValue + 2;
            }
            this.loaded = true;
            this.rootModel.updateMeshes();
            return;
        }// end function

        private function _parseSis(param1:Array) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = 0;
            var _loc_9:* = null;
            this.slot = parseInt(param1.shift());
            var _loc_5:* = parseInt(param1.shift());
            this.geosets = new Vector.<Object>(_loc_5);
            _loc_4 = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_2 = param1.shift();
                _loc_3 = _loc_2.split(" ");
                this.geosets[_loc_4] = {index:_loc_3[0], value:_loc_3[1]};
                _loc_4++;
            }
            var _loc_6:* = parseInt(param1.shift());
            this.textures = new Vector.<Object>(_loc_6);
            _loc_4 = 0;
            while (_loc_4 < _loc_6)
            {
                
                _loc_2 = param1.shift();
                _loc_3 = _loc_2.split(" ");
                _loc_7 = parseInt(_loc_3.shift());
                _loc_8 = parseInt(_loc_3.shift());
                _loc_9 = _loc_3.join(" ");
                this.textures[_loc_4] = {region:_loc_7, gender:_loc_8, file:_loc_9, texture:null};
                if (_loc_8 == this.rootModel._gender && !this.rootModel._npcTexture)
                {
                    if (_loc_7 > 0)
                    {
                        this.textures[_loc_4].texture = new WowTexture(this.rootModel, _loc_7, _loc_9, WowTexture.ARMOR);
                    }
                    else
                    {
                        this.rootModel._specialTextures[2] = new WowTexture(this.rootModel, 2, _loc_9, WowTexture.SPECIAL);
                    }
                }
                _loc_4++;
            }
            _loc_2 = param1.shift();
            _loc_3 = _loc_2.split(" ");
            if (_loc_3.length == 3)
            {
                this.geoA = parseInt(_loc_3[0]);
                this.geoB = parseInt(_loc_3[1]);
                this.geoC = parseInt(_loc_3[2]);
            }
            return;
        }// end function

        private function parseSis(event:FileLoadEvent) : void
        {
            var _loc_2:* = event.target.data.split("\r\n");
            this._parseSis(_loc_2);
            this.loaded = true;
            this.rootModel.updateMeshes();
            return;
        }// end function

        private function parseMum(event:FileLoadEvent) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_2:* = event.target.data.split("\r\n");
            this._parseSis(_loc_2);
            if (this.slot == WowModel.SlotBelt && _loc_2.length > 1)
            {
                this.models = new Vector.<Object>(1);
                _loc_3 = -1;
                if (this.rootModel._attachments && this.rootModel._attachments.length > 0)
                {
                    _loc_5 = this.rootModel._attachments.length;
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5)
                    {
                        
                        if (this.rootModel._attachments[_loc_6]._slot == WowModel.SlotBelt)
                        {
                            _loc_4 = this.rootModel._attachments[_loc_6];
                            _loc_3 = _loc_4._bone;
                            break;
                        }
                        _loc_6++;
                    }
                }
                this.models[0] = {race:0, gender:0, bone:_loc_3, attachment:_loc_4};
                this.models[0].model = new WowModel(this.rootModel.contentPath, this.rootModel.viewer, {_parentModel:this.rootModel});
                if (!this.models[0].model._parseMum(_loc_2))
                {
                    this.models = null;
                }
            }
            this.loaded = true;
            this.rootModel.updateMeshes();
            return;
        }// end function

        private function onLoadStart(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_START, event.url);
            this.rootModel.viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onLoadProgress(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, event.url, event.currentBytes, event.totalBytes);
            this.rootModel.viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onLoadError(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, event.url, -1, -1, event.errorMessage);
            this.rootModel.viewer.dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
