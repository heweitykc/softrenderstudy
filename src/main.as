/*
** ADOBE SYSTEMS INCORPORATED
** Copyright 2012 Adobe Systems Incorporated
** All Rights Reserved.
**
** NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
** terms of the Adobe license agreement accompanying it.  If you have received this file from a
** source other than Adobe, then your use, modification, or distribution of it requires the prior
** written permission of Adobe.
*/
package com.adobe.flascc
{
  import flash.display.*;

  public class main extends Sprite
  {
	public function main()
	{
		addEventListener(Event.ADDED_TO_STAGE, init)
	}
	
	protected function init(e:Event):void
    {
      stage.frameRate = 60;
      stage.scaleMode = StageScaleMode.NO_SCALE;
	  initKeyborad();
	}
	
	private function initKeyborad():void
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		stage.focus = this;
	}
	
	private function onKeyDown(evt:KeyboardEvent):void
	{
		switch(evt.keyCode)
		{
			case Keyboard.A:
				inLeft=1;
				break;
			case Keyboard.D:
				inRight=1;
				break;
			case Keyboard.W:
				inUp=1;
				break;
			case Keyboard.S:
				inDown=1;
				break;
		}
	}
	
	private function onKeyUp(evt:KeyboardEvent):void
	{
		switch(evt.keyCode)
		{
			case Keyboard.A:
				inLeft=0;
				break;
			case Keyboard.D:
				inRight=0;
				break;
			case Keyboard.W:
				inUp=0;
				break;
			case Keyboard.S:
				inDown=0;
				break;
		}
	}
  }
}
