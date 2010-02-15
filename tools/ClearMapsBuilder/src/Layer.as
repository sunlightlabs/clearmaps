package
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class Layer extends Sprite
	{
		public static const LAYER_POINT:int = 1;
		public static const LAYER_POLYLINE:int = 2;
		public static const LAYER_POLYGON:int = 3;
		
		public var data:LayerData;
		
		public var features:Dictionary = new Dictionary();
		
		public var fill:uint;
		public var outline:uint;
		public var outlineThicknes:int;
		
		public var selectable:Boolean;
		
		public var preDraw:Function;
		public var hover:Function;
		
		
		public function Layer()
		{
			super();
		}
		
		public function draw():void
		{
			for each(var record:Object in data.records)
			{
				if(!this.features.hasOwnProperty(record.id))
				{
					if(data.type == LayerData.SHAPE_POINT)
					{
						var featurePoint:FeaturePoint = new FeaturePoint();
						featurePoint.xPoint = record.xPoint;
						featurePoint.yPoint = record.yPoint;
				
						this.features[record.id] = featurePoint
						
					} 
					else if(data.type == LayerData.SHAPE_POLYGON)
					{
						var featurePolygon:FeaturePolygon = new FeaturePolygon();
						featurePolygon.elements = record.elements;
					
						this.features[record.id] = featurePolygon
					} 
					else if(data.type == LayerData.SHAPE_POLYLINE)
					{
						var featurePolyline:FeaturePolyline = new FeaturePolyline();
						featurePolyline.elements = record.elements;
					
						this.features[record.id] = featurePolyline
					} 
				}
			
				
					
					
				
			}
			
			for each(var feature:Feature in features)
			{
				if(!this.contains(feature))
					this.addChild(feature);
				
				feature.draw();	
			}
		}
	}
}