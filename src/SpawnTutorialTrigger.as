package
{
	public class SpawnTutorialTrigger extends TutorialTrigger
	{
		[Embed(source="../assets/spawMessage.png")] protected var SpawnTut:Class;
		
		public function SpawnTutorialTrigger(X:int, Y:int)
		{
			super(X, Y);
			SetUpMessage(SpawnTut);
		}
	}
}