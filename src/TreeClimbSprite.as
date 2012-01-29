package
{
	import org.flixel.FlxSprite;
	
	public class TreeClimbSprite extends FlxSprite
	{
		//[Embed(source = "../assets/treeClimb.png")] protected var ImgTree:Class;
		[Embed(source="../assets/TreeBurstAnimScaled.png")] protected var ImgTree:Class;
		function TreeClimbSprite(X:Number=0,Y:Number=0)
		{
			super(x,y);
			
			loadGraphic(ImgTree,true,true,128, 128);
			//
			addAnimation("grow", [0, 1, 2, 3,4,5,6,7,8,9,10,10,10,10,10,10,11,12,13,
				14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29], 24, false);
			
			//We should use when we have asset
			//loadGraphic(ImgTree,true,false,128,128);
			//addAnimation("Climb",[0,1,2,3,4,5,6,7],15,false);
		}
	}
}