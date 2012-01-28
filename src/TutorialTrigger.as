package
{
	import org.flixel.*;
	
	public class TutorialTrigger extends FlxSprite
	{
		[Embed(source="../assets/tutTrigger.png")] protected var ImgTutTrigger:Class;

		
		protected var tutorialMessage:TutorialMessage;
		
		public function TutorialTrigger(X:int,Y:int)
		{
			super(X,Y+16);
			loadGraphic(ImgTutTrigger,true,true,32,64);
		}
		
		public function SetUpMessage(img:Class):void
		{
			tutorialMessage=new TutorialMessage(0,0);
			tutorialMessage.loadMessageImage(img,0,0);
			tutorialMessage.x=this.x+this.width;
			tutorialMessage.y=this.y-tutorialMessage.height/2;
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