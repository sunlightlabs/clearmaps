package org.sunlightlabs.ClearMaps
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class LayerData 
	{	
		public static const SHAPE_POINT:int = 1;
		public static const SHAPE_POLYLINE:int = 3;
		public static const SHAPE_POLYGON:int = 5;
		
		public var type:int;
		
		public var name:String;
		
		public var features:Dictionary = new Dictionary();
		
		
		public function LayerData()
		{
		}
		
		public static function encode(data:LayerData):ByteArray 
		{
			var bytes:ByteArray = new ByteArray();	
			bytes.writeObject(data);
			bytes.compress();
			bytes.position = 0;

			return bytes;
		}
		
		public static function decode(bytes:ByteArray):Object
		{
			bytes.position = 0;
			bytes.uncompress();

			return bytes.readObject();	
		}

	}
}