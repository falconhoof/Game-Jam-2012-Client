package 
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Sprite;
	
	
	public class StatsTracker extends Sprite
	{
		private var trackedItems : Array;
		
		public function StatsTracker()
		{
			trackedItems = new Array();
		}
		
		public function trackItem( item : String, type : String = "number") : void {
			if ( type == "number" ) {
				var object : Object = new Object();
				object.item = item;
				object.value = 0;
				trackedItems.push(object);
			} else if ( type == "string" ) {
				var object : Object = new Object();
				object.item = item;
				object.value = "";
				trackedItems.push(object); 
			}
		}
		
		public function increment(item : String, quantity : Number = 1) : void {
			for ( var i : Number = 0; i < trackedItems.length; i++ ) {
				var trackedItem : Object = trackedItems[i];
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
			
			return JSON.encode(trackedItems);
		}
	}
}