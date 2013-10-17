package com.core
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;

	public class Mesh
	{
		public var x:Number=0;
		public var y:Number=0;
		public var z:Number=0;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		private var _rawVertex:Vector.<Number>;
		private var _rawIndices:Vector.<uint>;
		
		public function Mesh(context3d:Context3D)
		{
			this.context3D = context3d;
		}
		
		public function upload(rawVertex:Vector.<Number>, rawIndices:Vector.<uint>):void
		{
			_rawVertex = rawVertex;
			_rawIndices = rawIndices;
			generate();
		}
		
		private function generate():void
		{	
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / 6, 6);
			vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 6);				
			
			indexbuffer = context3D.createIndexBuffer(_rawIndices.length);			
			indexbuffer.uploadFromVector(_rawIndices, 0, _rawIndices.length);
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				//"m44 vt0, vc1, vc0\n" +
				"m44 op, va0, vc0\n" +
				"mov v0, va1"
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
				"mov oc, v0"
			);
			
			program = context3D.createProgram();
			program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		public function render():void
		{
			var m:Matrix3D = RenderScene.ccamera.m.clone();
			m.prependTranslation(x,y,z);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_3);			
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			context3D.setVertexBufferAt(0,null);
			context3D.setVertexBufferAt(1,null);
		}
	}
}
