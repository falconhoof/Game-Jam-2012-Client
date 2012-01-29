package
{
	import org.flixel.FlxSprite;
	
	public class BackgroundTree extends FlxSprite
	{
		
		[Embed(source="../assets/main_BGtree1.png")] protected var ImgTree1:Class;
		[Embed(source="../assets/main_BGtree2.png")] protected var ImgTree2:Class;
		[Embed(source="../assets/main_BGtree3.png")] protected var ImgTree3:Class;
		[Embed(source="../assets/main_BGtree4.png")] protected var ImgTree4:Class;
		[Embed(source="../assets/main_BGtree5.png")] protected var ImgTree5:Class;
		[Embed(source="../assets/main_BGtree6.png")] protected var ImgTree6:Class;
		
		protected var treeArray:Array;
		
		public function BackgroundTree(X:Number=0, Y:Number=0)
		{
			var randomTree:Number;
			super(X, Y);
			treeArray = new Array(6);
			treeArray[0]=(ImgTree1);
			treeArray[1]=(ImgTree2);
			treeArray[2]=(ImgTree3);
			treeArray[3]=(ImgTree4);
			treeArray[4]=(ImgTree5);
			treeArray[5]=(ImgTree6);
			
			
			randomTree = Math.round((Math.random() * 5));
			loadGraphic(treeArray[randomTree],true,false,64, 128);
			
			
		}
	}
}