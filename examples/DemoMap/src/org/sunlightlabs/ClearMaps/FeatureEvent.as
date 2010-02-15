package org.sunlightlabs.ClearMaps
{
	import flash.events.Event;

	public class FeatureEvent extends Event
	{
		public static const FEATURE_SELECTED:String = "featureSelected";
		
		public var feature:Feature;
	
		public function FeatureEvent(type:String, f:Feature, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.feature = f;
		}
		
	}
}