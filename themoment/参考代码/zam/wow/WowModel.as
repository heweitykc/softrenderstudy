package com.zam.wow
{
    import __AS3__.vec.*;
    import com.zam.*;
    import flash.display3D.*;
    import flash.events.*;
    import flash.external.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;

    public class WowModel extends Mesh
    {
        public var _model:String;
        public var _modelType:int;
        protected var _modelLoadType:int;
        protected var _ready:Boolean;
        public var _race:int = -1;
        public var _gender:int = -1;
        public var _shoulderIndex:int = -1;
        protected var _currentSkin:int;
        protected var _currentFace:int;
        protected var _currentHair:int;
        protected var _currentHairTexture:int;
        protected var _currentFaceFeature:int;
        protected var _currentFaceTexture:int;
        protected var _currentFaceMesh:WowTexUnit;
        protected var _currentHairMesh:WowTexUnit;
        protected var _boundsMin:Vector3D;
        protected var _boundsMax:Vector3D;
        protected var _boundsSize:Vector3D;
        protected var _boundsCenter:Vector3D;
        protected var _freshBounds:Boolean;
        public var _meta:Object;
        public var _textures:Array;
        public var _specialTextures:Array;
        public var _bakedTextures:Array;
        public var _npcTexture:WowTexture;
        public var _bakedTexture:WowTexture;
        public var _slotAttachments:Object;
        public var _vertices:Vector.<WowVertex>;
        public var _indices:Vector.<uint>;
        public var _sequences:Vector.<int>;
        public var _animations:Vector.<WowAnimation>;
        public var _animLookup:Vector.<int>;
        public var _bones:Vector.<WowBone>;
        public var _boneLookup:Vector.<int>;
        public var _keyBoneLookup:Vector.<int>;
        public var _meshes:Vector.<WowMesh>;
        public var _texUnits:Vector.<WowTexUnit>;
        public var _texUnitLookup:Vector.<int>;
        public var _renderFlags:Vector.<WowRenderFlag>;
        public var _materials:Vector.<WowMaterial>;
        public var _materialLookup:Vector.<int>;
        public var _textureAnims:Vector.<WowTextureAnimation>;
        public var _textureAnimLookup:Vector.<int>;
        public var _textureReplacements:Vector.<int>;
        public var _attachments:Vector.<WowAttachment>;
        public var _attachmentLookup:Vector.<int>;
        public var _colors:Vector.<WowColor>;
        public var _alphas:Vector.<WowTransparency>;
        public var _alphaLookup:Vector.<int>;
        public var _particleEmitters:Vector.<WowParticleEmitter>;
        public var _ribbonEmitters:Vector.<WowRibbonEmitter>;
        public var _skin:Vector.<WowSkin>;
        public var _faceFeature:Vector.<WowFaceFeature>;
        public var _hair:Vector.<WowHair>;
        public var _hairVis:Boolean = true;
        public var _faceVis:Boolean = true;
        public var _cullFace:String = "front";
        protected var _geosets:Vector.<int>;
        public var _equipment:Vector.<WowEquipment>;
        public var _time:int;
        public var _currentAnim:int;
        public var _animListIndex:int;
        public var _animList:Vector.<WowAnimation>;
        public var _startTime:int;
        public var _freeze:Boolean;
        public var _spinSpeed:int;
        protected var _vbData:Vector.<Number>;
        protected var _vb:VertexBuffer3D;
        protected var _matrix:Matrix3D;
        protected var _constants:Vector.<Number>;
        protected var _constants2:Vector.<Number>;
        protected var _lightPos1:Vector.<Number>;
        protected var _lightPos2:Vector.<Number>;
        protected var _lightPos3:Vector.<Number>;
        protected var _ambientColor:Vector.<Number>;
        protected var _primaryColor:Vector.<Number>;
        protected var _secondColor:Vector.<Number>;
        private var billboardMatrix:Matrix3D;
        private var mvpMatrix:Matrix3D;
        private var mvMatrix:Matrix3D;
        private var normalMatrix:Matrix3D;
        private var matVector:Vector.<Number>;
        private var tmpVec:Vector3D;
        private var tmpMatrix:Matrix3D;
        private var _billboardMatrices:Boolean = false;
        private const DebugChecks:Boolean = false;
        private var _checks:Object;
        private static var _numChecks:int = 0;
        public static const TypeItem:int = 1;
        public static const TypeHelm:int = 2;
        public static const TypeShoulder:int = 4;
        public static const TypeNpc:int = 8;
        public static const TypeCharacter:int = 16;
        public static const TypeHumanoidNpc:int = 32;
        public static const TypeObject:int = 64;
        public static const TypeArmor:int = 128;
        public static const TypePath:int = 256;
        public static const Genders:Array = new Array("Male", "Female");
        public static const Races:Array = new Array("", "Human", "Orc", "Dwarf", "NightElf", "Scourge", "Tauren", "Gnome", "Troll", "Goblin", "BloodElf", "Draenei", "FelOrc", "Naga_", "Broken", "Skeleton", "Vrykul", "Tuskarr", "ForestTroll", "Taunka", "NorthrendSkeleton", "IceTroll", "Worgen", "Human", "Pandaren");
        public static const UniqueSlots:Array = new Array(0, 1, 0, 3, 4, 5, 6, 7, 8, 9, 10, 0, 0, 21, 22, 22, 16, 21, 0, 19, 5, 21, 22, 22, 0, 21, 21);
        public static const SlotOrder:Array = new Array(0, 16, 0, 15, 1, 8, 10, 5, 6, 6, 7, 0, 0, 17, 18, 19, 14, 20, 0, 9, 8, 21, 22, 23, 0, 24, 25);
        public static const SlotType:Array = new Array(0, 2, 0, 4, 128, 128, 128, 128, 128, 128, 128, 0, 0, 1, 1, 1, 128, 1, 0, 128, 128, 1, 1, 1, 0, 1, 1);
        public static const AlternateSlot:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22, 0, 0, 0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        public static const SlotHead:int = 1;
        public static const SlotShoulder:int = 3;
        public static const SlotShirt:int = 4;
        public static const SlotChest:int = 5;
        public static const SlotBelt:int = 6;
        public static const SlotPants:int = 7;
        public static const SlotBoots:int = 8;
        public static const SlotBracers:int = 9;
        public static const SlotGloves:int = 10;
        public static const SlotOneHand:int = 13;
        public static const SlotShield:int = 14;
        public static const SlotBow:int = 15;
        public static const SlotCape:int = 16;
        public static const SlotTwoHand:int = 17;
        public static const SlotTabard:int = 19;
        public static const SlotRobe:int = 20;
        public static const SlotRightHand:int = 21;
        public static const SlotLeftHand:int = 22;
        public static const SlotOffHand:int = 23;
        public static const SlotThrown:int = 25;
        public static const SlotRanged:int = 26;
        public static const RegionBase:int = 0;
        public static const RegionArmUpper:int = 1;
        public static const RegionArmLower:int = 2;
        public static const RegionHand:int = 3;
        public static const RegionFaceUpper:int = 4;
        public static const RegionFaceLower:int = 5;
        public static const RegionTorsoUpper:int = 6;
        public static const RegionTorsoLower:int = 7;
        public static const RegionPelvisUpper:int = 8;
        public static const RegionLegUpper:int = 8;
        public static const RegionPelvisLower:int = 9;
        public static const RegionLegLower:int = 9;
        public static const RegionFoot:int = 10;
        public static const TextureRegions:Array = new Array(new Array(0, 0, 1, 1), new Array(0, 0, 0.5, 0.25), new Array(0, 0.25, 0.5, 0.25), new Array(0, 0.5, 0.5, 0.125), new Array(0, 0.625, 0.5, 0.125), new Array(0, 0.75, 0.5, 0.25), new Array(0.5, 0, 0.5, 0.25), new Array(0.5, 0.25, 0.5, 0.125), new Array(0.5, 0.375, 0.5, 0.25), new Array(0.5, 0.625, 0.5, 0.25), new Array(0.5, 0.875, 0.5, 0.125));
        public static const NewTextureRegions:Array = new Array(new Array(0, 0, 1, 1), new Array(0, 0, 0.25, 0.25), new Array(0, 0.25, 0.25, 0.25), new Array(0, 0.5, 0.25, 0.125), new Array(0.5, 0, 0.5, 1), new Array(0, 0.75, 0.25, 0.25), new Array(0.25, 0, 0.25, 0.25), new Array(0.25, 0.25, 0.25, 0.125), new Array(0.25, 0.375, 0.25, 0.25), new Array(0.25, 0.625, 0.25, 0.25), new Array(0.25, 0.875, 0.25, 0.125));
        public static const BoneLeftArm:int = 0;
        public static const BoneRightArm:int = 1;
        public static const BoneLeftShoulder:int = 2;
        public static const BoneRightShoulder:int = 3;
        public static const BoneStomach:int = 4;
        public static const BoneWaist:int = 5;
        public static const BoneHead:int = 6;
        public static const BoneJaw:int = 7;
        public static const BoneRightFinger1:int = 8;
        public static const BoneRightFinger2:int = 9;
        public static const BoneRightFinger3:int = 10;
        public static const BoneRightFingers:int = 11;
        public static const BoneRightThumb:int = 12;
        public static const BoneLeftFinger1:int = 13;
        public static const BoneLeftFinger2:int = 14;
        public static const BoneLeftFinger3:int = 15;
        public static const BoneLeftFingers:int = 16;
        public static const BoneLeftThumb:int = 17;
        public static const BoneRoot:int = 26;

        public function WowModel(param1:String, param2:Viewer, param3:Object)
        {
            this._meta = {};
            this._textures = new Array();
            this._specialTextures = new Array();
            this._bakedTextures = [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}];
            this._slotAttachments = {};
            this._checks = {};
            super(param1, param2, param3);
            this._geosets = new Vector.<int>(20);
            this._equipment = new Vector.<WowEquipment>;
            this._matrix = new Matrix3D();
            var _loc_4:* = new Vector3D(5, 5, -5);
            _loc_4.normalize();
            var _loc_5:* = new Vector3D(5, 5, 5);
            _loc_5.normalize();
            var _loc_6:* = new Vector3D(-5, -5, -5);
            _loc_6.normalize();
            this._constants = this.Vector.<Number>([0, 1, 2, Math.PI]);
            this._constants2 = this.Vector.<Number>([0.7, 0, 0, 0]);
            this._lightPos1 = this.Vector.<Number>([_loc_4.x, _loc_4.y, _loc_4.z, 0]);
            this._lightPos2 = this.Vector.<Number>([_loc_5.x, _loc_5.y, _loc_5.z, 0]);
            this._lightPos3 = this.Vector.<Number>([_loc_6.x, _loc_6.y, _loc_6.z, 0]);
            this._ambientColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this._primaryColor = this.Vector.<Number>([1, 1, 1, 1]);
            this._secondColor = this.Vector.<Number>([0.35, 0.35, 0.35, 1]);
            this.billboardMatrix = new Matrix3D();
            this.mvpMatrix = new Matrix3D();
            this.mvMatrix = new Matrix3D();
            this.normalMatrix = new Matrix3D();
            this.matVector = new Vector.<Number>(16);
            this.tmpVec = new Vector3D();
            this.tmpMatrix = new Matrix3D();
            return;
        }// end function

        public function get ready() : Boolean
        {
            return this._ready;
        }// end function

        public function get animations() : Vector.<WowAnimation>
        {
            return this._animations;
        }// end function

        public function get bones() : Vector.<WowBone>
        {
            return this._bones;
        }// end function

        public function get currentAnimation() : WowAnimation
        {
            if (this._currentAnim > -1)
            {
                return this._animations[this._currentAnim];
            }
            return null;
        }// end function

        public function get modelMatrix() : Matrix3D
        {
            return this._matrix;
        }// end function

        override public function refresh() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            if (this._npcTexture)
            {
                this._npcTexture.refresh();
            }
            if (this._bakedTexture)
            {
                this._bakedTexture.refresh();
            }
            for each (_loc_2 in this._textures)
            {
                
                _loc_2.refresh();
            }
            for each (_loc_2 in this._specialTextures)
            {
                
                _loc_2.refresh();
            }
            if (this._vb)
            {
                this._vb.dispose();
                this._vb = null;
            }
            _loc_1 = 0;
            while (this._texUnits && _loc_1 < this._texUnits.length)
            {
                
                this._texUnits[_loc_1].refresh();
                _loc_1++;
            }
            _loc_1 = 0;
            while (this._particleEmitters && _loc_1 < this._particleEmitters.length)
            {
                
                this._particleEmitters[_loc_1].refresh();
                _loc_1++;
            }
            _loc_1 = 0;
            while (this._ribbonEmitters && _loc_1 < this._ribbonEmitters.length)
            {
                
                this._ribbonEmitters[_loc_1].refresh();
                _loc_1++;
            }
            _loc_1 = 0;
            while (this._equipment && _loc_1 < this._equipment.length)
            {
                
                this._equipment[_loc_1].refresh();
                _loc_1++;
            }
            return;
        }// end function

        override public function load(param1:int, param2:String, param3:int = -1, param4:int = -1) : void
        {
            var url:String;
            var type:* = param1;
            var model:* = param2;
            var raceOrIndex:* = param3;
            var gender:* = param4;
            this._model = model;
            this._modelLoadType = type;
            if (type != TypePath)
            {
                this._modelType = type;
            }
            if (this._modelType != TypeShoulder && raceOrIndex > -1)
            {
                this._race = raceOrIndex;
            }
            else if (this._modelType == TypeShoulder)
            {
                if (raceOrIndex == -1)
                {
                    raceOrIndex;
                }
                this._shoulderIndex = raceOrIndex;
            }
            if (gender > -1)
            {
                this._gender = gender;
            }
            var loader:* = new ZamLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener(FileLoadEvent.LOAD_COMPLETE, this.onLoaded, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError, false, 0, true);
            loader.addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress, false, 0, true);
            try
            {
                switch(this._modelLoadType)
                {
                    case TypeItem:
                    {
                        url = "meta/item/" + this._model + ".json";
                        break;
                    }
                    case TypeHelm:
                    {
                        url = "meta/armor/1/" + this._model + ".json";
                        break;
                    }
                    case TypeShoulder:
                    {
                        url = "meta/armor/3/" + this._model + ".json";
                        break;
                    }
                    case TypeNpc:
                    case TypeHumanoidNpc:
                    {
                        url = "meta/npc/" + this._model + ".json";
                        break;
                    }
                    case TypeObject:
                    {
                        url = "meta/object/" + this._model + ".json";
                        break;
                    }
                    case TypeCharacter:
                    {
                        url = "meta/character/" + this._model + ".json";
                        break;
                    }
                    case TypePath:
                    {
                        url = "mo3/" + model;
                        loader.dataFormat = URLLoaderDataFormat.BINARY;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                loader.load(new URLRequest(_contentPath + url.toLowerCase()));
            }
            catch (ex:Error)
            {
            }
            return;
        }// end function

        public function setAnimation(param1:String) : void
        {
            this._animList = new Vector.<WowAnimation>;
            var _loc_2:* = 0;
            while (_loc_2 < this._animations.length)
            {
                
                if (!this._animations[_loc_2].name)
                {
                }
                else if (param1 == "Stand")
                {
                    if (this._animations[_loc_2].name == param1)
                    {
                        if (this._model == "pandarenmale" && this._animations[_loc_2].length == 11900)
                        {
                        }
                        this._animList.push(this._animations[_loc_2]);
                    }
                }
                else if (this._animations[_loc_2].name.indexOf(param1) == 0)
                {
                    this._animList.push(this._animations[_loc_2]);
                }
                _loc_2++;
            }
            this._startTime = 0;
            this._animListIndex = 0;
            this._currentAnim = this._animList.length > 0 ? (this._animList[0].index) : (0);
            if (param1 != "Stand" && this._animList.length == 0)
            {
                this.setAnimation("Stand");
            }
            return;
        }// end function

        override public function update(param1:Number) : void
        {
            var _loc_2:* = false;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_9:* = null;
            var _loc_10:* = NaN;
            var _loc_11:* = null;
            var _loc_12:* = 0;
            if (!this._ready)
            {
                return;
            }
            if (this._animList != null && this._animList.length > 0)
            {
                this._time = viewer.time;
                if (this._startTime == 0)
                {
                    this._startTime = this._time;
                }
                if (this._time - this._startTime >= this.currentAnimation.length)
                {
                    this._animListIndex = ZamUtil.randomInt(0, this._animList.length + 3) - 3;
                    this._animListIndex = this._animListIndex < 0 ? (0) : (this._animListIndex);
                    this._currentAnim = this._animList[this._animListIndex].index;
                    this._startTime = this._time;
                }
            }
            var _loc_7:* = this._vertices.length;
            var _loc_8:* = this._texUnits.length;
            if (!this._freeze && _loc_8 > 50 && _loc_7 > 3000)
            {
                _loc_2 = true;
                _loc_3 = 0;
                while (_loc_3 < _loc_8)
                {
                    
                    if (!this._texUnits[_loc_3]._show)
                    {
                    }
                    else
                    {
                        _loc_5 = this._texUnits[_loc_3]._mesh.indexCount;
                        _loc_6 = this._texUnits[_loc_3]._mesh.indexStart;
                        _loc_4 = 0;
                        while (_loc_4 < _loc_5)
                        {
                            
                            this._vertices[this._indices[_loc_6 + _loc_4]].currentTime = this._time;
                            _loc_4++;
                        }
                    }
                    _loc_3++;
                }
            }
            if (!this._freeze && this._bones.length > 0 && this._animations != null && this._animations.length > 0)
            {
                _loc_3 = 0;
                while (_loc_3 < this._bones.length)
                {
                    
                    this._bones[_loc_3]._calc = false;
                    _loc_3++;
                }
                _loc_3 = 0;
                while (_loc_3 < this._bones.length)
                {
                    
                    this._bones[_loc_3].calcMatrix(this._time - this._startTime);
                    _loc_3++;
                }
                if (this._vertices != null)
                {
                    _loc_3 = 0;
                    while (_loc_3 < _loc_7)
                    {
                        
                        _loc_9 = this._vertices[_loc_3];
                        if (_loc_2 && _loc_9.currentTime != this._time)
                        {
                        }
                        else
                        {
                            _loc_12 = _loc_3 * 8;
                            var _loc_13:* = 0;
                            this._vbData[_loc_12 + 5] = 0;
                            this._vbData[_loc_12 + 4] = _loc_13;
                            this._vbData[_loc_12 + 3] = _loc_13;
                            this._vbData[_loc_12 + 2] = _loc_13;
                            this._vbData[(_loc_12 + 1)] = _loc_13;
                            this._vbData[_loc_12] = _loc_13;
                            _loc_4 = 0;
                            while (_loc_4 < 4)
                            {
                                
                                if (_loc_9._weights[_loc_4] > 0)
                                {
                                    _loc_10 = _loc_9._weights[_loc_4] / 255;
                                    _loc_11 = this._bones[_loc_9._bones[_loc_4]];
                                    MatrixUtil.transform(_loc_11._matrix, _loc_9._position, this.tmpVec);
                                    this._vbData[_loc_12 + 0] = this._vbData[_loc_12 + 0] + this.tmpVec.x * _loc_10;
                                    this._vbData[(_loc_12 + 1)] = this._vbData[(_loc_12 + 1)] + this.tmpVec.y * _loc_10;
                                    this._vbData[_loc_12 + 2] = this._vbData[_loc_12 + 2] + this.tmpVec.z * _loc_10;
                                    MatrixUtil.transform(_loc_11._rotMatrix, _loc_9._normal, this.tmpVec);
                                    this._vbData[_loc_12 + 3] = this._vbData[_loc_12 + 3] + this.tmpVec.x * _loc_10;
                                    this._vbData[_loc_12 + 4] = this._vbData[_loc_12 + 4] + this.tmpVec.y * _loc_10;
                                    this._vbData[_loc_12 + 5] = this._vbData[_loc_12 + 5] + this.tmpVec.z * _loc_10;
                                }
                                _loc_4++;
                            }
                        }
                        _loc_3++;
                    }
                    this.updateBuffers(false);
                    if (!this._freshBounds)
                    {
                        this.calcBounds();
                        this._freshBounds = true;
                    }
                }
            }
            return;
        }// end function

        public function setDefaultMatrices() : void
        {
            if (!this._billboardMatrices)
            {
                return;
            }
            this._billboardMatrices = false;
            context.setProgramConstantsFromMatrix("vertex", 12, this.mvMatrix, true);
            return;
        }// end function

        public function setBillboardMatrices() : void
        {
            if (this._billboardMatrices)
            {
                return;
            }
            this._billboardMatrices = true;
            context.setProgramConstantsFromMatrix("vertex", 12, this.billboardMatrix, true);
            return;
        }// end function

        override public function render(param1:Number, param2:Boolean = true) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            if (!this._ready)
            {
                return;
            }
            if (this._spinSpeed != 0)
            {
                camera.rotate(Math.PI * 2 * (this._spinSpeed / 1000), 0);
            }
            this._billboardMatrices = false;
            this.mvpMatrix.copyFrom(camera.matrix);
            this.mvpMatrix.prepend(camera.modelMatrix);
            this.mvpMatrix.prepend(this._matrix);
            this.mvMatrix.copyFrom(camera.viewMatrix);
            this.mvMatrix.prepend(camera.modelMatrix);
            this.mvMatrix.prepend(this._matrix);
            this.billboardMatrix.identity();
            this.billboardMatrix.appendRotation(-90, Vector3D.Y_AXIS);
            this.normalMatrix.copyFrom(camera.viewMatrix);
            this.normalMatrix.prepend(camera.modelMatrix);
            this.normalMatrix.prepend(this._matrix);
            this.normalMatrix.invert();
            this.normalMatrix.transpose();
            context.setProgramConstantsFromMatrix("vertex", 0, this.mvpMatrix, true);
            context.setProgramConstantsFromMatrix("vertex", 4, this.normalMatrix, true);
            context.setProgramConstantsFromMatrix("vertex", 12, this.mvMatrix, true);
            context.setProgramConstantsFromMatrix("vertex", 20, camera.projMatrix, true);
            context.setProgramConstantsFromVector("vertex", 9, camera.positionVec);
            if (param2)
            {
                context.setProgramConstantsFromVector("vertex", 8, this._constants);
                context.setProgramConstantsFromVector("fragment", 0, this._constants);
                context.setProgramConstantsFromVector("fragment", 1, this._lightPos1);
                context.setProgramConstantsFromVector("fragment", 2, this._lightPos2);
                context.setProgramConstantsFromVector("fragment", 3, this._lightPos3);
                context.setProgramConstantsFromVector("fragment", 4, this._ambientColor);
                context.setProgramConstantsFromVector("fragment", 5, this._primaryColor);
                context.setProgramConstantsFromVector("fragment", 6, this._secondColor);
                context.setProgramConstantsFromVector("fragment", 7, this._constants2);
            }
            context.setVertexBufferAt(0, this._vb, 0, "float3");
            context.setVertexBufferAt(1, this._vb, 3, "float3");
            context.setVertexBufferAt(2, this._vb, 6, "float2");
            var _loc_5:* = this._texUnits.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                if (this._texUnits[_loc_3]._show)
                {
                    this._texUnits[_loc_3].render();
                }
                _loc_3++;
            }
            var _loc_6:* = this._equipment.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_6)
            {
                
                _loc_7 = this._equipment[_loc_3];
                if (!_loc_7.models)
                {
                }
                else
                {
                    _loc_4 = 0;
                    while (_loc_4 < _loc_7.models.length)
                    {
                        
                        if (_loc_7.models[_loc_4].model && _loc_7.models[_loc_4].bone > -1 && _loc_7.models[_loc_4].bone < this._bones.length)
                        {
                            if (_loc_7.slot == SlotLeftHand || _loc_7.slot == SlotOffHand)
                            {
                                this.tmpMatrix.identity();
                                this.tmpMatrix.prependScale(1, 1, -1);
                                _loc_7.models[_loc_4].model._cullFace = Context3DTriangleFace.BACK;
                            }
                            _loc_7.models[_loc_4].model.setOrientation(this._matrix, this._bones[_loc_7.models[_loc_4].bone]._matrix, _loc_7.models[_loc_4].attachment._position, _loc_7.slot == SlotLeftHand || _loc_7.slot == SlotOffHand ? (this.tmpMatrix) : (null));
                            _loc_7.models[_loc_4].model.update(param1);
                            _loc_7.models[_loc_4].model.render(param1, false);
                        }
                        _loc_4++;
                    }
                }
                _loc_3++;
            }
            if (this._particleEmitters)
            {
                _loc_9 = this._particleEmitters.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_9)
                {
                    
                    this._particleEmitters[_loc_3].update(this._currentAnim, this._time, param1);
                    this._particleEmitters[_loc_3].render();
                    _loc_3++;
                }
            }
            if (this._ribbonEmitters)
            {
                _loc_10 = this._ribbonEmitters.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_10)
                {
                    
                    this._ribbonEmitters[_loc_3].update(this._currentAnim, this._time, param1);
                    this._ribbonEmitters[_loc_3].render();
                    _loc_3++;
                }
            }
            return;
        }// end function

        override protected function _vertexShader() : void
        {
            return;
        }// end function

        override protected function _fragmentShader() : void
        {
            return;
        }// end function

        private function updateBuffers(param1:Boolean = true) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_2:* = 8;
            var _loc_3:* = this._vertices.length * _loc_2;
            if (!this._vbData)
            {
                this._vbData = new Vector.<Number>(_loc_3);
            }
            if (param1)
            {
                _loc_4 = 0;
                _loc_5 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    this._vbData[_loc_4] = this._vertices[_loc_5]._transformedPosition.x;
                    this._vbData[(_loc_4 + 1)] = this._vertices[_loc_5]._transformedPosition.y;
                    this._vbData[_loc_4 + 2] = this._vertices[_loc_5]._transformedPosition.z;
                    this._vbData[_loc_4 + 3] = this._vertices[_loc_5]._transformedNormal.x;
                    this._vbData[_loc_4 + 4] = this._vertices[_loc_5]._transformedNormal.y;
                    this._vbData[_loc_4 + 5] = this._vertices[_loc_5]._transformedNormal.z;
                    this._vbData[_loc_4 + 6] = this._vertices[_loc_5]._texCoord.u;
                    this._vbData[_loc_4 + 7] = this._vertices[_loc_5]._texCoord.v;
                    _loc_4 = _loc_4 + _loc_2;
                    _loc_5++;
                }
            }
            if (!this._vb)
            {
                this._vb = context.createVertexBuffer(this._vertices.length, _loc_2);
            }
            this._vb.uploadFromVector(this._vbData, 0, this._vertices.length);
            this._ready = true;
            return;
        }// end function

        public function updateMeshes() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            if (!this._ready || !this._texUnits || this._texUnits.length == 0)
            {
                return;
            }
            var _loc_3:* = true;
            if (this._currentHairMesh)
            {
                _loc_3 = this._currentHairMesh._show;
            }
            _loc_1 = 0;
            while (_loc_1 < this._texUnits.length)
            {
                
                this._texUnits[_loc_1]._show = this._texUnits[_loc_1]._mesh.id == 0;
                _loc_1++;
            }
            _loc_1 = 0;
            while (_loc_1 < 20)
            {
                
                this._geosets[_loc_1] = 1;
                _loc_1++;
            }
            this._geosets[7] = 2;
            if (this._faceVis)
            {
                if (this._faceFeature && this._currentFaceFeature < this._faceFeature.length)
                {
                    _loc_4 = this._faceFeature[this._currentFaceFeature];
                    this._geosets[1] = _loc_4.geoset1;
                    this._geosets[2] = _loc_4.geoset2;
                    this._geosets[3] = _loc_4.geoset3;
                }
            }
            else
            {
                var _loc_13:* = 1;
                this._geosets[3] = 1;
                this._geosets[2] = _loc_13;
                this._geosets[1] = _loc_13;
            }
            if (this._race == 9)
            {
                if (this._geosets[1] == 1)
                {
                    var _loc_13:* = this._geosets;
                    var _loc_14:* = 1;
                    var _loc_15:* = _loc_13[1] + 1;
                    _loc_13[_loc_14] = _loc_15;
                }
                if (_loc_13[2] == 1)
                {
                    var _loc_13:* = this._geosets;
                    var _loc_14:* = 2;
                    var _loc_15:* = _loc_13[2] + 1;
                    _loc_13[_loc_14] = _loc_15;
                }
                if (_loc_13[3] == 1)
                {
                    var _loc_13:* = this._geosets;
                    var _loc_14:* = 3;
                    var _loc_15:* = _loc_13[3] + 1;
                    _loc_13[_loc_14] = _loc_15;
                }
            }
            var _loc_6:* = this._equipment.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_6)
            {
                
                _loc_5 = this._equipment[_loc_1];
                if (!_loc_5.geosets)
                {
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.geosets.length)
                    {
                        
                        _loc_13[_loc_5.geosets[_loc_2].index] = _loc_5.geosets[_loc_2].value;
                        _loc_2++;
                    }
                    if (_loc_13[13] == 1)
                    {
                        _loc_13[13] = 1 + _loc_5.geoC;
                    }
                    if (_loc_5.slot == 6)
                    {
                        _loc_13[18] = 1 + _loc_5.geoA;
                    }
                    if (this._race == 24 && _loc_5.slot == SlotPants)
                    {
                        _loc_13[14] = 0;
                    }
                }
                _loc_1++;
            }
            if (_loc_13[13] == 2)
            {
                var _loc_13:* = 0;
                this._geosets[12] = 0;
                this._geosets[5] = _loc_13;
            }
            if (this._geosets[4] > 1)
            {
                this._geosets[8] = 0;
            }
            if (this._hair && this._currentHair < this._hair.length)
            {
                _loc_10 = this._hair[this._currentHair];
                _loc_1 = 0;
                while (_loc_1 < this._texUnits.length)
                {
                    
                    _loc_7 = this._texUnits[_loc_1];
                    if (_loc_7._mesh.id != 0 && _loc_7._mesh.id == _loc_10.geoset)
                    {
                        _loc_7._show = true;
                        this._currentHairMesh = _loc_7;
                    }
                    _loc_1++;
                }
            }
            _loc_1 = 0;
            while (_loc_1 < this._texUnits.length)
            {
                
                _loc_7 = this._texUnits[_loc_1];
                if (this._race != 1 && _loc_7._mesh.id == 0 && _loc_7._mesh.indexCount < 36)
                {
                    _loc_7._show = false;
                }
                else
                {
                    if (_loc_7._mesh.id == 1 && (!this._hairVis || this._gender == 0 && this._currentHair == 0 && (this._race == 1 || this._race == 7 || this._race == 8 || this._race == 18)))
                    {
                        _loc_7._show = true;
                    }
                    _loc_2 = 1;
                    while (_loc_2 < 20)
                    {
                        
                        _loc_11 = _loc_2 * 100;
                        _loc_12 = (_loc_2 + 1) * 100;
                        if (_loc_7._mesh.id > _loc_11 && _loc_7._mesh.id < _loc_12)
                        {
                            _loc_7._show = _loc_7._mesh.id == _loc_11 + this._geosets[_loc_2];
                        }
                        _loc_2++;
                    }
                    if (this._race == 9)
                    {
                        if (this._gender == 1 && _loc_7.mesh == 0 || this._gender == 0 && _loc_7.mesh == 3)
                        {
                            _loc_7._show = false;
                        }
                    }
                    else if (this._race == 22)
                    {
                        if (this._gender == 0)
                        {
                            if (_loc_7.mesh == 2 || _loc_7.mesh == 3 || _loc_7.mesh >= 36 && _loc_7.mesh <= 47)
                            {
                                _loc_7._show = false;
                            }
                        }
                        else if (_loc_7.mesh == 2 || _loc_7.mesh == 3 || _loc_7.mesh >= 58 && _loc_7.mesh <= 69)
                        {
                            _loc_7._show = false;
                        }
                    }
                }
                _loc_1++;
            }
            var _loc_9:* = this._attachments.length;
            _loc_1 = 0;
            while (_loc_1 < _loc_6)
            {
                
                _loc_5 = this._equipment[_loc_1];
                if (!_loc_5.loaded || !_loc_5.models)
                {
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.models.length)
                    {
                        
                        if (this._slotAttachments[_loc_5.slot] && this._slotAttachments[_loc_5.slot].length > _loc_2)
                        {
                            _loc_8 = this._attachments[this._slotAttachments[_loc_5.slot][_loc_2]];
                            _loc_5.models[_loc_2].bone = _loc_8._bone;
                            _loc_5.models[_loc_2].attachment = _loc_8;
                        }
                        _loc_2++;
                    }
                }
                _loc_1++;
            }
            if (this._currentHairMesh)
            {
                this._currentHairMesh._show = _loc_3 && this._hairVis;
            }
            if (this.DebugChecks)
            {
                this.setupDebug();
            }
            return;
        }// end function

        public function setupDebug() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            if (!params._parentModel)
            {
                _loc_1 = 0;
                while (_loc_1 < this._texUnits.length)
                {
                    
                    if (!this._checks[_loc_1])
                    {
                        _loc_2 = new TextField();
                        _loc_2.x = 5 + Math.floor(_loc_1 / 30) * 90;
                        _loc_2.y = _loc_1 % 30 * 20 + 30;
                        _loc_2.height = 16;
                        _loc_2.width = 200;
                        _loc_2.text = "" + _loc_1 + " mesh " + this._texUnits[_loc_1]._mesh.id + " " + this._texUnits[_loc_1].mesh;
                        if (this._texUnits[_loc_1]._show)
                        {
                            _loc_2.textColor = 65280;
                        }
                        else
                        {
                            _loc_2.textColor = 16711680;
                        }
                        _loc_2.addEventListener(MouseEvent.CLICK, this.onCheck, false, 0, true);
                        this._checks[_loc_1] = _loc_2;
                        viewer.stage.addChild(this._checks[_loc_1]);
                        var _loc_4:* = _numChecks + 1;
                        _numChecks = _loc_4;
                    }
                    _loc_1++;
                }
            }
            return;
        }// end function

        public function onClickAnim(event:MouseEvent) : void
        {
            this.setAnimation(event.target.text);
            return;
        }// end function

        public function onCheck(event:MouseEvent) : void
        {
            var _loc_2:* = parseInt(event.target.text);
            var _loc_3:* = event.target.textColor == 65280;
            if (this._texUnits[_loc_2]._show && _loc_3)
            {
                this._texUnits[_loc_2]._show = false;
                event.target.textColor = 16711680;
            }
            else if (!this._texUnits[_loc_2]._show && !_loc_3)
            {
                this._texUnits[_loc_2]._show = true;
                event.target.textColor = 65280;
            }
            return;
        }// end function

        private function setup() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            if (this._modelType != TypeCharacter && this._modelType != TypeHumanoidNpc || this._race < 1)
            {
                if (this._texUnits)
                {
                    _loc_7 = 0;
                    while (_loc_7 < this._texUnits.length)
                    {
                        
                        this._texUnits[_loc_7]._show = true;
                        _loc_7++;
                    }
                }
                if (this.DebugChecks)
                {
                    this.setupDebug();
                }
                return;
            }
            if ((this._race == 14 || this._race == 17) && this._currentHair == 0)
            {
                this._currentHair = 1;
            }
            if (this._skin)
            {
                if (this._currentSkin >= this._skin.length)
                {
                    this._currentSkin = 0;
                }
                if (this._currentSkin < this._skin.length)
                {
                    _loc_1 = this._skin[this._currentSkin];
                    if (this._currentFace >= _loc_1.faces.length)
                    {
                        this._currentFace = 0;
                    }
                    if (this._currentFace < _loc_1.faces.length)
                    {
                        _loc_2 = _loc_1.faces[this._currentFace];
                    }
                }
            }
            if (this._faceFeature)
            {
                if (this._currentFaceFeature >= this._faceFeature.length)
                {
                    this._currentFaceFeature = 0;
                }
                if (this._currentFaceFeature < this._faceFeature.length)
                {
                    _loc_3 = this._faceFeature[this._currentFaceFeature];
                    if (this._currentFaceTexture >= _loc_3.textures.length)
                    {
                        this._currentFaceTexture = 0;
                    }
                    if (this._currentFaceTexture < _loc_3.textures.length)
                    {
                        _loc_4 = _loc_3.textures[this._currentFaceTexture];
                    }
                }
            }
            if (this._hair)
            {
                if (this._currentHair >= this._hair.length)
                {
                    this._currentHair = 0;
                }
                if (this._currentHair < this._hair.length)
                {
                    _loc_5 = this._hair[this._currentHair];
                    if (this._currentHairTexture >= _loc_5.textures.length)
                    {
                        this._currentHairTexture = 0;
                    }
                    if (this._currentHairTexture < _loc_5.textures.length)
                    {
                        _loc_6 = _loc_5.textures[this._currentHairTexture];
                    }
                }
            }
            if (!this._npcTexture)
            {
                if (_loc_1)
                {
                    if (_loc_1.baseTexture.length > 0 && !this._specialTextures[1])
                    {
                        this._specialTextures[1] = new WowTexture(this, 1, _loc_1.baseTexture, WowTexture.SPECIAL);
                    }
                    if (_loc_1.pantiesTexture.length > 0 && !this._bakedTextures[RegionPelvisUpper][1])
                    {
                        this._bakedTextures[RegionPelvisUpper][1] = new WowTexture(this, RegionPelvisUpper, _loc_1.pantiesTexture, WowTexture.BAKED);
                    }
                    if (_loc_1.braTexture.length > 0 && !this._bakedTextures[RegionTorsoUpper][1])
                    {
                        this._bakedTextures[RegionTorsoUpper][1] = new WowTexture(this, RegionTorsoUpper, _loc_1.braTexture, WowTexture.BAKED);
                    }
                }
                if (_loc_2)
                {
                    if (_loc_2.lowerTexture.length > 0 && !this._bakedTextures[RegionFaceLower][1])
                    {
                        this._bakedTextures[RegionFaceLower][1] = new WowTexture(this, RegionFaceLower, _loc_2.lowerTexture, WowTexture.BAKED);
                    }
                    if (_loc_2.upperTexture.length > 0 && !this._bakedTextures[RegionFaceUpper][1])
                    {
                        this._bakedTextures[RegionFaceUpper][1] = new WowTexture(this, RegionFaceUpper, _loc_2.upperTexture, WowTexture.BAKED);
                    }
                }
                if (_loc_4)
                {
                    if (_loc_4.lowerTexture.length > 0 && !this._bakedTextures[RegionFaceLower][2])
                    {
                        this._bakedTextures[RegionFaceLower][2] = new WowTexture(this, RegionFaceLower, _loc_4.lowerTexture, WowTexture.BAKED);
                    }
                    if (_loc_4.upperTexture.length > 0 && !this._bakedTextures[RegionFaceUpper][2])
                    {
                        this._bakedTextures[RegionFaceUpper][2] = new WowTexture(this, RegionFaceUpper, _loc_4.upperTexture, WowTexture.BAKED);
                    }
                }
                if (_loc_6)
                {
                    if (_loc_6.lowerTexture.length > 0 && !this._bakedTextures[RegionFaceLower][3])
                    {
                        this._bakedTextures[RegionFaceLower][3] = new WowTexture(this, RegionFaceLower, _loc_6.lowerTexture, WowTexture.BAKED);
                    }
                    if (_loc_6.upperTexture.length > 0 && !this._bakedTextures[RegionFaceUpper][3])
                    {
                        this._bakedTextures[RegionFaceUpper][3] = new WowTexture(this, RegionFaceUpper, _loc_6.upperTexture, WowTexture.BAKED);
                    }
                }
            }
            if (_loc_1 && _loc_1.furTexture.length > 0 && !this._specialTextures[8])
            {
                this._specialTextures[8] = new WowTexture(this, 8, _loc_1.furTexture, WowTexture.SPECIAL);
            }
            if (_loc_6 && _loc_6.texture.length > 0 && !this._specialTextures[6])
            {
                this._specialTextures[6] = new WowTexture(this, 6, _loc_6.texture, WowTexture.SPECIAL);
            }
            this.updateMeshes();
            return;
        }// end function

        private function calcBounds() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            var _loc_17:* = NaN;
            var _loc_18:* = NaN;
            var _loc_19:* = NaN;
            var _loc_20:* = NaN;
            var _loc_21:* = NaN;
            var _loc_22:* = NaN;
            this._boundsMin = new Vector3D(Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE);
            this._boundsMax = new Vector3D(Number.MIN_VALUE, Number.MIN_VALUE, Number.MIN_VALUE);
            this._boundsCenter = new Vector3D();
            this._boundsSize = new Vector3D();
            var _loc_2:* = this._texUnits.length;
            var _loc_5:* = new Color();
            var _loc_6:* = 0;
            while (_loc_6 < _loc_2)
            {
                
                _loc_4 = this._texUnits[_loc_6];
                if (!_loc_4._show)
                {
                }
                else
                {
                    _loc_5.reset();
                    if (_loc_4._color)
                    {
                        _loc_4._color.getValue(this._currentAnim, this._time, _loc_5);
                    }
                    if (_loc_4._alpha)
                    {
                        _loc_5.a = _loc_5.a * _loc_4._alpha.getValue(this._currentAnim, 0);
                    }
                    if (_loc_5.a < 0.01)
                    {
                    }
                    else
                    {
                        _loc_3 = _loc_4._mesh;
                        _loc_10 = _loc_3.indexStart;
                        _loc_11 = 0;
                        while (_loc_11 < _loc_3.indexCount)
                        {
                            
                            _loc_1 = this._vertices[this._indices[_loc_11 + _loc_10]]._position;
                            this._boundsMin.x = Math.min(this._boundsMin.x, _loc_1.x);
                            this._boundsMin.y = Math.min(this._boundsMin.y, _loc_1.y);
                            this._boundsMin.z = Math.min(this._boundsMin.z, _loc_1.z);
                            this._boundsMax.x = Math.max(this._boundsMax.x, _loc_1.x);
                            this._boundsMax.y = Math.max(this._boundsMax.y, _loc_1.y);
                            this._boundsMax.z = Math.max(this._boundsMax.z, _loc_1.z);
                            _loc_11++;
                        }
                    }
                }
                _loc_6++;
            }
            this._boundsSize.setTo(this._boundsMax.x - this._boundsMin.x, this._boundsMax.y - this._boundsMin.y, this._boundsMax.z - this._boundsMin.z);
            _loc_7 = this._boundsSize.y;
            if (this._modelType != TypeItem)
            {
                _loc_8 = this._boundsSize.z;
            }
            else
            {
                _loc_8 = this._boundsSize.x;
            }
            _loc_9 = Math.max(_loc_7, _loc_8);
            this._boundsCenter.setTo(this._boundsMin.x + this._boundsSize.x * 0.5, this._boundsMin.y + this._boundsSize.y * 0.5, this._boundsMin.z + this._boundsSize.z * 0.5);
            if (!params._parentModel)
            {
                _loc_12 = viewer.stage.stageWidth / viewer.stage.stageHeight;
                _loc_13 = 2 * Math.tan(45 / 2);
                _loc_14 = _loc_13 * 0.01;
                _loc_15 = _loc_14 * _loc_12;
                _loc_16 = _loc_13 * 500;
                _loc_17 = _loc_16 * _loc_12;
                _loc_18 = (_loc_16 - _loc_14) / 500;
                _loc_19 = (_loc_17 - _loc_15) / 500;
                _loc_20 = (_loc_7 * 1.5 - _loc_14 + _loc_8 / 2) / _loc_18;
                _loc_21 = (Math.max(this._boundsSize.x, this._boundsSize.z) * 1.5 + _loc_7 / 2 - _loc_15) / _loc_19;
                _loc_22 = Math.max(_loc_20, _loc_21);
                camera.setDistance(_loc_22);
            }
            this._matrix.identity();
            this._matrix.appendTranslation(-this._boundsCenter.x, -this._boundsCenter.y, -this._boundsCenter.z);
            if (this._modelType != TypeItem)
            {
                this._matrix.appendRotation(-90, Vector3D.Y_AXIS);
            }
            return;
        }// end function

        private function setOrientation(param1:Matrix3D, param2:Matrix3D, param3:Vector3D, param4:Matrix3D) : void
        {
            this._matrix.copyFrom(param1);
            this._matrix.prepend(param2);
            if (param3)
            {
                this._matrix.prependTranslation(param3.x, param3.y, param3.z);
            }
            if (param4)
            {
                this._matrix.prepend(param4);
            }
            return;
        }// end function

        private function loadEquipList(param1:String) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_2:* = param1.split(",");
            if (_loc_2.length % 2 != 0)
            {
                viewer.statusText = "Bad equipment list passed :(";
                return;
            }
            while (_loc_2.length > 0)
            {
                
                _loc_3 = parseInt(_loc_2.shift());
                _loc_4 = parseInt(_loc_2.shift());
                this.attachEquipment(_loc_3, _loc_4);
            }
            return;
        }// end function

        public function parseMeta(event:FileLoadEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            this._meta = JSON.parse(event.target.data);
            if (this._modelType == TypeCharacter)
            {
                this.load(TypePath, this._meta.Model, this._meta.Race, this._meta.Gender);
                if (params.equipList)
                {
                    this.loadEquipList(params.equipList);
                }
                if (params.sk)
                {
                    this._currentSkin = parseInt(params.sk);
                }
                if (params.ha)
                {
                    this._currentHair = parseInt(params.ha);
                }
                if (params.hc)
                {
                    this._currentHairTexture = parseInt(params.hc);
                }
                if (params.fa)
                {
                    this._currentFace = parseInt(params.fa);
                }
                if (params.fh)
                {
                    this._currentFaceFeature = parseInt(params.fh);
                }
                if (params.fc)
                {
                    this._currentFaceTexture = parseInt(params.fc);
                }
            }
            else if (this._modelType == TypeHelm)
            {
                _loc_3 = 1;
                _loc_4 = 0;
                if (params._parentModel)
                {
                    _loc_3 = params._parentModel._race;
                    _loc_4 = params._parentModel._gender;
                    params._parentModel._hairVis = this._meta.ShowHair == 0;
                    params._parentModel._faceVis = this._meta.ShowFacial1 == 0;
                }
                if (this._meta.RaceModels[_loc_4][_loc_3])
                {
                    this.load(TypePath, this._meta.RaceModels[_loc_4][_loc_3]);
                }
                if (this._meta.Textures)
                {
                    for (_loc_2 in this._meta.Textures)
                    {
                        
                        this._textures[_loc_2] = new WowTexture(this, parseInt(_loc_2), _loc_10[_loc_2]);
                    }
                }
            }
            else if (this._modelType == TypeShoulder)
            {
                if (this._shoulderIndex == 1 || this._shoulderIndex == -1 && this._meta.Model)
                {
                    if (this._meta.Model)
                    {
                        this.load(TypePath, this._meta.Model, this._shoulderIndex);
                    }
                    if (this._meta.Textures)
                    {
                        for (_loc_2 in this._meta.Textures)
                        {
                            
                            this._textures[_loc_2] = new WowTexture(this, parseInt(_loc_2), _loc_10[_loc_2]);
                        }
                    }
                }
                else if (this._shoulderIndex == 2 || this._shoulderIndex == -1 && this._meta.Model2)
                {
                    if (this._meta.Model2)
                    {
                        this.load(TypePath, this._meta.Model2, this._shoulderIndex);
                    }
                    if (this._meta.Textures2)
                    {
                        for (_loc_2 in this._meta.Textures2)
                        {
                            
                            this._textures[_loc_2] = new WowTexture(this, parseInt(_loc_2), _loc_10[_loc_2]);
                        }
                    }
                }
            }
            else
            {
                if (this._meta.Textures)
                {
                    for (_loc_2 in this._meta.Textures)
                    {
                        
                        this._textures[_loc_2] = new WowTexture(this, parseInt(_loc_2), _loc_10[_loc_2]);
                    }
                }
                else if (this._meta.GenderTextures && params._parentModel)
                {
                    _loc_5 = params._parentModel._gender;
                    for (_loc_2 in this._meta.GenderTextures[_loc_5])
                    {
                        
                        this._textures[_loc_2] = new WowTexture(this, parseInt(_loc_2), _loc_10[_loc_2]);
                    }
                }
                if (this._meta.Model)
                {
                    this.load(TypePath, this._meta.Model);
                }
                else if (this._meta.GenderModels && params._parentModel)
                {
                    this.load(TypePath, this._meta.GenderModels[params._parentModel._gender]);
                }
                else if (this._meta.Race > 0)
                {
                    _loc_6 = Races[this._meta.Race] + Genders[this._meta.Gender];
                    this.load(TypeCharacter, _loc_6, this._meta.Race, this._meta.Gender);
                    if (this._meta.Texture)
                    {
                        this._npcTexture = new WowTexture(this, -1, this._meta.Texture);
                    }
                    this._currentSkin = this._meta.SkinColor;
                    this._currentHair = this._meta.HairStyle;
                    this._currentHairTexture = this._meta.HairColor;
                    this._currentFaceFeature = this._meta.FacialHair;
                    this._currentFace = this._meta.FaceType;
                    if (this._meta.Equipment)
                    {
                        for (_loc_8 in this._meta.Equipment)
                        {
                            
                            _loc_7 = parseInt(_loc_8);
                            this.attachEquipment(_loc_7, _loc_10[_loc_8]);
                        }
                    }
                }
            }
            return;
        }// end function

        private function onLoaded(event:FileLoadEvent) : void
        {
            switch(this._modelLoadType)
            {
                case TypeItem:
                case TypeHelm:
                case TypeShoulder:
                case TypeNpc:
                case TypeHumanoidNpc:
                case TypeObject:
                case TypeCharacter:
                {
                    this.parseMeta(event);
                    break;
                }
                case TypePath:
                {
                    this.parseMo3(event);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function attachEquipment(param1:int, param2:int) : void
        {
            var _loc_3:* = new WowEquipment(this, param1, param2.toString(), this._race, this._gender);
            var _loc_4:* = UniqueSlots[param1];
            var _loc_5:* = AlternateSlot[param1];
            var _loc_6:* = this._equipment.length;
            var _loc_7:* = -1;
            var _loc_8:* = -1;
            var _loc_9:* = 0;
            while (_loc_9 < _loc_6)
            {
                
                if (this._equipment[_loc_9].uniqueSlot == _loc_4)
                {
                    _loc_7 = _loc_9;
                }
                else if (this._equipment[_loc_9].uniqueSlot == _loc_5)
                {
                    _loc_8 = _loc_9;
                }
                _loc_9++;
            }
            if (_loc_7 != -1 && _loc_8 != -1)
            {
                this._equipment[_loc_7] = _loc_3;
            }
            else
            {
                if (_loc_7 != -1 && _loc_8 == -1)
                {
                    _loc_3.slot = _loc_5;
                }
                this._equipment.push(_loc_3);
            }
            return;
        }// end function

        private function removeEquipment(param1:int, param2:Boolean = true) : void
        {
            var _loc_3:* = UniqueSlots[param1];
            var _loc_4:* = this._equipment.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                if (this._equipment[_loc_5].uniqueSlot == _loc_3)
                {
                    this._equipment.splice(_loc_5, 1);
                }
                _loc_5++;
            }
            if (param2)
            {
                this.updateMeshes();
                this.attemptTextureCompositing();
            }
            return;
        }// end function

        public function attemptTextureCompositing() : void
        {
            var i:int;
            var j:int;
            var e:WowEquipment;
            var t:Object;
            var idx:String;
            i;
            while (i < 11)
            {
                
                var _loc_2:* = 0;
                var _loc_3:* = this._bakedTextures[i];
                while (_loc_3 in _loc_2)
                {
                    
                    idx = _loc_3[_loc_2];
                    if (!_loc_3[idx].good)
                    {
                        return;
                    }
                }
                i = (i + 1);
            }
            i;
            while (i < this._equipment.length)
            {
                
                if (!this._equipment[i].loaded)
                {
                    return;
                }
                if (this._equipment[i].textures)
                {
                    j;
                    while (j < this._equipment[i].textures.length)
                    {
                        
                        if (this._equipment[i].textures[j].texture && !this._equipment[i].textures[j].texture.good)
                        {
                            return;
                        }
                        j = (j + 1);
                    }
                }
                i = (i + 1);
            }
            if (!this._specialTextures[1] || !this._specialTextures[1].good)
            {
                return;
            }
            if (!this._bakedTexture)
            {
                this._bakedTexture = new WowTexture(this, -1, null, WowTexture.SPECIAL);
            }
            this._bakedTexture.copyFromTexture(this._specialTextures[1]);
            if (this._bakedTextures[RegionFaceLower][1] && this._bakedTextures[RegionFaceLower][1].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionFaceLower][1], RegionFaceLower);
            }
            if (this._bakedTextures[RegionFaceUpper][1] && this._bakedTextures[RegionFaceUpper][1].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionFaceUpper][1], RegionFaceUpper);
            }
            if (this._bakedTextures[RegionFaceLower][2] && this._bakedTextures[RegionFaceLower][2].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionFaceLower][2], RegionFaceLower);
            }
            if (this._bakedTextures[RegionFaceUpper][2] && this._bakedTextures[RegionFaceUpper][2].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionFaceUpper][2], RegionFaceUpper);
            }
            if (this._bakedTextures[RegionFaceLower][3] && this._bakedTextures[RegionFaceLower][3].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionFaceLower][3], RegionFaceLower);
            }
            if (this._bakedTextures[RegionFaceUpper][3] && this._bakedTextures[RegionFaceUpper][3].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionFaceUpper][3], RegionFaceUpper);
            }
            var drawBra:Boolean;
            var drawPanties:Boolean;
            i;
            while (i < this._equipment.length)
            {
                
                e = this._equipment[i];
                if (e.uniqueSlot == 4 || e.uniqueSlot == 5 || e.uniqueSlot == 19)
                {
                    drawBra;
                }
                else if (e.slot == 20 || e.uniqueSlot == 7)
                {
                    drawPanties;
                }
                i = (i + 1);
            }
            if (drawBra && this._bakedTextures[RegionTorsoUpper][1] && this._bakedTextures[RegionTorsoUpper][1].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionTorsoUpper][1], RegionTorsoUpper);
            }
            if (drawPanties && this._bakedTextures[RegionPelvisUpper][1] && this._bakedTextures[RegionPelvisUpper][1].good)
            {
                this._bakedTexture.drawTexture(this._bakedTextures[RegionPelvisUpper][1], RegionPelvisUpper);
            }
            this._equipment.sort(function (param1:WowEquipment, param2:WowEquipment) : Number
            {
                if (param1.sortValue < param2.sortValue)
                {
                    return -1;
                }
                if (param1.sortValue > param2.sortValue)
                {
                    return 1;
                }
                return 0;
            }// end function
            );
            i;
            while (i < this._equipment.length)
            {
                
                e = this._equipment[i];
                if (!e.textures)
                {
                }
                else
                {
                    j;
                    while (j < e.textures.length)
                    {
                        
                        t = e.textures[j];
                        if (t.gender != this._gender || !t.texture)
                        {
                        }
                        else if (t.region > 0)
                        {
                            if ((this._race == 6 || this._race == 8 || this._race == 11 || this._race == 14) && t.region == RegionFoot)
                            {
                            }
                            else
                            {
                                this._bakedTexture.drawTexture(t.texture, t.region);
                            }
                        }
                        j = (j + 1);
                    }
                }
                i = (i + 1);
            }
            this._bakedTexture.uploadTexture();
            this._textures[1] = this._bakedTexture;
            return;
        }// end function

        override public function registerExternalInterface() : void
        {
            ExternalInterface.addCallback("getNumAnimations", this.extGetNumAnimations);
            ExternalInterface.addCallback("getAnimation", this.extGetAnimation);
            ExternalInterface.addCallback("setAnimation", this.extSetAnimation);
            ExternalInterface.addCallback("resetAnimation", this.extResetAnimation);
            ExternalInterface.addCallback("attachList", this.extAttachList);
            ExternalInterface.addCallback("clearSlots", this.extClearSlots);
            ExternalInterface.addCallback("setAppearance", this.extSetAppearance);
            ExternalInterface.addCallback("setFreeze", this.extSetFreeze);
            ExternalInterface.addCallback("setSpinSpeed", this.extSetSpinSpeed);
            ExternalInterface.addCallback("isLoaded", this.extIsLoaded);
            return;
        }// end function

        public function extGetNumAnimations() : int
        {
            return this._animations.length;
        }// end function

        public function extGetAnimation(param1:int) : String
        {
            if (param1 > -1 && param1 < this._animations.length)
            {
                return this._animations[param1].name;
            }
            return "";
        }// end function

        public function extSetAnimation(param1:String) : void
        {
            this.setAnimation(param1);
            return;
        }// end function

        public function extResetAnimation() : void
        {
            this.setAnimation("Stand");
            return;
        }// end function

        public function extAttachList(param1:String) : void
        {
            this.loadEquipList(param1);
            return;
        }// end function

        public function extClearSlots(param1:String) : void
        {
            var _loc_2:* = param1.split(",");
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                this.removeEquipment(_loc_2[_loc_3], false);
                _loc_3++;
            }
            this.updateMeshes();
            this.attemptTextureCompositing();
            return;
        }// end function

        public function extSetAppearance(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int) : void
        {
            this._currentHair = param1;
            this._currentHairTexture = param2;
            this._currentFace = param3;
            this._currentSkin = param4;
            this._currentFaceFeature = param5;
            this._currentFaceTexture = param2;
            this.setup();
            return;
        }// end function

        public function extSetFreeze(param1:int) : void
        {
            if (param1 == 0)
            {
                this._freeze = false;
            }
            else
            {
                this._freeze = true;
            }
            return;
        }// end function

        public function extSetSpinSpeed(param1:int) : void
        {
            this._spinSpeed = param1;
            return;
        }// end function

        public function extIsLoaded() : Boolean
        {
            return this._ready;
        }// end function

        public function onTextureLoaded(param1:WowTexture, param2:int, param3:int) : void
        {
            if (param2 == WowTexture.NORMAL && param3 > -1 && !this._textures[param3])
            {
                this._textures[param3] = param1;
            }
            else if ((this._modelType == TypeCharacter || this._modelType == TypeHumanoidNpc) && (param2 == WowTexture.BAKED || param2 == WowTexture.ARMOR || param2 == WowTexture.SPECIAL && param3 == 1))
            {
                this.attemptTextureCompositing();
            }
            else if (param2 == WowTexture.SPECIAL && param3 > -1)
            {
                this._textures[param3] = param1;
            }
            return;
        }// end function

        private function onLoadStart(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_START, event.url);
            _viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onLoadProgress(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, event.url, event.currentBytes, event.totalBytes);
            _viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onLoadError(event:FileLoadEvent) : void
        {
            var _loc_2:* = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, event.url, -1, -1, event.errorMessage);
            _viewer.dispatchEvent(_loc_2);
            return;
        }// end function

        private function parseMo3(event:FileLoadEvent) : void
        {
            var i:int;
            var magic:uint;
            var version:uint;
            var ofsVertices:uint;
            var ofsIndices:uint;
            var ofsSequences:uint;
            var ofsAnimations:uint;
            var ofsAnimLookup:uint;
            var ofsBones:uint;
            var ofsBoneLookup:uint;
            var ofsKeyBoneLookup:uint;
            var ofsMeshes:uint;
            var ofsTexUnits:uint;
            var ofsTexUnitLookup:uint;
            var ofsRenderFlags:uint;
            var ofsTextures:uint;
            var ofsTextureLookup:uint;
            var ofsTextureAnims:uint;
            var ofsTexAnimLookup:uint;
            var ofsTexReplacements:uint;
            var ofsAttachments:uint;
            var ofsAttachmentLookup:uint;
            var ofsColors:uint;
            var ofsAlphas:uint;
            var ofsAlphaLookup:uint;
            var ofsParticleEmitters:uint;
            var ofsRibbonEmitters:uint;
            var ofsSkinColors:uint;
            var ofsFaceTypes:uint;
            var ofsFacialStyles:uint;
            var ofsFacialColors:uint;
            var ofsHairStyles:uint;
            var ofsHairColors:uint;
            var uncompressedSize:uint;
            var newData:ByteArray;
            var numVertices:int;
            var numIndices:int;
            var numSequences:int;
            var numAnimations:int;
            var numAnimLookup:int;
            var numBones:int;
            var numBoneLookup:int;
            var numKeyBoneLookup:int;
            var numMeshes:int;
            var numTexUnits:int;
            var numTexUnitLookup:int;
            var numRenderFlags:int;
            var numTextures:int;
            var numTexLookup:int;
            var numTexAnims:int;
            var numTexAnimLookup:int;
            var numTexReplacements:int;
            var numAttachments:int;
            var numAttachmentLookup:int;
            var numColors:int;
            var numAlphas:int;
            var numAlphaLookup:int;
            var numParticles:int;
            var numRibbons:int;
            var numSkinColors:int;
            var numFaceStyles:int;
            var numHairStyles:int;
            var numUnits:int;
            var slotMap:Object;
            var slot:String;
            var e:* = event;
            var data:* = e.target.data;
            data.endian = Endian.LITTLE_ENDIAN;
            try
            {
                magic = data.readUnsignedInt();
                if (magic != 604210112)
                {
                    return;
                }
                version = data.readUnsignedInt();
                if (version < 2000)
                {
                    return;
                }
                ofsVertices = data.readUnsignedInt();
                ofsIndices = data.readUnsignedInt();
                ofsSequences = data.readUnsignedInt();
                ofsAnimations = data.readUnsignedInt();
                ofsAnimLookup = data.readUnsignedInt();
                ofsBones = data.readUnsignedInt();
                ofsBoneLookup = data.readUnsignedInt();
                ofsKeyBoneLookup = data.readUnsignedInt();
                ofsMeshes = data.readUnsignedInt();
                ofsTexUnits = data.readUnsignedInt();
                ofsTexUnitLookup = data.readUnsignedInt();
                ofsRenderFlags = data.readUnsignedInt();
                ofsTextures = data.readUnsignedInt();
                ofsTextureLookup = data.readUnsignedInt();
                ofsTextureAnims = data.readUnsignedInt();
                ofsTexAnimLookup = data.readUnsignedInt();
                ofsTexReplacements = data.readUnsignedInt();
                ofsAttachments = data.readUnsignedInt();
                ofsAttachmentLookup = data.readUnsignedInt();
                ofsColors = data.readUnsignedInt();
                ofsAlphas = data.readUnsignedInt();
                ofsAlphaLookup = data.readUnsignedInt();
                ofsParticleEmitters = data.readUnsignedInt();
                ofsRibbonEmitters = data.readUnsignedInt();
                ofsSkinColors = data.readUnsignedInt();
                ofsFaceTypes = data.readUnsignedInt();
                ofsFacialStyles = data.readUnsignedInt();
                ofsFacialColors = data.readUnsignedInt();
                ofsHairStyles = data.readUnsignedInt();
                ofsHairColors = data.readUnsignedInt();
                uncompressedSize = data.readUnsignedInt();
                newData = new ByteArray();
                newData.endian = Endian.LITTLE_ENDIAN;
                data.readBytes(newData);
                newData.uncompress();
                data = newData;
                if (data.length != uncompressedSize)
                {
                }
                data.position = ofsVertices;
                numVertices = data.readInt();
                if (numVertices > 0)
                {
                    this._vertices = new Vector.<WowVertex>(numVertices);
                    i;
                    while (i < numVertices)
                    {
                        
                        this._vertices[i] = new WowVertex();
                        this._vertices[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsIndices;
                numIndices = data.readInt();
                if (numIndices > 0)
                {
                    this._indices = new Vector.<uint>(numIndices);
                    i;
                    while (i < numIndices)
                    {
                        
                        this._indices[i] = data.readUnsignedShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsSequences;
                numSequences = data.readInt();
                if (numSequences > 0)
                {
                    this._sequences = new Vector.<int>(numSequences);
                    i;
                    while (i < numSequences)
                    {
                        
                        this._sequences[i] = data.readInt();
                        i = (i + 1);
                    }
                }
                data.position = ofsAnimations;
                numAnimations = data.readInt();
                if (numAnimations > 0)
                {
                    this._animations = new Vector.<WowAnimation>(numAnimations);
                    i;
                    while (i < numAnimations)
                    {
                        
                        this._animations[i] = new WowAnimation();
                        this._animations[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsAnimLookup;
                numAnimLookup = data.readInt();
                if (numAnimLookup > 0)
                {
                    this._animLookup = new Vector.<int>(numAnimLookup);
                    i;
                    while (i < numAnimLookup)
                    {
                        
                        this._animLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsBones;
                numBones = data.readInt();
                if (numBones > 0)
                {
                    this._bones = new Vector.<WowBone>(numBones);
                    i;
                    while (i < numBones)
                    {
                        
                        this._bones[i] = new WowBone(this, i);
                        this._bones[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsBoneLookup;
                numBoneLookup = data.readInt();
                if (numBoneLookup > 0)
                {
                    this._boneLookup = new Vector.<int>(numBoneLookup);
                    i;
                    while (i < numBoneLookup)
                    {
                        
                        this._boneLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsKeyBoneLookup;
                numKeyBoneLookup = data.readInt();
                if (numKeyBoneLookup > 0)
                {
                    this._keyBoneLookup = new Vector.<int>(numKeyBoneLookup);
                    i;
                    while (i < numKeyBoneLookup)
                    {
                        
                        this._keyBoneLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsMeshes;
                numMeshes = data.readInt();
                if (numMeshes > 0)
                {
                    this._meshes = new Vector.<WowMesh>(numMeshes);
                    i;
                    while (i < numMeshes)
                    {
                        
                        this._meshes[i] = new WowMesh();
                        this._meshes[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsTexUnits;
                numTexUnits = data.readInt();
                if (numTexUnits > 0)
                {
                    this._texUnits = new Vector.<WowTexUnit>(numTexUnits);
                    i;
                    while (i < numTexUnits)
                    {
                        
                        this._texUnits[i] = new WowTexUnit(this);
                        this._texUnits[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsTexUnitLookup;
                numTexUnitLookup = data.readInt();
                if (numTexUnitLookup > 0)
                {
                    this._texUnitLookup = new Vector.<int>(numTexUnitLookup);
                    i;
                    while (i < numTexUnitLookup)
                    {
                        
                        this._texUnitLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsRenderFlags;
                numRenderFlags = data.readInt();
                if (numRenderFlags > 0)
                {
                    this._renderFlags = new Vector.<WowRenderFlag>(numRenderFlags);
                    i;
                    while (i < numRenderFlags)
                    {
                        
                        this._renderFlags[i] = new WowRenderFlag();
                        this._renderFlags[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsTextures;
                numTextures = data.readInt();
                if (numTextures > 0)
                {
                    this._materials = new Vector.<WowMaterial>(numTextures);
                    i;
                    while (i < numTextures)
                    {
                        
                        this._materials[i] = new WowMaterial(this, i);
                        this._materials[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsTextureLookup;
                numTexLookup = data.readInt();
                if (numTexLookup > 0)
                {
                    this._materialLookup = new Vector.<int>(numTexLookup);
                    i;
                    while (i < numTexLookup)
                    {
                        
                        this._materialLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsTextureAnims;
                numTexAnims = data.readInt();
                if (numTexAnims > 0)
                {
                    this._textureAnims = new Vector.<WowTextureAnimation>(numTexAnims);
                    i;
                    while (i < numTexAnims)
                    {
                        
                        this._textureAnims[i] = new WowTextureAnimation();
                        this._textureAnims[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsTexAnimLookup;
                numTexAnimLookup = data.readInt();
                if (numTexAnimLookup > 0)
                {
                    this._textureAnimLookup = new Vector.<int>(numTexAnimLookup);
                    i;
                    while (i < numTexAnimLookup)
                    {
                        
                        this._textureAnimLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsTexReplacements;
                numTexReplacements = data.readInt();
                if (numTexReplacements > 0)
                {
                    this._textureReplacements = new Vector.<int>(numTexReplacements);
                    i;
                    while (i < numTexReplacements)
                    {
                        
                        this._textureReplacements[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsAttachments;
                numAttachments = data.readInt();
                if (numAttachments > 0)
                {
                    this._attachments = new Vector.<WowAttachment>(numAttachments);
                    i;
                    while (i < numAttachments)
                    {
                        
                        this._attachments[i] = new WowAttachment();
                        this._attachments[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsAttachmentLookup;
                numAttachmentLookup = data.readInt();
                if (numAttachmentLookup > 0)
                {
                    this._attachmentLookup = new Vector.<int>(numAttachmentLookup);
                    i;
                    while (i < numAttachmentLookup)
                    {
                        
                        this._attachmentLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsColors;
                numColors = data.readInt();
                if (numColors > 0)
                {
                    this._colors = new Vector.<WowColor>(numColors);
                    i;
                    while (i < numColors)
                    {
                        
                        this._colors[i] = new WowColor();
                        this._colors[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsAlphas;
                numAlphas = data.readInt();
                if (numAlphas > 0)
                {
                    this._alphas = new Vector.<WowTransparency>(numAlphas);
                    i;
                    while (i < numAlphas)
                    {
                        
                        this._alphas[i] = new WowTransparency();
                        this._alphas[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsAlphaLookup;
                numAlphaLookup = data.readInt();
                if (numAlphaLookup > 0)
                {
                    this._alphaLookup = new Vector.<int>(numAlphaLookup);
                    i;
                    while (i < numAlphaLookup)
                    {
                        
                        this._alphaLookup[i] = data.readShort();
                        i = (i + 1);
                    }
                }
                data.position = ofsParticleEmitters;
                numParticles = data.readInt();
                if (numParticles > 0)
                {
                    this._particleEmitters = new Vector.<WowParticleEmitter>(numParticles);
                    i;
                    while (i < numParticles)
                    {
                        
                        this._particleEmitters[i] = new WowParticleEmitter(this);
                        this._particleEmitters[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsRibbonEmitters;
                numRibbons = data.readInt();
                if (numRibbons > 0)
                {
                    this._ribbonEmitters = new Vector.<WowRibbonEmitter>(numRibbons);
                    i;
                    while (i < numRibbons)
                    {
                        
                        this._ribbonEmitters[i] = new WowRibbonEmitter(this);
                        this._ribbonEmitters[i].read(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsSkinColors;
                numSkinColors = data.readInt();
                if (numSkinColors > 0)
                {
                    this._skin = new Vector.<WowSkin>(numSkinColors);
                    i;
                    while (i < numSkinColors)
                    {
                        
                        this._skin[i] = new WowSkin();
                        this._skin[i].read(data);
                        i = (i + 1);
                    }
                    data.position = ofsFaceTypes;
                    i;
                    while (i < numSkinColors)
                    {
                        
                        this._skin[i].readFaces(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsFacialStyles;
                numFaceStyles = data.readInt();
                if (numFaceStyles > 0)
                {
                    this._faceFeature = new Vector.<WowFaceFeature>(numFaceStyles);
                    i;
                    while (i < numFaceStyles)
                    {
                        
                        this._faceFeature[i] = new WowFaceFeature();
                        this._faceFeature[i].read(data);
                        i = (i + 1);
                    }
                    data.position = ofsFacialColors;
                    i;
                    while (i < numFaceStyles)
                    {
                        
                        this._faceFeature[i].readTextures(data);
                        i = (i + 1);
                    }
                }
                data.position = ofsHairStyles;
                numHairStyles = data.readInt();
                if (numHairStyles > 0)
                {
                    this._hair = new Vector.<WowHair>(numHairStyles);
                    i;
                    while (i < numHairStyles)
                    {
                        
                        this._hair[i] = new WowHair();
                        this._hair[i].read(data);
                        i = (i + 1);
                    }
                    data.position = ofsHairColors;
                    i;
                    while (i < numHairStyles)
                    {
                        
                        this._hair[i].readTextures(data);
                        i = (i + 1);
                    }
                }
            }
            catch (ex:Error)
            {
            }
            if (this._texUnits)
            {
                numUnits = this._texUnits.length;
                i;
                while (i < numUnits)
                {
                    
                    this._texUnits[i].setup(this);
                    i = (i + 1);
                }
            }
            if (this._attachmentLookup && this._attachments)
            {
                slotMap;
                var _loc_3:* = 0;
                var _loc_4:* = slotMap;
                while (_loc_4 in _loc_3)
                {
                    
                    slot = _loc_4[_loc_3];
                    i;
                    while (i < _loc_4[slot].length)
                    {
                        
                        if (this._attachmentLookup.length <= _loc_4[slot][i] || this._attachmentLookup[_loc_4[slot][i]] == -1)
                        {
                        }
                        else
                        {
                            if (!this._slotAttachments[slot])
                            {
                                this._slotAttachments[slot] = [];
                            }
                            this._slotAttachments[slot].push(this._attachmentLookup[_loc_4[slot][i]]);
                        }
                        i = (i + 1);
                    }
                }
            }
            this.setAnimation("Stand");
            this.updateBuffers();
            this.calcBounds();
            this.setup();
            return;
        }// end function

    }
}
