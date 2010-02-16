package {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import org.sunlightlabs.ClearMaps.*;

	[SWF(width="700", height="500", backgroundColor="#ffffff", frameRate="15")]
	public class DemoMap extends Sprite
	{	
		// optionally using an embedded font to imporove rendering flexibliltiy
		// the library currently expects the "mapFont" font family to be defined
		[Embed(source="assets\\sans_between.ttf", fontFamily="mapFont")]
		private var SansBetween:Class;
		
		// the Map object manages layers and data
		public var map:Map;
		
		// the Layer objects are tied to a specific .map file containing the vector and attribute data
		public var stateLayer:Layer;		
		public var countyLayer:Layer;
		
		// lable for map data source
		public var sourceTextField:TextField; 
		
		// MapData objects contain data contained in CSV, XML or JSON data sources
		// this data can be bound to the map at display time 
		public var rawData:Data;
		
		public var countyPoveryData:Dictionary = new Dictionary();
		
		public function DemoMap()
		{
			super();
			
			// give the map a title 
			this.map = new Map("Percentage of Population Below Poverty");
			
			// listen for map ready event to process/visualize data
			this.map.addEventListener(MapEvent.READY, mapReady);
			
			// repeat for the county layer 
			this.countyLayer = new Layer("Counties", "http://assets.sunlightlabs.com/maps/layers/counties.map");
			
			// set the default rendering styles 
			this.countyLayer.outline = 0xcccccc;
			this.countyLayer.fill = 0xffffff;
			this.countyLayer.fillSelected = 0xccccff;
			
			// selectable layers have hover events
			this.countyLayer.selectable = true;
			
			// turn on tooltips -- tooltipText must be set for each feature
			this.countyLayer.tooltip = true;
			
			// set the callback for hover
			this.countyLayer.hover = countyHover;
			
			
			// add the layers to the map
			// when the layer is attached to the application it will automatically load the data and render itself
			this.map.addLayer(countyLayer);
			
			
			// create a layer, giving a title and a url to the data  
			this.stateLayer = new Layer("States", "http://assets.sunlightlabs.com/maps/layers/states.map");
			
			// set the default rendering styles 
			this.stateLayer.outline = 0xaaaaaa;
			this.stateLayer.fill = null;
			this.stateLayer.selectable = false;
			
			// add the state layer second to put the outlines on top 
			this.map.addLayer(stateLayer);
	
		
			// create data layer, giving a title, url and format
			this.rawData = new Data("Data", "http://assets.sunlightlabs.com/maps/data/counties_poverty.txt", Data.IMPORT_FORMAT_TAB);
			
			// data data layer to map 
			this.map.addData(this.rawData);
			
			// finally add the map to the application, attaching to stage triggers data loading 
			this.addChild(map);
		}
		
		
		public function mapReady(event:MapEvent):void
		{
			// process data once the map is ready!
			
			// create dictionary of county data containing state and county FIPS codes 
			// the FIPS codes are also in the data attributes for the counties map layer
			
			for each(var d:Object in rawData.data)
			{
				try
				{
					// convert FIPS values to integers 
					var stateFips:int = int(d[0]);
					var countyFips:int = int(d[1]);
					
					// convert poverty value to a decimal percent 
					var value:Number = Number(d[2]) / 100;
					
					// initalize the dictionary for county data 
					if(!this.countyPoveryData[stateFips])
						this.countyPoveryData[stateFips] = new Dictionary();
						
					// store the county value
					this.countyPoveryData[stateFips][countyFips] = value;
				}
				catch(e:Error)
				{
					// can't parse data
				}
			}
			
			// iterate the features and match the
			for each(var f:Feature in this.countyLayer.features)
			{
				// set rendering paramaters for each feature based on the data
				if(this.countyPoveryData[f.data.state] && this.countyPoveryData[f.data.state][f.data.county])
				{
					// percent poverty is encoded as the alpha
					f.alpha =  this.countyPoveryData[f.data.state][f.data.county];
					
					// make fill red
					f.fill = 0xcc0000;
					
					// generate tooltip text
					f.tooltipText = String(f.data.name).replace(/(\t|\n|\s{2,})/g, '') + ' County\n' + String(Math.round(this.countyPoveryData[f.data.state][f.data.county] * 100)) + '%';
				}
				else
					// for features without data set fill color to gray
					f.fill = 0xcccccc;
			}
			
			// re-draw the layer with the the data
			this.countyLayer.draw();
			
			
			
			// add a source label to the map
			if(!this.sourceTextField)
			{
				this.sourceTextField = new TextField();
				this.sourceTextField.embedFonts = true;
				this.sourceTextField.text = "Source: U.S. Census Bureau Small Area Income & Poverty Estimates for 2008.";
				this.sourceTextField.autoSize = TextFieldAutoSize.RIGHT;
				this.sourceTextField.setTextFormat(new TextFormat("mapFont", 10, 0x000000, false));
			
				this.sourceTextField.x = this.stage.width - this.sourceTextField.width;
				this.sourceTextField.y = this.stage.height + 25; // - this.sourceTextField.height;
				
				
				this.addChild(this.sourceTextField);
			}
		}
		
		public function countyHover(f:Feature):void
		{
			// this function is called on hover events
		}
	}
}











