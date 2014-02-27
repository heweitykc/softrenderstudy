package com.misc 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author callee
	 */
	public class HexUtil 
	{
		public static function ReadFixedString(bts:ByteArray, len:int):String
		{
			return bts.readMultiByte(len, "cn-gb");
		}
	}

}