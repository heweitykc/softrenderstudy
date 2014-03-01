package
{
	import com.adobe.utils.*;
	import com.camera.*;
	import com.core.*;
	import com.geomsolid.*;
	import com.terrain.*;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	
	
	/**
	 * 场景渲染 
	 * @author rajhe
	 * 
	 */
	
	[SWF(width=1024, height=768, frameRate=30, backgroundColor=0xFF0000)]
	public class RenderScene extends Sprite
	{
		public static var ccamera:CommonCamera;
		
		private var _stats:Stats;
		private var _terrain:Terrain;
		private var _camera:CommonCamera;
		private var _mesh:Box;
		private var _mesh1:SubMeshBase;
		private var _round:SubMeshBase;
		private var _plane:Plane;
		private var _light:Vector3D;
		private var _model1:MuModel;
		
		protected var context3D:Context3D;
		
		public function RenderScene()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_stats = new Stats();
			addChild(_stats);
			
			start();
		}
		
		public function start():void
		{
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, initStage3D);
			stage.stage3Ds[0].requestContext3D();
			
			addEventListener(Event.ENTER_FRAME, onRender);
			_camera = new CommonCamera(stage);
			ccamera = _camera;
		}
		
		protected function initStage3D(e:Event):void
		{
			stage.stage3Ds[0].removeEventListener( Event.CONTEXT3D_CREATE, initStage3D);
			
			context3D = stage.stage3Ds[0].context3D;			
			context3D.configureBackBuffer(1024, 768, 16, true, true);
			
			_mesh = new Box(context3D);
			
			_plane = new Plane(context3D,5,5,null);
			_terrain = new Terrain(context3D);
			_light =  new Vector3D(0, 0, 0);
			
			_model1 = new MuModel(context3D);
			_model1.load();
			
			_camera.init();
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEventHandler ); 
		}
		
		protected function keyDownEventHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.DELETE)
				_light.x -= _increment;
			else if(e.keyCode == Keyboard.PAGE_DOWN)
				_light.x += _increment;
			else if(e.keyCode == Keyboard.HOME)
				_light.y += _increment;
			else if(e.keyCode == Keyboard.END)
				_light.y -= _increment;
		}
		
		private var _increment:Number = 0.2;
		protected function onRender(e:Event):void
		{
			_camera.loop();
			
			context3D.clear(0,0,0,1);

			var pos:Vector3D = new Vector3D(_light.x, _light.y, 10);
			
			_terrain.light = pos;
			//_terrain.render();
			//_plane.render();
			//_mesh.render();
			_model1.render();
			_stats.update(2, 0);
			
			context3D.present();			
		}
	}
}