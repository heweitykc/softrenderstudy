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
		
		public function CommonCamera(stage:Stage)
		{
			_stage = stage;
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEventHandler );   
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEventHandler );
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
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
			var angle:Number = 10/180*Math.PI;
			var units:Number = 0.1;
			switch (e.keyCode) 
			{ 
				case Keyboard.W:	//up
					_dxcamera.walk(units);
					break;
				case Keyboard.S:	//down
					_dxcamera.walk(-units);
					break;
				case Keyboard.A:	//left
					_dxcamera.strafe(-units);
					break;
				case Keyboard.D:	//right
					_dxcamera.strafe(units);
					break;
				case Keyboard.R:	//down
					_dxcamera.fly(units);
					break;
				case Keyboard.F:	//down
					_dxcamera.fly(-units);
					break;
				case Keyboard.UP:	//down
					_dxcamera.pitch(angle);
					break;
				case Keyboard.DOWN:	//down
					_dxcamera.pitch(-angle);
					break;
				case Keyboard.LEFT:	//down
					_dxcamera.yaw(-angle);
					break;
				case Keyboard.RIGHT:	//down
					_dxcamera.yaw(angle);
					break;
				case Keyboard.M:	//down
					_dxcamera.roll(-angle);
					break;
				case Keyboard.N:	//down
					_dxcamera.roll(angle);
					break;
			}
		}
		
		protected function keyUpEventHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{ 
				case 37:
				case 39:
					break
				case 38:
				case 40:
					break
			}			
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
			m.identity();
			//m.appendRotation(getTimer()/30, Vector3D.Y_AXIS);
			//m.appendRotation(getTimer()/10, Vector3D.X_AXIS);
			m.appendTranslation(0, 0, 12);
			m.append(_dxcamera.viewMatrix);
			m.append(projectionTransform);
		}
	}
}