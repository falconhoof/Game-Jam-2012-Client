package  {
	import org.flixel.*;
	
	public class MapMainMapSmall extends MapBase {
		//Media content declarations
		[Embed(source="../assets/MapCSV_MainMap_MainGame16.txt", mimeType="application/octet-stream")] public var CSV_MainGame:Class;
		[Embed(source="../assets/game_tilesheetA16wide.png")] public var Img_MainGame:Class;

		
		public function MapMainMapSmall() {

			_setCustomValues();

			bgColor = 0xffffffff;

			layerMainGame = new FlxTilemap();
			
			layerMainGame.loadMap(new CSV_MainGame, Img_MainGame,16,16);
			layerMainGame.x = 0;
			layerMainGame.y = 0;
			layerMainGame.scrollFactor.x = 1.000000;
			layerMainGame.scrollFactor.y = 1.000000;

			allLayers = [ layerMainGame ];


			boundsMinX = 0;
			boundsMinY = 0;
			boundsMaxX = 1280;
			boundsMaxY = 720;
			FlxG.bgColor=bgColor;
		}

		override public function addSpritesToLayerMainGame(onAddCallback:Function = null):void {
			var obj:FlxSprite;
			
			obj = new Player(56, 280);;
			obj.x+=obj.offset.x;
			obj.y+=obj.offset.y;
			FlxG.state.add(obj);
			if(onAddCallback != null)
				onAddCallback(obj);
			obj = new Exit(1216, 304);;
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
