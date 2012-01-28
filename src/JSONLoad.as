package 
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class JSONLoad extends Sprite 
	{
		private var callback : Function;
		
		public function JSONLoad(url : String, cback : Function):void 
		{
			callback = cback;
			loadJSONData(url);
		}
		
		private function loadJSONData(url : String):void
		{
			var urlReq:URLRequest = new URLRequest(url);
			var urlLoader:URLLoader = new URLLoader(urlReq);
			urlLoader.addEventListener(Event.COMPLETE, onJSONLoaderComplete);
		}
		
		private function onJSONLoaderComplete(e:Event):void 
		{
			var raw:String = String(e.target.data);
			var data:Array = com.adobe.serialization.json.JSON.decode(raw) as Array;
			
			callback( data );
		}
		
	}
	
}