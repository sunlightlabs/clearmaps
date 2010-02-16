package org.sunlightlabs.ClearMaps
{
	import com.adobe.serialization.json.JSONDecoder;
	
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	
	public class Data extends LoadableSprite
	{
		public static const IMPORT_FORMAT_CSV:int = 1;
		public static const IMPORT_FORMAT_TAB:int = 2;
		public static const IMPORT_FORMAT_JSON:int = 3;
		public static const IMPORT_FORMAT_XML:int = 4;
		
		public var importFormat:int = Data.IMPORT_FORMAT_CSV;
		
		public var data:Object;
		
		public function Data(title:String, url:String, importFormat:int)
		{
			super(title, url);
			
			this.progressIndicator = new ProgressIndicator(this.title);
			this.format = URLLoaderDataFormat.TEXT;
			this.importFormat = importFormat;
			
			this.postProcessFunction = postProcessData;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function addedToStage(even:Event):void
		{
			this.loadData(url);
		}
		
		
		public function postProcessData():void
		{
			switch(this.importFormat)
			{
				case Data.IMPORT_FORMAT_CSV:
					this.data = parseDelimitedText(String(this.rawData), ",");
					break;
					
				case Data.IMPORT_FORMAT_TAB:
					this.data = parseDelimitedText(String(this.rawData), "\t");
					break;
					
				case Data.IMPORT_FORMAT_JSON:
					this.data = JSONDecoder(this.rawData);
					break;
					
				case Data.IMPORT_FORMAT_XML:
					this.data = new XML(this.rawData);
					break;
			}
			
			var dataEvent:DataEvent = new DataEvent(DataEvent.LOADED);
			dataEvent.data = this;
			this.dispatchEvent(dataEvent);
		}
		
		public function parseDelimitedText(rawData:String, delimiter:String):Array
		{
			// currently a dumb split, does not escape characters inside quotes, etc.
				
			var parsedData:Array = new Array();
			var fields:Array = new Array();		 
			
			var rows:Array = rawData.split(/\r\n|\r|\n/);
			
			for each(var row:String in rows)
			{
				var cols:Array = row.split(delimiter);
				
				parsedData.push(cols);
			}
			
			return parsedData;
		}
	}
}