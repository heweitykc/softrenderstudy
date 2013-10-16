package
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.adobe.utils.Stats;
	import com.camera.CommonCamera;
	import com.core.Mesh;
	import com.geomsolid.Plane;
	import com.terrain.Terrain;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	/**
	 * 场景渲染 
	 * @author rajhe
	 * 
	 */
	
	[SWF(width=800, height=600, frameRate=60, backgroundColor=0x000000)]
	public class RenderScene extends Sprite
	{
		private var _stats:Stats;
		private var _terrain:Terrain;
		private var _camera:CommonCamera;
		private var _mesh:Mesh;
		private var _round:Mesh;
		private var _plane:Plane;
		
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
		}
		
		protected function initStage3D(e:Event):void
		{
			stage.stage3Ds[0].removeEventListener( Event.CONTEXT3D_CREATE, initStage3D);
			
			context3D = stage.stage3Ds[0].context3D;			
			context3D.configureBackBuffer(800, 600, 1, true);
			
			var rawVertex:Vector.<Number>;
			var rawIndices:Vector.<uint>;
			
			rawVertex =  Vector.<Number>([
				0.5,   0.5, 0.5,  1, 0, 1,
				0.5,  0.5, -0.5,  0, 1, 1,
				-0.5, 0.5, -0.5,  1, 1, 1,
				
				-0.5, 0.5, 0.5,  1, 0, 1,
				0.5,  -0.5, 0.5,  0, 1, 1,
				-0.5, -0.5, 0.5,  1, 1, 1,
				
				-0.5, -0.5, -0.5,  1, 0, 1,
				0.5,  -0.5, -0.5,  0, 1, 1
			]);
			rawIndices = Vector.<uint>([
				0,1,2,	0,2,3,
				0,7,1,	0,4,7,
				1,7,6,	1,6,2,
				2,6,5,	2,3,5,
				0,5,4,	0,3,5,
				5,6,7,	4,5,7
			]);
			_mesh = new Mesh(context3D);
			_mesh.upload(rawVertex, rawIndices);
			
			_plane = new Plane(context3D,5,5,null);
			_terrain = new Terrain(context3D);
			_terrain.light = new Vector3D(0,100,0);
			
			_camera.init();
		}
		
		protected function onRender(e:Event):void
		{
			_camera.loop();
			
			context3D.clear(0,0,0,1);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _camera.m, true);
						
			_terrain.render();
			_mesh.render();
			_stats.update(2,0);
			context3D.present();			
		}
	}
}