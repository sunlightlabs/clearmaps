package org.sunlightlabs.ClearMaps
{
	import flash.events.Event;

	public class MapEvent extends Event
	{
		public static const READY:String = "MapEvent_ready";
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}