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
		
		public var Pose:Array ;
		public var NodeTree:Array;
		
		private function parse():void
		{
			//build nodes
			_nodeTree = NodeTree;
			
			//build animations
			_frames = [];
			var nodeLen:int = _nodes.length + 1;
			var animatelen:int = _animates.length / (_nodes.length + 1);
			
			for (var i:int = 0; i < animatelen; i++) {
				var frame:Array = [];
				for (var j:int = 1; j < nodeLen; j++) {
					var framearr:Array = _animates[i * nodeLen + j].split(" ");
					var boneid:int = int(framearr[0]);
					var m:Matrix3D = MathUtil.rotate(
						Number(framearr[1]), Number(framearr[2]), Number(framearr[3]),
						Number(framearr[4]), Number(framearr[5]), Number(framearr[6])
					);
					frame[boneid] = m;					
				}
				
				//累积node的变换
				for (boneid = 0; boneid < _nodes.length; boneid++) {
					var parentId:int = _nodeTree[boneid];	//由于节点是从小到大顺序的，父节点肯定是已经累加过的
					if (parentId > -1)
						frame[boneid].append(frame[parentId]);
				}
				_frames.push(frame);
			}
			isOK = true;
		}
			
		public function getNewVertex(x:Number,y:Number,z:Number,frame:int,boneid:int):Vector3D
		{
			frame = frame % _frames.length;
			var inputv:Vector3D = new Vector3D(x, y, z);

			var m:Matrix3D = _frames[frame][boneid];
			var m1:Matrix3D = Pose[boneid].clone();
			m1.invert();
			var v1:Vector3D = m1.transformVector(inputv);
			var v2:Vector3D = m.transformVector(v1);
			
			return new Vector3D(x + v2.x, y + v2.y, z + v2.z);
		}
		
		public function get len():int
		{
			return _frames.length;
		}
	}

}