package 
{
    import flash.display.*;
	import flash.events.MouseEvent;
    import flash.system.*;
	import com.zam.Viewer;
	
    public class Main extends Sprite
    {
		// model=103&modelType=0&viewerType=3&contentPath=//lkstatic.zamimg.com/shared/mv/
		
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
			
			this.stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightCLick);
        }
		protected function onRightCLick(evt:MouseEvent):void
		{
			trace("onRightCLick");
		}
		
    }
}
