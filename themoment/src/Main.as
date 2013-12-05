package 
{
	import com.adobe.utils.Stats;
    import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
    import flash.system.*;
	import com.zam.Viewer;
	
    public class Main extends Sprite
    {
		// model=103&modelType=0&viewerType=3&contentPath=//lkstatic.zamimg.com/shared/mv/
		private var _stat:Stats;
        public function Main()
        {
            stage.align = "TL";
            stage.scaleMode = "noScale";
			stage.frameRate = 60;
            Security.allowDomain("*");
			
			var parameters:Object = { 
				model:15,
				modelType:0,
				contentPath:"assets/"
			};
            addChild(new Viewer(parameters));
			_stat = new Stats();
			addChild(_stat);
			
			this.addEventListener(Event.ENTER_FRAME, onLoop);
			this.stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightCLick);
        }
		
		protected function onRightCLick(evt:MouseEvent):void
		{
			trace("onRightCLick");
		}
		
		protected function onLoop(evt:Event):void
		{
			_stat.update(0,0);
		}
    }
}
