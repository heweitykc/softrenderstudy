package 
{
    import com.zam.*;
    import flash.display.*;
    import flash.system.*;

    public class Main extends Sprite
    {

        public function Main()
        {
            stage.align = "TL";
            stage.scaleMode = "noScale";
            Security.allowDomain("*");
            var _loc_1:* = new Viewer(stage.loaderInfo.parameters, root.loaderInfo.url);
            addChild(_loc_1);
            return;
        }// end function

    }
}
