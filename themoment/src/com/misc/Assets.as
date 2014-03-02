package com.misc 
{
	/**
	 * ...
	 * @author callee
	 */
	public class Assets 
	{
		[Embed(source="../../../bin-debug/assets/Monster210/Monster210.smd",mimeType = "application/octet-stream")] 
		private const MESH:Class;
		
		[Embed(source="../../../bin-debug/assets/Monster210/gorizungal.jpg",mimeType = "application/octet-stream")] 
		private const TEXTURE:Class;
		
		[Embed(source="../../../bin-debug/assets/Monster210/Monster210_001.smd",mimeType = "application/octet-stream")] 
		private const ANIMATION:Class;
	}

}
