package org.sunlightlabs.ClearMaps
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class LoadableSprite extends Sprite
	{
		public static const LOADER_PENDING:int = 0;
		public static const LOADER_LOADING:int = 1;
		public static const LOADER_FINISHED:int = 2;
		public static const LOADER_FAILED:int = 3;
		
		public var status:int = LoadableSprite.LOADER_PENDING;
		
		public var title:String;
		
		public var url:String;
		
		public var rawData:Object;
		
		public var postProcessFunction:Function;
		
		public var progressIndicator:ProgressIndicator;
		
		public var format:String = URLLoaderDataFormat.BINARY;
		
		public function LoadableSprite(title:String, url:String)
		{
			this.title = title;
			this.url = url;
			
			progressIndicator = new ProgressIndicator(this.title);
		}
		
		public function loadData(url:String):void
		{
			if(this.status != LoadableSprite.LOADER_LOADING)
			{
				this.status = LoadableSprite.LOADER_LOADING;
				
				var layerRequest:URLRequest = new URLRequest(url);
			
				var layerLoader:URLLoader = new URLLoader();
				layerLoader.dataFormat = format;
				
				layerLoader.addEventListener(Event.COMPLETE, finished);
				layerLoader.addEventListener(ProgressEvent.PROGRESS, progress);
				layerLoader.addEventListener(IOErrorEvent.IO_ERROR, failed);
				
				
				
				try 
	            {
	            	progressIndicator.start();
	                layerLoader.load(layerRequest);
	            } 
	            catch (error:Error) 
	            {
	                trace("Unable to load requested document.");
	            }	
			}
		}
		
		
		public function finished(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			
			this.rawData = loader.data;
		
			if(this.postProcessFunction != null)
				this.postProcessFunction();
			
			this.status = LoadableSprite.LOADER_FINISHED;
		
			this.progressIndicator.finish();
		}
		
		public function progress(event:ProgressEvent):void
		{
			this.progressIndicator.update(event.bytesLoaded / event.bytesTotal);
		}
		
		public function failed(event:Event):void
		{
			this.status = LoadableSprite.LOADER_FAILED;
			
			this.progressIndicator.fail();
		}

	}
}