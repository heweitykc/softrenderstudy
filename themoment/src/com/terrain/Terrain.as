package com.terrain
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	public class Terrain
	{
		[Embed(source="../../../assets/coastMountain64.raw",mimeType = "application/octet-stream")] 
		private const terrainData : Class;
		
		[Embed(source="../../../assets/desert.jpg")] 
		private const tileData:Class;
		
		private var _heightMap:Vector.<uint>;
		private var _rawVertex:Vector.<Number>;
		private var _rawIndex:Vector.<uint>;
		
		private var uCoordIncrementSize:Number = 1.0; 	// 每列顶点数;
		private var vCoordIncrementSize:Number = 1.0; 	// 每行顶点数;
		private var _cellSpacing:Number = 1.0; 			//每行顶点数;
		private var _numVertsPerRow:int = 6; 			//顶点格式
		
		private var _numCellsperCol:int = 64; 			//column
		private var _numCellsPerRow:int = 64; 			//row
		private var _heightScale:Number = 1/20;
		private var _cellScale:Number = 1/10;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		protected var texture0:Texture;
		
		private var _light:Vector3D;
		
		private var _bmp:Bitmap;
		
		public function Terrain(context3d:Context3D)
		{
			this.context3D = context3d;
			
			_heightMap = new Vector.<uint>();
			_rawVertex = new Vector.<Number>();
			_rawIndex = new Vector.<uint>();
			
			_bmp = new tileData();
			
			parseHeightMaps(new terrainData());
			generateVertex();
			generateIndices();
			
			generate();
		}
		
		public function set light(value:Vector3D):void
		{			
			_light = value;
			_light.normalize();
		}
		
		public function get vertices():Vector.<Number>
		{
			return _rawVertex;
		}
		
		public function get verticesSize():uint
		{
			return _numVertsPerRow;
		}
		
		public function get indices():Vector.<uint>
		{
			return _rawIndex;
		}
		
		private function generate():void
		{				
			texture0 = context3D.createTexture(_bmp.bitmapData.width, _bmp.bitmapData.height, Context3DTextureFormat.BGRA, false);
			texture0.uploadFromBitmapData(_bmp.bitmapData);
			
			vertexbuffer = context3D.createVertexBuffer(_rawVertex.length / 8, 8);
			vertexbuffer.uploadFromVector(_rawVertex, 0, _rawVertex.length / 8);				
			
			indexbuffer = context3D.createIndexBuffer(_rawIndex.length);
			indexbuffer.uploadFromVector(_rawIndex, 0, _rawIndex.length);
			
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" +
				"mov v0, va1\n" +
				"mov v1, va2"	//法线向量
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <2d>\n" + 
				"dp4 ft1, fc0, v1\n" +		//法线   * 灯光
				"mul oc, ft0.rgba, ft1.x"
			);
			
			program = context3D.createProgram();
			program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		public function render():void
		{
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);	//xyz
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);	//uv
			context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);	//法线向量
			context3D.setTextureAt(0,texture0);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, RenderScene.ccamera.m, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([_light.x,_light.y,_light.z,0]));
			context3D.setProgram(program);
			context3D.drawTriangles(indexbuffer);
			
			context3D.setVertexBufferAt(0,null);
			context3D.setVertexBufferAt(1,null);
			context3D.setVertexBufferAt(2,null);
			context3D.setTextureAt(0,null);
		}
		
		private function parseHeightMaps(data:ByteArray) : Boolean
		{
			if(null == data || 0 == data.bytesAvailable) return false;
			
			var len : uint = data.bytesAvailable;
			for(var i : int = 0; i < len; i++){
				_heightMap.push(data.readUnsignedByte());
			}
			return true;
		}
		
		private function generateVertex():void
		{
			var u:Number, v:Number;

			for(var x:int = 0; x<_numCellsperCol; x++)
			{
				for(var z:int = 0; z<_numCellsPerRow; z++)
				{
					if(x%2 == 0)
					{
						if(z%2 == 0)
						{
							u = 0;
							v = 0;
						}
						else
						{
							u = 0;
							v = 1;
						}
					}
					else
					{
						if(z%2 == 0)
						{
							u = 1;
							v = 0;
						}
						else
						{
							u = 1;
							v = 1;
						}
					}
					//x/y/z,u/v,nx,ny,nz
					var normal:Vector3D = computeNormal(x,z);
					_rawVertex.push(
						x, 
						_heightMap[x*_numCellsPerRow+z] * _heightScale,
						z,
						u,
						v,
						normal.x,
						normal.y,
						normal.z
					);
				}
			}
		}
		
		private function computeNormal(x:Number,z:Number):Vector3D
		{
			if(x >= (_numCellsperCol-1) || z < 1)
			{
				return new Vector3D(0,1,0);
			}
			
			var heightA:Number, heightB:Number, heightC:Number;
			heightA = _heightMap[x*_numCellsPerRow+z];
			heightB = _heightMap[(x+1)*_numCellsPerRow+z];
			heightC = _heightMap[x*_numCellsPerRow+z-1];
			
			var u:Vector3D = new Vector3D(1, heightB - heightA,  0);
			var v:Vector3D = new Vector3D(0, heightC - heightA, -1);
			var n:Vector3D = u.crossProduct(v);
			n.normalize();
			
			return n;
		}
		
		private function generateIndices() : void
		{
			for(var x:int = 0; x<_numCellsperCol-1; x++)
			{
				for(var z:int = 0; z<_numCellsPerRow-1; z++)
				{
					_rawIndex.push(x*_numCellsPerRow+z,     (x+1)*_numCellsPerRow+z,  x*_numCellsPerRow+z+1);
					_rawIndex.push((x+1)*_numCellsPerRow+z, x*_numCellsPerRow+z+1,   (x+1)*_numCellsPerRow+z+1);
				}
			}
		}
	}
}