package
{
	import org.flixel.FlxSprite;
	
	public class TreeClimbSprite extends FlxSprite
	{
		[Embed(source = "../assets/char_climb.png")] protected var ImgTree:Class;
		//[Embed(source="../assets/TreeBurstAnimScaled.png")] protected var ImgTree:Class;
		function TreeClimbSprite(X:Number=0,Y:Number=0)
		{
			super(x,y);
			
			loadGraphic(ImgTree,true,true,64, 190);
			addAnimation("Climb",[0,1,2,3,4,5,6,7],24,false);
		}
	}
}