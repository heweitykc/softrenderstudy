package com.core
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.geomsolid.MuModel;
	import flash.geom.Vector3D;
	import flash.net.drm.AddToDeviceGroupSetting;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;

	public class SubMeshBase
	{
		public var bones:Array = [];
		public var img:String;
		public var scale:Number;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		protected var _rawVertex:Vector.<Number>;
		protected var _rawIndices:Vector.<uint>;
		protected var _texture:TextureBase;
		protected var _model:MuModel;
		
		public function SubMeshBase(context3d:Context3D, model:MuModel=null)
		{
			this.context3D = context3d;
			_model = model;
		}
		
		public function upload(rawVertex:Vector.<Number>, rawIndices:Vector.<uint>):void
		{
			_rawVertex = rawVertex;
			_rawIndices = rawIndices;
			generate();
			
			if (!img) return;
			
			_texture = new TextureBase(context3D);
			_texture.load(img);
		}
		
		private function generate():void
		{	
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / 5, 5);
			indexbuffer = context3D.createIndexBuffer(_rawIndices.length);						
			indexbuffer.uploadFromVector(_rawIndices, 0, _rawIndices.length);
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" + // pos to clipspace
				"mov v0, va1" // copy UV
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
				"tex ft1, v0, fs0 <2d>\n" +
				"mov oc, ft1"
			);
			
			program = context3D.createProgram();
			program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		private var r:Number=0;
		public function render(frame:int):void
		{
			if (!_texture.ok) return;
			
			if (_model.animation.isOK) {
				var newv:Vector.<Number> = computeNew(frame);
				vertexbuffer.uploadFromVector(newv, 0, newv.length / 5);
			} else {	//上传原始点
				vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 5);
			}
			//vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 5);
			r += 0.01
			var m:Matrix3D = RenderScene.ccamera.m.clone();
			m.prependScale(scale, scale, scale);
			//m.prependRotation(180, Vector3D.Y_AXIS);
			//m.prependRotation(r * 180 / Math.PI, Vector3D.Y_AXIS);
			
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setTextureAt(0, _texture.texture);
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			context3D.setVertexBufferAt(0,null);
			context3D.setVertexBufferAt(1, null);
		}
		
		private function computeNew(frame:int):Vector.<Number> {
			//trace("frame=" + frame);
			var newVertex:Vector.<Number> = new Vector.<Number>();
			for (var i:int = 0; i < _rawVertex.length; i += 5) {
				if (!bones[i / 5]) throw new Error("找不到node");
				var v:Vector3D = _model.animation.getNewVertex(_rawVertex[i], _rawVertex[i + 1], _rawVertex[i + 2], frame, bones[i / 5]);
				newVertex.push(v.x, v.y, v.z, _rawVertex[i + 3], _rawVertex[i + 4]);
			}
			return newVertex;
		}
	}
}
