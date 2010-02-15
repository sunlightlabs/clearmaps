package org.sunlightlabs.ClearMaps
{
	import flash.events.Event;

	public class ProgressIndicatorEvent extends Event
	{
		public static const STARTING:String = "ProgressIndicatorEvent_starting";
		public static const FINSHED:String = "ProgressIndicatorEvent_finished";
		public static const FAILED:String = "ProgressIndicatorEvent_failed";
		
		public var progressIndicator:ProgressIndicator;
		
		public function ProgressIndicatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}

