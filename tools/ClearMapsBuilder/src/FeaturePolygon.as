package
{
	public class FeaturePolygon extends Feature
	{
		public var elements:Array = new Array();
		
		public function FeaturePolygon()
		{
			
		}
		
		
		public override function draw():void
		{
			this.graphics.clear();
			
			for each(var element:Array in elements)
			{
				this.graphics.lineStyle(1, this.line);
				
				if(this.selected)
					this.graphics.beginFill(0xcfb862);
				else
					this.graphics.beginFill(this.fill, this.fillAlpha);
				
				var firstPoint:Boolean = true;
				
				for each(var p:Object in element) 
				{
					if (firstPoint) 
						this.graphics.moveTo(p.x,p.y);
					else
						this.graphics.lineTo(p.x,p.y);
					
					firstPoint = false;				
				}
				
				this.graphics.endFill();
            }
  		}
	}
}