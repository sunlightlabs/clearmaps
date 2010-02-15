package org.sunlightlabs.ClearMaps
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
			
				if(this.selected)
					this.graphics.lineStyle(1, this.outlineSelected);
				else
					this.graphics.lineStyle(1, this.outline);
				
				if(this.selected)
				{
					if(this.fillSelected)
						this.graphics.beginFill(this.fillSelected);
				}
				else
				{
				 	if(this.fill)
						this.graphics.beginFill(this.fill);
				}
				
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