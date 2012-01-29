package
{
	public class CreateTutorialTrigger extends TutorialTrigger
	{
		[Embed(source="../assets/ui_TutorialCreate.png")] protected var CreTut:Class;
		
		public function CreateTutorialTrigger(X:int, Y:int)
		{
			super(X, Y);
			SetUpMessage(CreTut);
		}
	}
}