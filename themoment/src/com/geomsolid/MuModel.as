package com.geomsolid 
{
	import adobe.utils.CustomActions;
	import com.core.*;
	import flash.display3D.Context3D;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author callee
	 */
	public class MuModel
	{
		private var _context3d:Context3D;
		private var _loader:URLLoader;
		private var _content:Array;
		private var _ok:Boolean = false;
		private var _meshs:Object;
		private var _name:String;
		
		public function MuModel(context3d:Context3D)
		{
			_context3d = context3d;
		}
		
		public function load(name:String="Monster210"):void
		{
			_name = name;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onOK);
			_loader.load(new URLRequest("assets/"+name + "/" + name + ".smd"));
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		private function onOK(evt:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onOK);
			var spliter:String = String.fromCharCode(13, 10);
			_content = (_loader.data as String).split(spliter);
			
			var startp:int = _content.indexOf("triangles") + 1;
			var endp:int = _content.indexOf("end", startp);
			computeSubMesh(startp, endp);
			
			var index:int = 0;
			for (var i:int = startp; i < endp; i += 4) {
				var key:String = _content[i];
				var p0:Array = _content[i+1].split(" ");
				var p1:Array = _content[i + 2].split(" ");
				
				var p2:Array = _content[i+3].split(" ");
				_meshs[key].vertex.push(Number(p0[0]), Number(p0[1]), Number(p0[2]),  Number(p0[7]), 1-Number(p0[8]));
				_meshs[key].vertex.push(Number(p1[0]), Number(p1[1]), Number(p1[2]),  Number(p1[7]), 1-Number(p1[8]));
				_meshs[key].vertex.push(Number(p2[0]), Number(p2[1]), Number(p2[2]),  Number(p2[7]), 1-Number(p2[8]));
				var idx:int = _meshs[key].index.length;
				_meshs[key].index.push(idx, idx + 1, idx + 2);
				index++;
			}
			
			for each(var mesh:Object in _meshs) {
				var sub:SubMeshBase = mesh.submesh;
				sub.upload(mesh.vertex, mesh.index, _meshs[key].img);
			}
			
			_ok = true;
		}
		
		private function computeSubMesh(startp:int, endp:int):void
		{
			_meshs = { };
			for (var i:int = startp; i < endp; i += 4) {
				var key:String = _content[i];
				if (!_meshs[key]) {
					_meshs[key] = { };
					_meshs[key].vertex =  new Vector.<Number>();
					_meshs[key].index =  new Vector.<uint>();
					_meshs[key].submesh = new SubMeshBase(_context3d);
					_meshs[key].submesh.scale = 1;
					_meshs[key].img = "assets/"+_name + "/" + key;
				}
			}
		}
		
		public function render():void
		{
			if (!_ok) return;
			for each(var mesh:Object in _meshs) {
				mesh.submesh.render();
			}
		}
	}

}