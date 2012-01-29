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
		
		//DF added 
		// embed images
		[Embed(source="../assets/bg_gradientA.png")] private var BgGradientA:Class;
		// classify images
		private var gradientA : FlxSprite;
		
		public var backgroundSprites : Array;
		
		public var treesAllowed : Number = 0;
		public var platformsAllowed : Number = 0;
		public var explosionsAllowed : Number = 0;
		public var respawnsAllowed : Number = 0;
		// end DF
		
		public function MapBase() { }
		
		public var bgColor:uint = 0xffffffff;
		
		virtual public function addSpritesToLayerMainGame(onAddCallback:Function = null):void { }
		
		public var customValues:Object = new Object;		//Name-value map;
		virtual public function customFunction(param:* = null):* { }
		
		/*
		*  Added by DF - pass in level Id and this will create appropriate background images.
		*/
		public function decorateBackground(levelId : Number) : void {
			backgroundSprites = new Array();
			
			//sky parallax layer.
			gradientA = new FlxSprite(0,0, BgGradientA);
			gradientA.solid = false;
			gradientA.moves = false;
			//	gradientA.collideBottom = gradientA.collideLeft = gradientA.collideRight = gradientA.collideTop = false;
			backgroundSprites.push(gradientA);
			
		}
		
	}
}
