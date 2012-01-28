package
{
	public class CreateTutorialTrigger extends TutorialTrigger
	{
		[Embed(source="../assets/createMessage.png")] protected var DesTut:Class;
		
		public function CreateTutorialTrigger(X:int, Y:int)
		{
			super(X, Y);
		}
	}
}