//Code generated by Flan. http://www.tbam.com.ar/utility--flan.php

package  {
	import org.flixel.*;
	
	public class MapMainMap extends MapBase {
		//Media content declarations
		[Embed(source="../assets/MapCSV_MainMap_MainGame.txt", mimeType="application/octet-stream")] public var CSV_MainGame:Class;
		[Embed(source="../assets/32x4 Tiles (Row).png")] public var Img_MainGame:Class;

		
		public function MapMainMap() {

			_setCustomValues();

			bgColor = 0xff000000;

			layerMainGame = new FlxTilemap();
			layerMainGame.loadMap(new CSV_MainGame, Img_MainGame,32,32);


			layerMainGame.x = 0;
			layerMainGame.y = 0;
			layerMainGame.scrollFactor.x = 1.000000;
			layerMainGame.scrollFactor.y = 1.000000;

			allLayers = [ layerMainGame ];


			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 1280;
			boundsMaxY = 704;
		}
		
		
		
		override public function addSpritesToLayerMainGame(onAddCallback:Function = null):void {
			var obj:FlxSprite;
			
			obj = new Player(64, 576);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Exit(1120, 640);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
		}

		override public function customFunction(param:* = null):* {

		}

		private function _setCustomValues():void {
		}

	}
}
