### Introduction 

To overcome some of the limitations with existing mapping tools, Sunlight Lab is releasing [ClearMaps](http://github.com/sunlightlabs/clearmaps/), an ActionScript framework for interactive cartographic visualization. In addition to giving designers and developers total control over presentation the project aims to address some of the common technical challenges faced when building interactive, data driven maps for the web. ClearMaps is designed as a lightweight, flexible set of tools for building complex data visualizations. It is a framework not a plug-and-play component (though it could be a starting point for those wishing to make reusable tools). 

See [this link](http://assets.sunlightlabs.com/maps/demo.html) for a demonstration of the ClearMaps framework.

ClearMaps provides an Adobe AIR based encoding tool for translating data from Shapefiles into a compressed binary form and a set of ActionScript classes for decoding and rendering vector data. These tools currently provide the functionality required to get from raw cartographic data to a web map with a minimum of glue code (the above demo map requires less than a hundred lines of ActionScript). 

However, the library is far from complete. Features like keys and legends are currently missing and much work remains in building an extensible framework for integrating external data sources. If you find these tools useful drop us a line and let us know how you're using the framework. If you have ideas or code for solving common visualization tasks we would love to incorporate them into the library.
