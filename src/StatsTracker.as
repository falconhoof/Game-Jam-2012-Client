package 
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	
	import org.flixel.*;
	
	
	public class StatsTracker extends Sprite
	{
		private var trackedItems : Array;
		
		public function StatsTracker()
		{
			trackedItems = new Array();
			trackItem("username", "string");
			setString("username", "davidfarrell");
			trackItem("email", "string");
			setString("email", "dfarrell@davidlearnsgames.com");
			
		}
		
		public function trackItem( item : String, type : String = "number") : void {
			var object : Object = new Object();
			if ( type == "number" ) {
				object.item = item;
				object.value = 0;
				trackedItems.push(object);
			} else if ( type == "string" ) {
				object.item = item;
				object.value = "";
				trackedItems.push(object); 
			}
		}
		
		public function increment(item : String, quantity : Number = 1) : void {
			for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				var itemString : String = trackedItem.item as String;
				if (trackedItem.item == item ) {
					trackedItems[i].value += quantity;
				}
			}
		}
		
		public function decrement(item : String, quantity : Number = 1) : void {
			for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					trackedItems[i].value -= quantity;
				}
			}
		}
		
		public function setString(item : String, value : String) : void {
			 for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					trackedItems[i].value = value;
				}
			}
		}
		
		public function setValue(item : String, value : Number) : void {
			for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					trackedItems[i].value = value;
				}
			}
		}
		
		public function getValue(item : String) : Number {
				for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					return trackedItems[i].value;
				}
			}
			return 0;
		}
		
		public function getString(item : String) : String {
				for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
				if ( trackedItem.item == item ) {
					return trackedItems[i].value;
				}
			}
			return null;
		}
		
		public function serialize() : String {
			
			for ( var i : Number = 0; i < trackedItems.length; i++) {
				var trackedItem : Object = trackedItems[i];
			//	trace ("Name of tracked variable" + trackedItem["item"] + " and value " + trackedItem["value"]);
			}
			
			//trace ( JSON.encode(trackedItems)); 
			
			return com.adobe.serialization.json.JSON.encode(trackedItems);
		}
		
		public function report() : void {
			FlxG.log("Stats Output:");
			for ( var i : Number = 0; i < trackedItems.length; i++) {
				var item : Object = trackedItems[i];
				FlxG.log("     ["+item.item+"]["+item.value+"]");
				
			}
		}
		
		public function submitStats() : void {
			var submitVars : String = serialize();
			var url : String = "http://falconhoof.heroku.com/api/v1/report";
			
			var submitData : URLVariables = new URLVariables();
			
			for ( var i : Number = 0; i < trackedItems.length; i++) {
				var object : Object = trackedItems[i];
				submitData[object.item] = object.value;
			}

/*
curl -d "username=davidfarrell&email=dfarrell@davidlearnsgames.com&score=10&explosions=4&death=5&trees=4" http://falconhoof.heroku.com/api/v1/report
			*/
			
			var request:URLRequest = new URLRequest(url);
			request.method = "POST";
			request.data = submitData;
			FlxG.log("sendToURL: " + request.url + "?" + request.data);
			try {
				var urlLoader : URLLoader = new URLLoader(request);
				//urlLoader.addEventListener("complete", receiveUserScore, false, 0, true);
			}
			catch (e:Error) {
				// handle error here
				FlxG.log ("error! id:[" + e.errorID + "] name["+e.name+"] message["+e.message+"] stack["+e.getStackTrace+"]");
			}
			
			
		}
	}
}