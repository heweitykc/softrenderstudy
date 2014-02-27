package com.geomsolid 
{
	import com.parser.BmdParser;
	/**
	 * ...
	 * @author callee
	 */
	public class BMDModel 
	{
		[Embed(source="../../../bin-debug/assets/Gate.bmd",mimeType = "application/octet-stream")] 
		private const terrainData:Class;
		private var _parser:BmdParser;
		
		public function BMDModel() 
		{
			_parser = new BmdParser();
			_parser.parse(new terrainData());
		}
	}

}