
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	
	public var map:Map = new Map();
	
	public var shapefiles:Array = new Array();
	public var shapeBounds:Rectangle = new Rectangle();

	public var dataEditor:DataEditor;
	public var exportDialog:ExportDialog;


	public function init():void
	{
		this.mapCanvas.rawChildren.addChild(map);
		
		
	}


	public function loadShapefile():void
	{
		var shapefile:Shapefile = new Shapefile();
		
		shapefile.addEventListener(ShapefileEvent.SHAPEFILE_LOADED, updateShapefiles);
		shapefile.addEventListener(ShapefileEvent.SHAPEFILE_CANCELED, cancelLoad);
		 	
		shapefiles.push(shapefile);
		
		shapefile.loadFile();
	}
	
	public function cancelLoad(event:ShapefileEvent):void
	{	
		// file load canceled - pop off the last item in the list 
		shapefiles.pop()
	}
	
	public function updateShapefiles(event:ShapefileEvent):void
	{
		this.map.reset();
		
		var firstShapefile:Boolean = true;
		
		for each(var shapefile:Shapefile in shapefiles)
		{
			if(firstShapefile)
				shapeBounds = shapefile.bounds;
			else
				shapeBounds.union(shapefile.bounds);
		}
		
		for each(var shapefile1:Shapefile in shapefiles)
		{
			shapefile1.translateData(shapeBounds, 800, 800);
			
			var layer:Layer = new Layer();
			
			layer.outline = 0xffcccc;
			layer.fill = 0xccccff;
			
			layer.data = shapefile.layerData;
			
			map.addLayer(layer);
		}
		
		
		map.draw();
	}
	
	
	public function editDataField():void
	{
		dataEditor = new DataEditor();
		
		dataEditor.addEventListener(CloseEvent.CLOSE, closeDataEditor);
		
		PopUpManager.addPopUp(dataEditor, this, true);
		PopUpManager.centerPopUp(dataEditor);
	}
	
	
	public function closeDataEditor(event:Event):void
	{
		PopUpManager.removePopUp(dataEditor);
	}
	
	public function exportMapfiles():void
	{
		updateShapefiles(null);
		
		
		exportDialog = new ExportDialog();
		
		exportDialog.addEventListener(CloseEvent.CLOSE, closeExportDialog);
		
		PopUpManager.addPopUp(exportDialog, this, true);
		PopUpManager.centerPopUp(exportDialog);
		
		
		
		//shapefiles[0].saveFile();
		
		for each(var shapefile:Shapefile in shapefiles)
		{
			
		}
	}
	
	public function closeExportDialog(event:Event):void
	{
		PopUpManager.removePopUp(exportDialog);
	}
	
	
	
		

