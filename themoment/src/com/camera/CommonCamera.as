package com.camera
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	public class CommonCamera
	{
		protected var projectionTransform:PerspectiveMatrix3D;
		
		protected const MAX_FORWARD_VELOCITY:Number = 0.05;
		protected const MAX_ROTATION_VELOCITY:Number = 0.5;
		protected const LINEAR_ACCELERATION:Number = 0.0005;
		protected const ROTATION_ACCELERATION:Number = 0.01;
		protected const DAMPING:Number = 1.09;
		
		protected var _dxcamera:DxCamera;
		
		private var _stage:Stage;
		private var _p0:Point = new Point();
		private var _keyDown:Object;
		
		public function CommonCamera(stage:Stage)
		{
			_stage = stage;
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEventHandler );   
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEventHandler );
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			_keyDown = {};
		}
		
		protected function mouseDownHandler(e:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			_p0.x = _stage.mouseX;
			_p0.y = _stage.mouseY;
		}
		
		protected function mouseMoveHandler(e:MouseEvent):void
		{
			var dx:Number = _stage.mouseX - _p0.x;
			var dy:Number = _stage.mouseY - _p0.y;
			_dxcamera.yaw(dx/40);
			_dxcamera.pitch(dy/40);
			
			_p0.x = _stage.mouseX;
			_p0.y = _stage.mouseY;
		}
		
		protected function mouseUpHandler(e:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
		
		protected function keyDownEventHandler(e:KeyboardEvent):void
		{
			_keyDown[e.keyCode] = true;
		}
		
		private function operate():void
		{
			var angle:Number = 30/180*Math.PI;
			var units:Number = 0.1;
			
			if(_keyDown[Keyboard.W])
				_dxcamera.walk(units);
			else if(_keyDown[Keyboard.S])
				_dxcamera.walk(-units);
			
			if(_keyDown[Keyboard.A])
				_dxcamera.strafe(-units);
			else if(_keyDown[Keyboard.D])
				_dxcamera.strafe(units);
			
			if(_keyDown[Keyboard.R])
				_dxcamera.fly(units);
			else if(_keyDown[Keyboard.F])
				_dxcamera.fly(-units);
			
			if(_keyDown[Keyboard.M])
				_dxcamera.roll(-angle);
			else if(_keyDown[Keyboard.N])
				_dxcamera.roll(angle);
		}
		
		protected function keyUpEventHandler(e:KeyboardEvent):void
		{
			_keyDown[e.keyCode] = false;			
		}
		
		public function init():void
		{
			_dxcamera = new DxCamera(DxCamera.AIRCRAFT);
			
			projectionTransform = new PerspectiveMatrix3D();
			var aspect:Number = 4/3;
			var zNear:Number = 0.1;
			var zFar:Number = 1000;
			var fov:Number = 45*Math.PI/180;
			projectionTransform.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);
		}
		
		public var m:Matrix3D = new Matrix3D();
		
		public function loop():void
		{
			operate();
			m.identity();
			m.appendTranslation(0, 0, 12);
			m.append(_dxcamera.viewMatrix);
			m.append(projectionTransform);
		}
	}
}