//Code generated by Flan. http://www.tbam.com.ar/utility--flan.php

package  {
	import org.flixel.*;
	
	public class MapBase {
		//Layer name definitions
		public static const LAYER_NEW_LAYER:uint = 0;

		//Layer variable accessors
		public var layerMainGame:FlxTilemap;

		//Map layers and principal layer (map) declarations
		public var allLayers:Array;

		public var mainLayer:FlxTilemap;

		public var boundsMinX:int;
		public var boundsMinY:int;
		public var boundsMaxX:int;
		public var boundsMaxY:int;

		public function MapBase() { }

		public var bgColor:uint = 0xff000000;

		virtual public function addSpritesToLayerMainGame(onAddCallback:Function = null):void { }

		public var customValues:Object = new Object;		//Name-value map;
		virtual public function customFunction(param:* = null):* { }

	}
}
