package
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
			
			this.graphics.beginFill(0x447BD2)
			this.graphics.drawCircle(xPoint, yPoint, 5);
  		}
		
	}
}