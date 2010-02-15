package org.sunlightlabs.ClearMaps
{
	import flash.events.Event;

	public class DataEvent extends Event
	{
		public static const LOADED:String = "DataEvent_loaded";
		
		public var data:Data;
		
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}