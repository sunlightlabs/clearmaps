package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;


	public class Feature extends Sprite
	{
		
		protected var selected:Boolean = false;
		
		protected var layer:Layer;
		
		public var data:FeatureData;
		
		public var line:uint = 0;
		public var fill:uint = 0;
		public var fillAlpha:Number = 0;
		
		
		
		public var infoTip:Sprite;
		
		public function Feature():void
		{
//			data = d;
//			elements.push(d.rings);
//			
//			if(map.selectable)
//				this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
		}
		
		
		
		public function mouseOver(event:MouseEvent):void
		{
			event.stopPropagation();
			this.stage.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			selected = true;
			
			//this.map.hover(this, event);
			
		}
		
		public function mouseOut(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			
			selected = false;
			
			if(infoTip && this.stage.contains(infoTip))
				this.stage.removeChild(infoTip);
			
			this.draw();
		}
		
		
		public function draw():void
		{
			
		}
	}	

}