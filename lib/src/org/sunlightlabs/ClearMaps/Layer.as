package org.sunlightlabs.ClearMaps
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class Layer extends LoadableSprite
	{
		public static const LAYER_POINT:int = 1;
		public static const LAYER_POLYLINE:int = 2;
		public static const LAYER_POLYGON:int = 3;
		

		public var features:Dictionary = new Dictionary();
		
		public var selectedFeature:Feature;
		
		public var data:Object;
		
		public var fill:Number;
		public var fillSelected:Number;
		
		public var outline:Number;
		public var outlineSelected:Number;
		public var outlineThicknes:Number;
		
		public var selectable:Boolean;
		public var tooltip:Boolean;
		
		public var dataMapper:Function;
		public var hover:Function;
		
		
		public function Layer(title:String, url:String)
		{
			super(title, url);
				
			this.postProcessFunction = postProcessData;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function addedToStage(even:Event):void
		{
			this.loadData(url);
		}
		
		public function postProcessData():void
		{
			this.data = LayerData.decode(ByteArray(this.rawData)); 	
		}
		
		
		public function selectFeature(currentSelection:Feature):void
		{
			if(this.selectedFeature)
				this.selectedFeature.selected = false;
			
			if(currentSelection)
			{
				currentSelection.selected = true;
				
				this.selectedFeature = currentSelection;
				
				// ensure that selection is on top
				this.removeChild(this.selectedFeature);
				this.addChild(this.selectedFeature);
				
				// call the hover callbakc, if set
				if(this.hover != null)
					this.hover(this.selectedFeature)
			}
		}
		
		public function selectFeatureById(id:int):void
		{
			selectFeature(features[id]);
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
						featurePoint.id = record.id;
						featurePoint.xPoint = record.xPoint;
						featurePoint.yPoint = record.yPoint;
						
						featurePolygon.data = record;
				
						featurePoint.layer = this;
				
						this.features[record.id] = featurePoint
						
					} 
					else if(data.type == LayerData.SHAPE_POLYGON)
					{
						var featurePolygon:FeaturePolygon = new FeaturePolygon();
						featurePolygon.id = record.id;
						featurePolygon.elements = record.elements;
						
						featurePolygon.data = record;
					
						featurePolygon.layer = this;
					
						this.features[record.id] = featurePolygon
					} 
					else if(data.type == LayerData.SHAPE_POLYLINE)
					{
						var featurePolyline:FeaturePolyline = new FeaturePolyline();
						featurePolyline.id = record.id;
						featurePolyline.elements = record.elements;
						
						featurePolygon.data = record;
					
						featurePolyline.layer = this;
					
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
