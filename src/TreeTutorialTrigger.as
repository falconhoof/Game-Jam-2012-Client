package
{
	public class TreeTutorialTrigger extends TutorialTrigger
	{
		[Embed(source="../assets/ui_TutorialTree.png")] protected var TreeTut:Class;
		
		public function TreeTutorialTrigger(X:int, Y:int)
		{
			super(X, Y);
			SetUpMessage(TreeTut);
		}
	}
}