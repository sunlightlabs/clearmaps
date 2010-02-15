package org.sunlightlabs.ClearMaps
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
				if(this.selected)
					this.graphics.lineStyle(this.outlineThicknes, this.outlineSelected);
				else
					this.graphics.lineStyle(this.outlineThicknes, this.outline);
				
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