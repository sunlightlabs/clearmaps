// ActionScript file

	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;

	public function init():void
	{
		var data:ArrayCollection  = new ArrayCollection ();
		
		for each(var shapefile:Shapefile in Application.application.shapefiles)
		{
			var item:Object = new Object();
			item.label = shapefile.name;
			item.data = shapefile;
			
			data.addItem(item);
		}
		
		this.layerSelector.dataProvider = data;
		layerSelected();
	}
	
	public function layerSelected():void
	{
		this.fieldDataGrid.dataProvider = Shapefile(this.layerSelector.selectedItem.data).dataFields;
	}