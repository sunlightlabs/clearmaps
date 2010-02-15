
	import mx.collections.ArrayCollection;
	import mx.core.Application;

	public function init():void
	{
		var data:ArrayCollection  = new ArrayCollection ();
		
		for each(var shapefile:Shapefile in Application.application.shapefiles)
		{
			data.addItem(shapefile);
		}
		
		this.layerList.dataProvider = data;
	}
	
	public function exportLayer():void
	{
		if(this.layerList.selectedItem)
		{
			Shapefile(this.layerList.selectedItem).saveFile();
		}
	}
	
	public function selectionChanged():void
	{
		if(this.layerList.selectedItem)
		{
			exportButton.enabled = true
		}
		else
		{
			exportButton.enabled = false
		}
	}