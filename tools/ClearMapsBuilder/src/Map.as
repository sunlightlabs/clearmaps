package
{
	import flash.display.Sprite;

	public class Map extends Sprite
	{
		public var layers:Array = new Array();
		
		public function Map()
		{
			super();
		}
		
		public function reset():void
		{
			for each(var layer:Layer in layers)
			{
				if(this.contains(layer))
					this.removeChild(layer);
			}
			
			layers = new Array();
		}
		
		public function draw():void
		{
			for each(var layer:Layer in layers)
			{
				layer.draw();
			}
		}
		
		public function addLayer(layer:Layer):void
		{
			layers.push(layer);
			
			this.addChild(layer);
		}
	}
}