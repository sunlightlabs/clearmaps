package org.sunlightlabs.ClearMaps
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.*;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import org.vanrijkom.dbf.*;
	import org.vanrijkom.shp.*;
	
	
	public class Shapefile extends EventDispatcher 
	{
		public static const SHAPE_POINT:int = 1;
		public static const SHAPE_POLYLINE:int = 3;
		public static const SHAPE_POLYGON:int = 5;
		
		
		public var layer:Layer;
		public var layerData:LayerData;
		
		public var shpSize:uint;
		public var dbfSize:uint;
		public var encodedSize:uint;
		
		public var shpHeader:ShpHeader;
		public var dbfHeader:DbfHeader;
		
		public var shpData:Array;
		public var dbfData:ByteArray;
		
		public var dataFields:Array;
	
		public var bounds:Rectangle;

		public var xOffset:Number;
		public var yOffset:Number;
		
		public var scale:Number;
		
		public var maxHeight:Number;
		public var maxWidth:Number;
		
		public var invert:Boolean = true;
		
		public var errors:Array;

		public var shapeType:int;
		
		public var name:String;
		
		public function Shapefile()
		{
			
		}
		
		public function loadFile():void
		{
			var fileToOpen:File = new File();
			var txtFilter:FileFilter = new FileFilter("Shapefile", "*.shp");
			
			var shapefile:Shapefile = this;
			
			try 
			{
			    fileToOpen.browseForOpen("Open", [txtFilter]);
			    fileToOpen.addEventListener(Event.SELECT, fileSelected);
			    fileToOpen.addEventListener(Event.CANCEL, fileSelectionCanceled);
			}
			catch (error:Error)
			{
			    trace("Failed:", error.message);
			}
			
			function fileSelectionCanceled(event:Event):void
			{
				var cancelEvent:ShapefileEvent = new ShapefileEvent(ShapefileEvent.SHAPEFILE_CANCELED);
				
				shapefile.dispatchEvent(cancelEvent);
			}
			
			function fileSelected(event:Event):void 
			{
			    var shp_fs:FileStream = new FileStream();
			    shp_fs.open(File(event.target), FileMode.READ);
			    
			    var dbf_path:String = File(event.target).nativePath;
			   
			   
			    var path_parts:Array = dbf_path.split(".");
			    
			    dbf_path = path_parts[0] + "." + "dbf";
			    
			    shapefile.name = File(event.target).name.split(".")[0];
			    
			    var dbf_fs:FileStream = new FileStream();
			    
			    try
			    {
			    	dbf_fs.open(new File(dbf_path), FileMode.READ);
			    }
			    catch (errror:Error)
			    {
			    	throw(new Error("Unable to open DBF.")); 
			    }
			   
			   	var dbf:ByteArray = new ByteArray();
				var shp:ByteArray = new ByteArray();
			   
			   	shp_fs.readBytes(shp);
			   	dbf_fs.readBytes(dbf);
			   	
			   	loadData(dbf, shp);	
			}
		}
		
		public function loadData(dbf:ByteArray, shp:ByteArray):void
		{				
			dbfSize = dbf.length;
			shpSize = shp.length;
			
			dbfHeader = new DbfHeader(dbf);
	        shpHeader = new ShpHeader(shp);
	        
	        bounds = shpHeader.boundsXY;
	        
	        shpData = ShpTools.readRecords(shp);
	       	dbfData = dbf;
	       	
	       	dataFields = new Array();
	       	
	       	for each(var dbfField:DbfField in dbfHeader.fields)
	       	{
	       		var field:ShapefileDataField = new ShapefileDataField();
	       		field.dbfName = dbfField.name;
	       		field.flashName = dbfField.name.toLowerCase();
	       		field.export = false;
	       		field.dataType = "String";
	       		
	       		dataFields.push(field);
	       	}
	        
	        if(shpHeader.shapeType == SHAPE_POINT || shpHeader.shapeType == SHAPE_POLYLINE || shpHeader.shapeType == SHAPE_POLYGON)
	        	shapeType =  shpHeader.shapeType;
	        else 
	        	throw(new Error("Unhandled shapefile type: " + String(shpHeader.shapeType))); 
	         
	         
	      
	        this.dispatchEvent(new ShapefileEvent(ShapefileEvent.SHAPEFILE_LOADED))
		}
		
		public function translateData(bounds:Rectangle, pixelHeight:int, pixelWidth:int):void
		{
			errors = new Array();
			
			layerData = new LayerData();
			
			layerData.type = this.shapeType;
			
			xOffset = -bounds.left;
			yOffset = -bounds.top;
			
			scale = pixelWidth / bounds.width 	
			
			maxWidth = bounds.width * scale;
			maxHeight = 600;
			
			var featureId:int = 0;
			
			for each(var record:ShpRecord in shpData)
	        {
	        	if(record.shape != null)
	        	{
	        		if(record.shapeType == this.shapeType)
	        		{
	        			var dbfRecord:DbfRecord = DbfTools.getRecord(dbfData, dbfHeader, featureId);
	        			
	        			var data:Object = new Object();
	        			
	        			data.id = featureId;
	        			
	        			for each(var field:ShapefileDataField in dataFields)
	        			{
	        				if(field.export)
	        				{
	        					if(field.dataType == "Integer")
	        					{
	        						try
	        						{
	        							data[field.flashName] = int(dbfRecord.values[field.dbfName]);
	        						}
	        						catch(error:Error)
	        						{
	        							errors.push("Integer conversion failed on '" + field.dbfName + "' for value '" + dbfRecord.values[field.dbfName] + "'.");
	        							data[field.flashName] = null;
	        						}
	        					}
	        					else
	        					{
	        						data[field.flashName] = dbfRecord.values[field.dbfName];
	        					}
	        				}
	        			}
	        			
	        			
	        			if(record.shapeType == Shapefile.SHAPE_POINT)
	        			{	
	        				var point:ShpPoint = ShpPoint(record.shape);
	        				
	        				var newPoint:Object = translatePoint(point);
	        				
	        				data.xPoint = newPoint.x;
	        				data.yPoint = newPoint.y;
	        				
	        				layerData.records.push(data)
	        				
	        			}
	        			else if(record.shapeType == Shapefile.SHAPE_POLYGON || record.shapeType == Shapefile.SHAPE_POLYLINE)
	        			{	
	        				data.elements = new Array();
	        				
	        				var shape:ShpPolygon = ShpPolygon(record.shape);
	        				
	        				for each(var ring:Array in shape.rings)
		        			{
		        				var element:Array = new Array;
		        				var previousPoint:Object;
		        				
		        				for each(var p:ShpPoint in ring)
		        				{
		        					var currentPoint:Object = translatePoint(p)
		        					if(previousPoint && (previousPoint.x != currentPoint.x || previousPoint.y != currentPoint.y))
		        						element.push(currentPoint);
		        					
		        					previousPoint = currentPoint;
		        				}
		        				
		        				data.elements.push(element);
		        			}
		        			
		        			layerData.records.push(data);
	        			}
	        			else 
	        				throw(new Error("Unhandled shape type: " + String(record.shapeType)));
		        	}
		        	else
		        	{
		        		throw(new Error("Shape record does not match Shapefile type."))
		        	} 	
	        	}
	        	
	        	featureId++;
	        }	
	        
	        // calc encoded data size 
	        
	        var encodedLayer:ByteArray = LayerData.encode(layerData);
	        
	        encodedSize =  encodedLayer.length;
	        
		}
		
		public function translatePoint(point:Object):Object
		{
			var newPoint:Object = new Object();
			
			newPoint.x = int((point.x + xOffset) * scale);
			
			if(invert)
	        	newPoint.y = int(-(point.y + yOffset) * scale) + maxHeight;	
	        else
	        	newPoint.y = int((point.y + yOffset) * scale);
	        
	        return newPoint;
		}
		
		public function saveFile():void
		{
			var encodedLayer:ByteArray = LayerData.encode(layerData);
	        
	        var fileReference:FileReference = new FileReference();
	 
	        fileReference.save(encodedLayer,  this.name + ".map");	
		}

	}
}


