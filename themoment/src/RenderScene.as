package
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.adobe.utils.Stats;
	import com.camera.CommonCamera;
	import com.terrain.TerrainData;
	
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
	public class RenderScene extends Sprite
	{
		private var _stats:Stats;
		private var _terrainData:TerrainData;
		private var _camera:CommonCamera;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		public function RenderScene()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_terrainData = new TerrainData();
			
			_stats = new Stats();
			addChild(_stats);
			
			start();
		}
		
		public function start():void
		{
			stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initMolehill );
			stage.stage3Ds[0].requestContext3D();
			
			addEventListener(Event.ENTER_FRAME, onRender);
			_camera = new CommonCamera(stage);
		}
		
		protected function initMolehill(e:Event):void
		{
			context3D = stage.stage3Ds[0].context3D;			
			context3D.configureBackBuffer(800, 600, 1, true);
			
			var vertices:Vector.<Number> = Vector.<Number>([
				-0.3,-0.3,0, 1, 1, 1, // x, y, z, r, g, b
				-0.3, 0.3, 0, 0, 1, 1,
				0.3, 0.3, 0, 1, 1, 1]);
			
			vertexbuffer = context3D.createVertexBuffer(3, 6);
			vertexbuffer.uploadFromVector(vertices, 0, 3);				
			
			var indices:Vector.<uint> = Vector.<uint>([0, 1, 2]);
			
			indexbuffer = context3D.createIndexBuffer(3);			
			indexbuffer.uploadFromVector (indices, 0, 3);		
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" + // pos to clipspace
				"mov v0, va1" // copy UV
			);			
			
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"mov oc, v0"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			_camera.init();
		}
		
		protected function onRender(e:Event):void
		{
			context3D.clear(0,0,0,1);
			
			context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);			
			context3D.setProgram(program);
			
			_camera.loop();
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _camera.m, true);
			
			context3D.drawTriangles(indexbuffer);
			
			context3D.present();			
		}
	}
}