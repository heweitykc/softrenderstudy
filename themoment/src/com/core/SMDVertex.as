package com.core 
{
	/**
	 * ...
	 * @author callee
	 */
	public class SMDVertex 
	{
		public var postion:Vector.<Number>=new Vector.<Number>(3);
		public var normal:Vector.<Number>=new Vector.<Number>(3);
		public var texcoord:Vector.<Number> = new Vector.<Number>(2);
		
		public var joints:Array;
		public var weights:Array;
	}

}