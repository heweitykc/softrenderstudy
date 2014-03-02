package com.core 
{
	/**
	 * ...
	 * @author callee
	 */
	public class SMDCore 
	{
		public static var SPLITER:String = String.fromCharCode(13, 10);
		
		private var _vectices:Vector.<SMDVertex> = new Vector.<SMDVertex>();
		public function SMDCore() 
		{
			
		}
		
		public function loadMesh(content:String):int
		{
			var datas:Array = content.split(SPLITER);
			
			var startp:int = datas.indexOf("triangles") + 1;
			var endp:int = datas.indexOf("end", startp);
			
			
		}
		
		public function ParseTriangles(datas:Array, startp:int, endp:int):void
		{
			for (var i:int = startp; i < endp; i += 4) {
				
				var key:String = datas[i];
				var p0:Array = datas[i+1].split(" ");
				var p1:Array = datas[i + 2].split(" ");
				var p2:Array = datas[i + 3].split(" ");
				
				var v0:SMDVertex = createVertex(p0);
				var v1:SMDVertex = createVertex(p1);
				var v2:SMDVertex = createVertex(p2);
				
				
				_meshs[key].submesh.bones.push(int(p0[0]));	//顶点对应的关节
				_meshs[key].submesh.bones.push(int(p1[0]));	//顶点对应的关节
				_meshs[key].submesh.bones.push(int(p2[0]));	//顶点对应的关节
				
				_meshs[key].vertex.push(Number(p0[1]), Number(p0[2]), Number(p0[3]),  Number(p0[7]), 1-Number(p0[8]));
				_meshs[key].vertex.push(Number(p1[1]), Number(p1[2]), Number(p1[3]),  Number(p1[7]), 1-Number(p1[8]));
				_meshs[key].vertex.push(Number(p2[1]), Number(p2[2]), Number(p2[3]),  Number(p2[7]), 1-Number(p2[8]));
				
				var idx:int = _meshs[key].index.length;
				_meshs[key].index.push(idx, idx + 1, idx + 2);
				index++;
			}
		}
		
		private function createVertex(p:Array):SMDVertex
		{
			var v0:SMDVertex = new SMDVertex();
			v0.postion[0] = Number(p0[1]);
			v0.postion[1] = Number(p0[2]);
			v0.postion[2] = Number(p0[3]);
			v0.texcoord[0] = Number(p0[7]);
			v0.texcoord[1] = 1 - Number(p0[8]);
			return v0;
		}
		
		public function loadAnimation(path:String):int
		{
			
		}
		
		public function loadTexture(path:String):int
		{
			
		}
	}
}