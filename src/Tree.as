package
{
	import org.flixel.*;
	
	public class Tree extends FlxSprite
	{
		[Embed(source="../assets/main_BGtree6.png")] protected var ImgTree:Class;
		public var roots:FlxPoint;
		
		public function Tree(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgTree,true,true,32, 128);
			roots = new FlxPoint(X,Y+128);
			
			//bounding box tweaks
			width = 32;
			height = 128;
			offset.x = 1;
			offset.y = 1;
			
			//immovable = true;
			
			acceleration.y = 200;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("grow", [0, 1, 2, 3,4,5,6], 12, false);	
			
			
		}
	}
}