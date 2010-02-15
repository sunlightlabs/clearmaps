package
{
	public class FeaturePolyline extends Feature
	{
		public var elements:Array = new Array();
		
		public function FeaturePolyline()
		{
	
		}
		
		public override function draw():void
		{
			this.graphics.clear();
					
			for each(var element:Array in elements)
			{
				this.graphics.lineStyle(3, 0x50B048);
				
				var firstPoint:Boolean = true;
				
				for each(var p:Object in element) 
				{
					if (firstPoint) 
						this.graphics.moveTo(p.x,p.y);
					else
						this.graphics.lineTo(p.x,p.y);
						
					firstPoint = false;				
				}
			
            }
  		}
		
	}
}