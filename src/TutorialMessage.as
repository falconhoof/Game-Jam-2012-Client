package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class TutorialMessage extends FlxSprite
	{
		[Embed(source="../assets/ui_TutorialBubble.png")] protected var ImgTut:Class;
		protected var message:String="Message";
		public var messageDisplay:FlxText;
		
		public function TutorialMessage(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(ImgTut,false,false,256,256);
			messageDisplay=new FlxText(0,0,256,message);
			messageDisplay.color=0xFFFFFFFF;
			messageDisplay.size=18;
			FlxG.state.add(messageDisplay);
			messageDisplay.visible=true;
			
			
			/*
			var t:FlxText;
			t = new FlxText(0,FlxG.height/2-20,FlxG.width,message);
			t.color=0xFFFFFFFF;
			t.size = 32;
			t.alignment = "center";
			add(t);	*/		
		}
		
		public function loadMessageImage(img:Class,X:Number=0, Y:Number=0):void
		{
			loadGraphic(img,true,true,128,64);
		}
	}
}