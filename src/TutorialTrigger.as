package
{
	import org.flixel.*;
	
	public class TutorialTrigger extends FlxSprite
	{
		[Embed(source="../assets/tutTrigger.png")] protected var ImgTutTrigger:Class;
		
		private var tutorialMessage:TutorialMessage;
		
		public function TutorialTrigger(X:int,Y:int)
		{
			super(X,Y);
			loadGraphic(ImgTutTrigger,true,true,32,64);
			
			tutorialMessage=new TutorialMessage(0,0);
			tutorialMessage.x=X+this.width;
			tutorialMessage.y=Y-tutorialMessage.height/2;
			tutorialMessage.visible=false;
			FlxG.state.add(tutorialMessage);
		}
		
		public function ShowMessage():void
		{
			//trigger open anim
			tutorialMessage.visible=true;
		}
		
		public function HideMessage():void
		{
			//triger close
			tutorialMessage.visible=false;
		}
	}
}