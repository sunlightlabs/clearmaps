#How to create map layers from Shapefiles

As an example this documentation demonstrates the creation of two map layers using the U.S. Census' national state and county boundary files. The state boundary file "st99_d00.shp.zip" is available [here](http://www.census.gov/geo/www/cob/st2000.html). The county boundary file "co99_d00.shp.zip" is available [here](http://www.census.gov/geo/www/cob/co2000.html). This example uses two boundary files encoding polygons, however, ClearMaps also supports Shapefiles containing point and polyline features.

Typically a Shapefile defines a single "layer" of map features. This example contains two layers, one defining the state boundaries and another layer defining counties. These layers are combined when rendered to form a map.  Steps one through four manipulate the layers separately, as Shapefiles. In step five the layers are imported, merged into a common coordinate space and then exported in a special binary format used by the ActionScript renderer. The exported binary layers remain separate, however, so that the smaller state boundary file can be downloaded and rendered while the larger county binary continues to load.

A "Shapefile" is actually a group of files with different extensions sharing a common name. The .shp file is referred to as the Shapefile in this documentation. This is main file that contains the vector data describing the layer's features. The other files referenced in this documentation are the .dbf file, a database file containing attribute information for the features; and the .shx file, an index that helps locate data in the .shp file. The .prj file, included with some Shapefiles, includes metadata about the projection and coordinate system used to describe the vector data.



###Prerequisites: 

This documentation requires a GIS editor such as [Quantum GIS](http://qgis.org/) (open source) or ArcGIS Desktop (commercial). The documentation describes the steps required for Quantum GIS, however, it should be easily adapted to work with any similarly featured editor.

Step five uses the ClearMapsBuilder application included in this project. This application requires the Adobe AIR Runtime. To install the builder, open the "ClearMapsBuilder.air" file contained in the project directory and follow the AIR installation instructions. The installer will warn that the publisher of this application is unknown. Accept this warning and select the installation directory. The builder application can be launched from the installation directory or by clicking on the desktop shortcut created by the installer.



##Step 1: 

After unpacking, the county data Shapefile (co99_d00.shp) weighs in at 13MB and has an additional 700KB of attribute data in the DBF. This is far too big for web delivery. The steps ahead show how to convert the raw data into something small enough to allow for reasonable download times and quick rendering.



##Step 2:

Open the Shapefile in a GIS editor. In this example I use the open source editor Quantum GIS (version 1.3), though any editor capable of exporting selected features and re-projection should work fine. 

Select the region you wish to display. To make a map that shows all fifty states it might make sense to create three separate layers, for Hawaii, Alaska, and the "lower 48." In this example I carved out only the counties in the lower forty-eight states by selecting and exporting that region.

Quantum GIS allows for automatic re-projection of exported Shapefiles. I selected the "Lambert Conic Conformal, Texas Centric" projection while exporting to minimize distortion and improve readability. Choosing the most appropriate projection depends on the area to be displayed.  



##Step 3: 

Even with the unneeded states and territories remove the Shapefile remains almost the same size as the original. To start the process of cutting the file size down a line simplification step is required. This removes detail that is not unnecessary for display at lower resolution. If you are fortunate enough to have access to ArcGIS, the Data Management Toolbox provides several simplification tools that are quite effective. 

There aren't many open source simplification tools and most don't do a good job at simplifying complex geometries with adjoining boundaries. The best free option (though not open source) is [MapShaper](http://mapshaper.com/test/demo.html), created by Matthew Bloch (behind much of the great carto work being done at the New York Times) and Mark Harrower (of Axis Maps). MapShaper has a rather unusual interface -- a web service fronted by a Flex client -- that imposes an unfortunate 80MB file size limit. However for most situations it performs quite well. 

For this example I uploaded the re-projected "lower 48" file and dragged the MapShaper "simplification level" slider to 25%. The higher the simplification levels the higher the space savings at the cost of detail. At 25% I achieved a 10x file size reduction without significant degradation of feature detail. When selecting the "simplification level" be sure to zoom in and examine the map the scale it will be displayed. 

Export the simplified data as a new polygon Shapefile. Be sure to download both the .shp and .shx files. Make a copy of the original DBF file from the uploaded Shapefile and rename it to match the name of the simplified Shapefile. For example I copied the original file "lower48_counties.dbf" into the directory containing the simplified "lower48_counties_25percent.shp" Shapefile and renamed the DBF to "lower48_counties_25percent.dbf".



##Step 4: 

As MapShaper reduces detail some map features, such as small islands, are lost completely. This means that the DBF file contains attribute data for features no longer in the Shapefile, causing problems in subsequent processing steps. To overcome this I open the simplified Shapefile in the GIS editor, select all the visible features and re-export. This removes any lost features from Shapefile and generates a new matching DBF file.

Before proceeding, repeat steps one through four using the state boundary file (st99_d00.shp.zip). The resulting county and state Shapefiles will be combined in the following step.



##Step 5: 

Now that the Shapefiles are re-projected, simplified and cleaned they are ready to be converted into a compressed binary format ready for use by the ActionScript renderer. This compressed format combines Shapefile vector data with the desired feature attributes, further reducing size and improving rendering speed. 

First, open the ClearMaps Builder and add each of the cleaned Shapefiles. Second, click the "Edit Data Fields" to select the attributes to be included in the export. For the example, select the county layer from the combo box and check the boxes for the "State", "County" and "Name" data fields. The first two fields are the FIPS IDs for the county and corresponding state. Select "Integer" as the data type for these fields.  The "Name" field contains the name of the county and should be a "String" type. No data fields are needed from the state layer. 

Finally, click "Export Map Layers." The export dialog reports the original and exported data size. In the case of this example, the binary output shows another 10x reduction in file size. The original raw Shapefile and data for the county layer has been reduced to single 216KB ".map" file. The state layer is 25KB.



##Step 6:

Move the map file to a location where it can be requested via HTTP by the ActionScript rendering client.  See the example on how to build a client using the rendering library.
