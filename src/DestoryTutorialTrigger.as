package
{
	public class DestoryTutorialTrigger extends TutorialTrigger
	{
		[Embed(source="../assets/destroyMessage.png")] protected var DesTut:Class;
		
		public function DestoryTutorialTrigger(X:int, Y:int)
		{
			super(X, Y);
			SetUpMessage(DesTut);
		}
	}
}