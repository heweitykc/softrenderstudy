package com.geomsolid
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	
	public class Plane
	{
		//[Embed(source="../../../assets/heightMap.jpg",mimeType = "application/octet-stream")] 
		//private const terrainData:Class;
		
		[Embed(source="../../../assets/desert.jpg")] 
		private const terrainData:Class;
		
		private var _w:Number;
		private var _h:Number;
		private var _vertical:Vector3D;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		protected var texture0:Texture;
		
		private var _rawVertex:Vector.<Number>;
		private var _rawIndices:Vector.<uint>;
		
		private var _bmp:Bitmap;
		
		public function Plane(context3d:Context3D,w:Number,h:Number, vertical:Vector3D)
		{
			this.context3D = context3d;
			_w = w;
			_h = h;
			_vertical = vertical;
			
			init();
		}
		
		
		public function upload(rawVertex:Vector.<Number>, rawIndices:Vector.<uint>):void
		{
			_rawVertex = rawVertex;
			_rawIndices = rawIndices;
			generate();
		}
		
		private function generate():void
		{	
			_bmp = new terrainData();
			texture0 = context3D.createTexture(_bmp.bitmapData.width, _bmp.bitmapData.height, Context3DTextureFormat.BGRA, false);
			texture0.uploadFromBitmapData(_bmp.bitmapData);
			
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / 5, 5);
			vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 5);				
			
			indexbuffer = context3D.createIndexBuffer(_rawIndices.length);			
			indexbuffer.uploadFromVector(_rawIndices, 0, _rawIndices.length);
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" +
				"mov v0, va1"
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
				"tex ft1, v0, fs0 <2d>\n" + 
				"mov oc, ft1"
			);
			
			program = context3D.createProgram();
			program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		public function render():void
		{
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setTextureAt(0,texture0); 
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
		}
		
		private function init():void
		{
			var _rawVertex:Vector.<Number> = Vector.<Number>([
				_w, -0.6, _h,   0,1,
				_w, -0.6, -_h,  1,1,
				-_w, -0.6, -_h, 1,0,
				-_w, -0.6, _h,  0,0
			]);
			
			var _rawIndices:Vector.<uint> = Vector.<uint>([
				0,1,2, 0,2,3
			]);
			
			this.upload(_rawVertex, _rawIndices);
		}
	}
}