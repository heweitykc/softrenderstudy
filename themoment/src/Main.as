package 
{
    import flash.display.*;
	import flash.events.MouseEvent;
    import flash.system.*;

	/*
	 * 

			{
			  "Model": "item/objectcomponents/weapon/mace_1h_outlandraid_d_03.mo3",
			  "Textures": {},
			  "Model2": null,
			  "Textures2": null,
			  "Slot": 0,
			  "Race": 0,
			  "Gender": 0,
			  "Texture": null,
			  "SkinColor": 0,
			  "FaceType": 0,
			  "FacialHair": 0,
			  "HairStyle": 0,
			  "HairColor": 0,
			  "ShowHair": 0,
			  "ShowFacial1": 0,
			  "ShowFacial2": 0,
			  "ShowFacial3": 0,
			  "ShowEars": 0,
			  "Equipment": null,
			  "RaceModels": null,
			  "Geosets": null,
			  "GenderModels": null,
			  "GenderTextures": null,
			  "GeosetA": 0,
			  "GeosetB": 0,
			  "GeosetC": 0
			}

			model=41873&modelType=1&contentPath=http://wow.zamimg.com/modelviewer/
	 * */
	
    public class Main extends Sprite
    {
        public function Main()
        {
            stage.align = "TL";
            stage.scaleMode = "noScale";
            Security.allowDomain("*");
            //addChild(new Viewer(stage.loaderInfo.parameters, root.loaderInfo.url));
			
			this.stage.addEventListener(MouseEvent.RIGHT_CLICK,onRightCLick );
			
            return;
        }// end function
		protected function onRightCLick(evt:MouseEvent):void
		{
			trace("onRightCLick");
		}
		
    }
}
