package org.sunlightlabs.ClearMaps
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class ProgressIndicatorStack extends Sprite
	{
		public static const READY:int = 1;
		public static const LOADING:int = 2;
		public static const FAILED:int = 3;
		
		public var state:int = ProgressIndicatorStack.READY;
		
		private var indicators:Array = new Array();
		
		private var activeIndicators:Array = new Array();
		
		public function ProgressIndicatorStack()
		{
			super();
			
			var titleTextField:TextField = new TextField();
			titleTextField.embedFonts = true;
			titleTextField.text = "Loading...";
			
			titleTextField.setTextFormat(new TextFormat("mapFont", 12));
			
			this.addChild(titleTextField);
			
			this.graphics.lineStyle(0.1, 0xcccccc);
			this.graphics.moveTo(0,17);
			this.graphics.lineTo(150,17);
			
			
			this.visible = false;
		}
		
		public function addIndicator(indicator:ProgressIndicator):void
		{
			indicators.push(indicator);
			
			indicator.addEventListener(ProgressIndicatorEvent.STARTING, progressStarting);
			indicator.addEventListener(ProgressIndicatorEvent.FINSHED, progressFinished);
			indicator.addEventListener(ProgressIndicatorEvent.FAILED, progressFailed);
		}
		
		
		public function progressStarting(event:ProgressIndicatorEvent):void
		{
			this.state = ProgressIndicatorStack.LOADING;
			
			this.visible = true;
			var indicatorOffset:int = 20;
			
			for each(var indicator:ProgressIndicator in this.activeIndicators)
			{
				indicatorOffset += 15;
			}
			
			event.progressIndicator.y = indicatorOffset;
			
			this.activeIndicators.push(event.progressIndicator)
			this.addChild(event.progressIndicator);
		}
		
		
		public function progressFinished(event:ProgressIndicatorEvent):void
		{
			var position:int = 0;
			for each(var indicator:ProgressIndicator in this.activeIndicators)
			{
				if(indicator == event.progressIndicator)
					this.activeIndicators.splice(position, 1);
				
				position++;			
			}
			
			if(this.activeIndicators.length == 0)
			{
				this.visible = false;
				this.state = ProgressIndicatorStack.READY;
			}
		}
		
		public function progressFailed(event:ProgressIndicatorEvent):void
		{
			// TBD - handle failed state 
			
			this.state = ProgressIndicatorStack.FAILED;
		}
		
	}
}