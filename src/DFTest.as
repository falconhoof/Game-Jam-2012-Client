package
{
	import flash.display.MovieClip;
	
	public class DFTest extends MovieClip
	{
		public function DFTest()
		{
			super();
			var st : StatsTracker = new StatsTracker();
			
			st.trackItem("age");
			st.trackItem("name");
			
			st.increment("age", 5);
			st.increment("age");
			
			st.setString("name", "david");
			
			trace( st.serialize());
			
			st.setString("name", "Jon");
			
			st.decrement("age", 2);
			trace( st.serialize());
		}
	}
}