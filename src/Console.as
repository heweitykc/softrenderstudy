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
  import flash.events.Event;
  import flash.net.LocalConnection;
  import flash.net.URLRequest;
  import flash.text.*;
  import flash.ui.*;
  import flash.events.*;
  import flash.utils.ByteArray;
  
  import com.adobe.flascc.vfs.ISpecialFile;
  import com.adobe.flascc.vfs.HTTPBackingStore;
  
  /**
  * A basic implementation of a console for FlasCC apps.
  * The PlayerKernel class delegates to this for things like read/write
  * so that console output can be displayed in a TextField on the Stage.
  */
  public class Console extends Sprite implements ISpecialFile
  {
    private var inputContainer:DisplayObjectContainer
    
    public var bmd:BitmapData;
    public var bm:Bitmap;
	private var _tf:TextField;
	
	public var inUp:int=0;
	public var inDown:int=0;
	public var inLeft:int=0;
	public var inRight:int=0;
	
	private var webfs:HTTPBackingStore = null
		
    /**
    * To Support the preloader case you might want to have the Console
    * act as a child of some other DisplayObjectContainer.
    */
    public function Console(container:DisplayObjectContainer = null)
    {
      CModule.rootSprite = container ? container.root : this

      if(container) {
        container.addChild(this)
        init(null)
      } else {
        addEventListener(Event.ADDED_TO_STAGE, init)
      }
    }

    /**
    * All of the real FlasCC init happens in this method
    * which is either run on startup or once the SWF has
    * been added to the stage.
    */
    protected function init(e:Event):void
    {
      stage.frameRate = 60;
      stage.scaleMode = StageScaleMode.NO_SCALE;
	  
      inputContainer = new Sprite()
      addChild(inputContainer)

      addEventListener(Event.ENTER_FRAME, enterFrame)
      
      bmd = new BitmapData(400, 400, false)
      bm = new Bitmap(bmd)
      inputContainer.addChild(bm)
	  bm.x = 50;
	  bm.y = 50;
	  
	  _tf = new TextField();
	  inputContainer.addChild(_tf);
	  _tf.background = true;
	  _tf.backgroundColor = 0xFFFF00;
	  _tf.textColor = 0xFF0000;
	  _tf.width = 200;
	  _tf.height = stage.stageHeight;
	  _tf.x = stage.stageWidth - _tf.width;
	  _tf.multiline = true;
	  _tf.appendText("starting...");
	  initKeyborad();
	  initFileSystem();     
    }
	
	private function initFileSystem():void
	{
		CModule.vfs.console = this;
		
		webfs = new HTTPBackingStore();
		webfs.addEventListener(Event.COMPLETE, onComplete);
    }

    private function onComplete(e:Event):void {
      CModule.vfs.addDirectory("/res")
      CModule.vfs.addBackingStore(webfs, "/res")
      CModule.startAsync(this)
    }
	
	private function initKeyborad():void
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
	}
	
	private function onKeyDown(evt:KeyboardEvent):void
	{
		_tf.appendText("evt.keyCode="+evt.keyCode+"\n");
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

    /**
    * The callback to call when FlasCC code calls the posix exit() function. Leave null to exit silently.
    * @private
    */
    public var exitHook:Function;

    /**
    * The PlayerKernel implementation will use this function to handle
    * C process exit requests
    */
    public function exit(code:int):Boolean
    {
      // default to unhandled
      return exitHook ? exitHook(code) : false;
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C IO write requests to the file "/dev/tty" (e.g. output from
    * printf will pass through this function). See the ISpecialFile
    * documentation for more information about the arguments and return value.
    */
    public function write(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
    {
      var str:String = CModule.readString(bufPtr, nbyte)
      consoleWrite(str)
      return nbyte
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C IO read requests to the file "/dev/tty" (e.g. reads from stdin
    * will expect this function to provide the data). See the ISpecialFile
    * documentation for more information about the arguments and return value.
    */
    public function read(fd:int, bufPtr:int, nbyte:int, errnoPtr:int):int
    {
      return 0
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C fcntl requests to the file "/dev/tty" 
    * See the ISpecialFile documentation for more information about the
    * arguments and return value.
    */
    public function fcntl(fd:int, com:int, data:int, errnoPtr:int):int
    {
      return 0
    }

    /**
    * The PlayerKernel implementation will use this function to handle
    * C ioctl requests to the file "/dev/tty" 
    * See the ISpecialFile documentation for more information about the
    * arguments and return value.
    */
    public function ioctl(fd:int, com:int, data:int, errnoPtr:int):int
    {
      return 0
    }

    /**
    * Helper function that traces to the flashlog text file and also
    * displays output in the on-screen textfield console.
    */
    public function consoleWrite(s:String):void
    {
		trace(s)
		_tf.appendText(s)
		_tf.scrollV = _tf.maxScrollV
    }

    /**
    * The enterFrame callback will be run once every frame. UI thunk requests should be handled
    * here by calling CModule.serviceUIRequests() (see CModule ASdocs for more information on the UI thunking functionality).
    */
    protected function enterFrame(e:Event):void
    {
      CModule.serviceUIRequests();
	  var args:Vector.<int> = new Vector.<int>([inUp,inDown,inLeft,inRight]);
      CModule.callI(CModule.getPublicSymbol("loop"), args);
    }
  }
}
