package org.sunlightlabs.ClearMaps
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class ProgressIndicator extends Sprite
	{
		private var numBoxes:int = 19;
		private var boxSize:int = 4;
		
		private var maxTitleWidth = 50;
		
		private var title:String;
		
		private var titleTextField:TextField;
		
		public function ProgressIndicator(title:String)
		{
			super();
			
			this.title = title;
			
			titleTextField = new TextField();
			titleTextField.embedFonts = true;
			titleTextField.text = this.title;
			
			titleTextField.setTextFormat(new TextFormat("mapFont", 10));
			
			this.addChild(titleTextField);
		}
		
		public function start():void
		{	
			var startEvent:ProgressIndicatorEvent = new ProgressIndicatorEvent(ProgressIndicatorEvent.STARTING);
           	startEvent.progressIndicator = this;
            this.dispatchEvent(startEvent);
              
		}
		
		public function update(precent:Number):void
		{
			var boxes:int = Math.round(numBoxes * precent);
			
			this.graphics.clear();

			for(var i = 1; i <= boxes; i++)
			{
				this.graphics.beginFill(0x0000cc, 0.5);
				this.graphics.drawRect(maxTitleWidth + (i * (this.boxSize + 1)), Math.round(titleTextField.textHeight / 2), this.boxSize, this.boxSize);
				this.graphics.endFill(); 
			}
		}
		
		public function finish():void
		{			
			var finishEvent:ProgressIndicatorEvent = new ProgressIndicatorEvent(ProgressIndicatorEvent.FINSHED);
           	finishEvent.progressIndicator = this;
            this.dispatchEvent(finishEvent);
		}
		
		public function fail():void
		{
			this.graphics.clear();

			var failureTextField = new TextField();
			failureTextField.embedFonts = true;
			failureTextField.text = "Failed";
			
			failureTextField.setTextFormat(new TextFormat("mapFont", 10, 0xcc0000));
			
			failureTextField.x = maxTitleWidth;
			
			this.addChild(failureTextField);
			
			var finishEvent:ProgressIndicatorEvent = new ProgressIndicatorEvent(ProgressIndicatorEvent.FINSHED);
           	finishEvent.progressIndicator = this;
            this.dispatchEvent(finishEvent);
		}
		
	}
}