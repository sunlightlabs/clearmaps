package org.sunlightlabs.ClearMaps
{
	public class FeaturePoint extends Feature
	{
		public var xPoint:Number;
		public var yPoint:Number;
		
		public function FeaturePoint()
		{
		}
		
		public override function draw():void
		{
			this.graphics.clear();
			
			this.graphics.beginFill(this.fill)
			this.graphics.drawCircle(xPoint, yPoint, this.outlineThicknes);
			this.graphics.endFill()
  		}
		
	}
}