package com.core 
{
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import com.misc.MathUtil;
		
	/**
	 * ...
	 * @author callee
	 */
	public class Animation 
	{
		public var isOK:Boolean = false;
		
		private var _animates:Array;
		private var _nodes:Array;
		
		private var _nodeTree:Array;
		private var _frames:Array;
		private var _loader:URLLoader;
		
		public function Animation() 
		{
		}
		
		public function load(path:String):void
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onOK);
			_loader.load(new URLRequest(path));
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		private function onOK(evt:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, onOK);
			var spliter:String = String.fromCharCode(13, 10);
			var content:Array = (_loader.data as String).split(spliter);
			var startp:int, endp:int;
			startp = content.indexOf("nodes") + 1;
			endp = content.indexOf("end", startp);
			_nodes = content.slice(startp, endp);
			
			startp = content.indexOf("skeleton") + 1;
			endp = content.indexOf("end", startp);
			_animates = content.slice(startp, endp);
			
			trace("_nodes长度" + _nodes.length);
			trace("_animates长度" + _animates.length/(_nodes.length+1));
			
			parse();
		}
		
		//保留第一帧动画
		
		public var FirstF:Array ;
		
		private function parse():void
		{
			//build nodes
			_nodeTree = [];
			for (var i:int = 0; i < _nodes.length; i++) {
				var arr:Array = _nodes[i].split(" ");
				var boneid:int = int(arr[0]);
				var parentid:int = int(arr[2]);
				_nodeTree[boneid] = parentid;
			}
			
			//build animations
			_frames = [];
			var nodeLen:int = _nodes.length + 1;
			var animatelen:int = _animates.length / (_nodes.length + 1);
			
			for (i = 0; i < animatelen; i++) {
				var frame:Array = [];
				for (var j:int = 1; j < nodeLen; j++) {
					var framearr:Array = _animates[i * nodeLen + j].split(" ");
					boneid = int(framearr[0]);
					var m:Matrix3D = new Matrix3D();
					m.appendTranslation(Number(framearr[1]), Number(framearr[2]), Number(framearr[3]));
					m.appendRotation(Number(framearr[4]) * 180 / Math.PI, Vector3D.X_AXIS);
					m.appendRotation(Number(framearr[5]) * 180 / Math.PI, Vector3D.Y_AXIS);
					m.appendRotation(Number(framearr[6]) * 180 / Math.PI, Vector3D.Z_AXIS);
					m.append(FirstF[boneid]);
					frame[boneid] = m;					
				}
				
				//累积node的变换
				for (boneid = 0; boneid < _nodes.length; boneid++) {
					var parentId:int = _nodeTree[boneid];	//由于节点是从小到大顺序的，父节点肯定是已经累加过的
					if (parentId > -1)
						frame[boneid].prepend(frame[parentId]);
				}
				_frames.push(frame);
			}
			isOK = true;
		}
		
		/*	
		public function getNewVertex(x:Number,y:Number,z:Number,frame:int,boneid:int):Vector3D
		{
			frame = frame % _frames.length;
			var startp:Vector3D = new Vector3D(x,y,z);
			var m:Matrix3D = _frames[frame][boneid];
			startp.incrementBy(m.position);
			return startp;
		}*/
			
		public function getNewVertex(x:Number,y:Number,z:Number,frame:int,boneid:int):Vector3D
		{
			frame = frame % _frames.length;
			//frame = 0;
			var m:Matrix3D = _frames[frame][boneid];
			return new Vector3D(x+m.position.x, y+m.position.y, z+m.position.z);
		}
		
		public function get len():int
		{
			return _frames.length;
		}
	}

}