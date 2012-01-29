package
{
	public class DestroyTutorialTrigger extends TutorialTrigger
	{
		[Embed(source="../assets/ui_TutorialDestroy.png")] protected var DesTut:Class;
		
		public function DestroyTutorialTrigger(X:int, Y:int)
		{
			super(X, Y);
			SetUpMessage(DesTut);
		}
	}
}