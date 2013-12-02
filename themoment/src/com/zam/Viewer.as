package com.zam
{
    import flash.display.*;
    import flash.display3D.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.text.*;
    import flash.utils.*;
	
	import com.zam.lol.LolMesh;

	/**
	 * params:  model=103&modelType=0&viewerType=3&contentPath=//lkstatic.zamimg.com/shared/mv/
	 * 
	 * */
	
    public class Viewer extends Sprite
    {
        private var _context:Context3D;
        private var _viewerType:int;
        private var _contentPath:String;
        private var _modelType:int;
        private var _model:String;
        private var _params:Object;
        private var _thisFrameTime:int;
        private var _lastFrameTime:int;
        private var _delta:Number;
        private var _camera:Camera;
        private var _mesh:Mesh;
        private var _mousePrevX:int = -1;
        private var _mousePrevY:int = -1;
        private var _mouseCurrX:int = 0;
        private var _mouseCurrY:int = 0;
        private var _mouseDown:Boolean = false;
        private var _mouseControlDown:Boolean = false;
        private var _momentumX:Number = 0;
        private var _momentumY:Number = 0;
        private var _turnX:Number = 0;
        private var _turnY:Number = 0;
        private var _statusText:String = "";
        private var _lockStatus:Boolean = false;
        private var _init:Boolean;
        private var _loadingFiles:Object;
		private var _fullscreen:Boolean = false;
		
        public static const VIEWER_TOR:int = 1;
        public static const VIEWER_WOW:int = 2;
        public static const VIEWER_LOL:int = 3;
        public static const VIEWER_GW2:int = 4;
        public static const VIEWER_WILDSTAR:int = 5;

        public function Viewer(params:Object = null)
        {
            this._params = params;
            this._loadingFiles = new Object();
            this._viewerType = parseInt(params.viewerType) || VIEWER_WOW;
            this._contentPath = params.contentPath || "http://static.wowhead.com/modelviewer/";
            this._modelType = parseInt(params.modelType);
            this._model = params.model;
            addEventListener(Event.ADDED_TO_STAGE, this.init);
        }

        public function get context() : Context3D
        {
            return this._context;
        }

        public function get camera() : Camera
        {
            return this._camera;
        }

        public function get contentPath() : String
        {
            return this._contentPath;
        }

        public function get time() : int
        {
            return this._thisFrameTime;
        }

        public function get type() : int
        {
            return this._viewerType;
        }

        public function set statusText(param1:String) : void
        {
            if (this._lockStatus)
            {
                
            }
            this._statusText = param1;
            
        }

        public function init(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            if (stage.stage3Ds.length > 0)
            {
                stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, this.initStage3D);
                stage.stage3Ds[0].requestContext3D();
            }
            else
            {
                this.statusText = "No 3D support available :(";
                this._lockStatus = true;
            }
            this.initStage();
            this.initEvents();
            this.initExternalApi();
            this._lastFrameTime = getTimer();
            
        }

        public function initStage3D(event:Event) : void
        {
            this._context = stage.stage3Ds[0].context3D;
            this._context.configureBackBuffer(stage.stageWidth, stage.stageHeight, this._params.cutout ? (0) : (2), true);
            if (!this._init)
            {
				this._mesh = new LolMesh(this._contentPath, this, this._params);
				this._mesh.load(this._modelType, this._model);
				
                if (ExternalInterface.available)
                {
                    this._mesh.registerExternalInterface();
                }
            }
            else
            {
                this._mesh.refresh();
            }
            this._init = true;
        }

        public function initStage() : void
        {
			this._camera = new Camera(this);
        }

        public function initEvents() : void
        {
            stage.doubleClickEnabled = true;
            stage.addEventListener(MouseEvent.DOUBLE_CLICK, this.onFullscreenClick);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            stage.addEventListener(Event.RESIZE, this.onResize);
            stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.onFullscreen);
            addEventListener(FileLoadEvent.LOAD_START, this.onLoadStart);
            addEventListener(FileLoadEvent.LOAD_COMPLETE, this.onLoadComplete);
            addEventListener(FileLoadEvent.LOAD_PROGRESS, this.onLoadProgress);
            addEventListener(FileLoadEvent.LOAD_ERROR, this.onLoadError);
            addEventListener(FileLoadEvent.LOAD_SECURITY_ERROR, this.onLoadError);
            addEventListener(Event.ENTER_FRAME, this.onRender);
            
        }

        public function initExternalApi() : void
        {
            
        }

        private function onRender(event:Event) : void
        {
            if (!this._context)
            {
                
            }
            this._thisFrameTime = getTimer();
            this._delta = (this._thisFrameTime - this._lastFrameTime) / 1000;
            if (this._params.cutout)
            {
                this._context.clear(1, 0, 1);
            }
            else if (this._viewerType == VIEWER_GW2)
            {
                this._context.clear(0.055, 0.047, 0.039, 1);
            }
            else
            {
                this._context.clear(0.1, 0.1, 0.1, 1);
            }
            var _loc_2:* = this._mouseCurrX - this._mousePrevX;
            var _loc_3:* = this._mouseCurrY - this._mousePrevY;
            this._mousePrevX = this._mouseCurrX;
            this._mousePrevY = this._mouseCurrY;
            if (this._mouseControlDown)
            {
                this._camera.translate(0, _loc_3, _loc_2);
            }
            else if (this._mouseDown)
            {
                this._momentumX = _loc_2;
                this._momentumY = _loc_3;
            }
            else
            {
                this._momentumY = 0;
                if (Math.abs(this._momentumX) > 0.25)
                {
                    this._momentumX = this._momentumX * 0.85;
                }
                else
                {
                    this._momentumX = 0;
                }
            }
            if (this._momentumX != 0 || this._momentumY != 0)
            {
                this._camera.rotate(Math.PI * 2 * (this._momentumX / stage.stageWidth), Math.PI * 2 * (this._momentumY / stage.stageHeight));
            }
            else if (this._turnX != 0 || this._turnY != 0)
            {
                this._camera.rotate(Math.PI * 2 * (this._turnX / stage.stageWidth), Math.PI * 2 * (this._turnY / stage.stageHeight));
            }
            if (this._mesh)
            {
                this._mesh.update(this._delta);
                this._mesh.render(this._delta);
            }
            this._context.present();
            this._lastFrameTime = this._thisFrameTime;
        }

        private function onMouseDown(event:MouseEvent) : void
        {
            if (event.ctrlKey)
            {
                this._mouseControlDown = true;
            }
            else
            {
                this._mouseDown = true;
            }
            
        }

        private function onMouseUp(event:MouseEvent) : void
        {
            var _loc_2:* = false;
            this._mouseControlDown = false;
            this._mouseDown = _loc_2;
            
        }

        private function onMouseMove(event:MouseEvent) : void
        {
            if (this._mousePrevX == -1)
            {
                this._mousePrevX = event.stageX;
                this._mousePrevY = event.stageY;
            }
            this._mouseCurrX = event.stageX;
            this._mouseCurrY = event.stageY;
            
        }

        private function onMouseWheel(event:MouseEvent) : void
        {
            this._camera.translate(event.delta > 0 ? (1) : (-1), 0, 0);
            
        }

        private function onKeyDown(event:KeyboardEvent) : void
        {
            if (event.keyCode == 37)
            {
                this._turnX = -7;
            }
            else if (event.keyCode == 39)
            {
                this._turnX = 7;
            }
            else if (event.keyCode == 40)
            {
                this._turnY = -7;
            }
            else if (event.keyCode == 38)
            {
                this._turnY = 7;
            }
            else if (event.keyCode == 65)
            {
                this._camera.translate(1, 0, 0);
            }
            else if (event.keyCode == 90)
            {
                this._camera.translate(-1, 0, 0);
            }
            
        }

        private function onKeyUp(event:KeyboardEvent) : void
        {
            if (event.keyCode == 37)
            {
                this._turnX = 0;
            }
            else if (event.keyCode == 39)
            {
                this._turnX = 0;
            }
            else if (event.keyCode == 40)
            {
                this._turnY = 0;
            }
            else if (event.keyCode == 38)
            {
                this._turnY = 0;
            }
            
        }

        private function onResize(event:Event) : void
        {
            stage.stage3Ds[0].requestContext3D();
            
        }

        private function onFullscreen(event:FullScreenEvent) : void
        {
            if (event.fullScreen)
            {
                this._fullscreen = true;
            }
            else
            {
                this._fullscreen = false;
            }
            
        }

        private function onFullscreenClick(event:MouseEvent) : void
        {
            if (this._fullscreen)
            {
                stage.displayState = StageDisplayState.NORMAL;
            }
            else
            {
                stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            
        }

        private function onLoadStart(event:FileLoadEvent) : void
        {
            this._loadingFiles[event.url] = [event.currentBytes, event.totalBytes];
            this.updateLoadingStatus();
            
        }

        private function onLoadComplete(event:FileLoadEvent) : void
        {
            delete this._loadingFiles[event.url];
            this.updateLoadingStatus();
            
        }

        private function onLoadProgress(event:FileLoadEvent) : void
        {
            this._loadingFiles[event.url] = [event.currentBytes, event.totalBytes];
            this.updateLoadingStatus();
            
        }

        private function onLoadError(event:FileLoadEvent) : void
        {
            this._lockStatus = true;
            
        }

        private function updateLoadingStatus() : void
        {
            
        }

    }
}
