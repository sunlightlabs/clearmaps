package
{
	import flash.events.Event;

	public class ShapefileEvent extends Event
	{
		public static const SHAPEFILE_LOADED:String = "ShapefileLoadedEvent";
		public static const SHAPEFILE_CANCELED:String = "ShapefileCanceledEvent";
		
		public function ShapefileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}	