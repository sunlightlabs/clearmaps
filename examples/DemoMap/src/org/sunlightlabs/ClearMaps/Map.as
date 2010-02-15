package org.sunlightlabs.ClearMaps
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Map extends Sprite
	{
		private var layersSprite:Sprite = new Sprite();
		
		private var layers:Array = new Array();
		
		private var data:Data;
		
		private var progressStack:ProgressIndicatorStack;
		
		
		
		public function Map(title:String)
		{
			super();
			
			this.progressStack = new ProgressIndicatorStack()
			
			this.layersSprite.scaleX = 0.75;
			this.layersSprite.scaleY = 0.75;
			
			this.addChild(layersSprite);
			this.addChild(progressStack);
			
			
			var titleTextField:TextField = new TextField();
			titleTextField.embedFonts = true;
			titleTextField.text = title;
			titleTextField.autoSize = TextFieldAutoSize.RIGHT;
			titleTextField.setTextFormat(new TextFormat("mapFont", 18, 0x000000, true));
			titleTextField.x = 700 - titleTextField.width; 
			
			this.addChild(titleTextField);
		}
		
		public function reset():void
		{
			for each(var layer:Layer in this.layers)
			{
				if(this.contains(layer))
					this.removeChild(layer);
			}
			
			this.layers = new Array();
			
			if(this.progressStack)
			{
				if(this.contains(this.progressStack))
					this.removeChild(this.progressStack);
				
				this.progressStack = new ProgressIndicatorStack();
			}
		}
		
		public function draw():void
		{
			for each(var layer:Layer in layers)
			{
				if(layer.status == LoadableSprite.LOADER_FINISHED)
					layer.draw();
			}
		}
		
		public function addLayer(layer:Layer):void
		{	
			layer.progressIndicator.addEventListener(ProgressIndicatorEvent.FINSHED, progressFinished);
			
			if(this.progressStack)
				this.progressStack.addIndicator(layer.progressIndicator);
			
			this.layers.push(layer);
			
			this.layersSprite.addChild(layer);
		}
		
		public function addData(data:Data):void
		{
			data.progressIndicator.addEventListener(ProgressIndicatorEvent.FINSHED, progressFinished);
			
			if(this.progressStack)
				this.progressStack.addIndicator(data.progressIndicator);
			
			this.data = data;
			
			this.addChild(this.data);
		}
		
		public function progressFinished(event:ProgressIndicatorEvent):void
		{
			var mapReady:Boolean = true;
			
			draw();
			
			for each(var layer:Layer in layers)
			{
				if(layer.status != LoadableSprite.LOADER_FINISHED)
					mapReady = false;
			}
			
			if(this.data)
			{
				if(this.data.status != LoadableSprite.LOADER_FINISHED)
					mapReady = false;
			}
			
			if(mapReady)
			{
				var mapReadyEvent:MapEvent = new MapEvent(MapEvent.READY);
				this.dispatchEvent(mapReadyEvent);
			}
		}
	}
}