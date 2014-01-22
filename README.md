We start with some US states data (in `us-states.js`) from the [leaflet.js](http://leafletjs.com/examples/choropleth.html#interactive-choropleth-map) examples. And we want to process them to genreate a geojson file that includes the length of the state's name.

To create a `us-states.geojson` geojson file:
```
node us-states-to-json.js
```

To process the json data and create JS (`us-states-with-name-length.js`) and GeoJSON (`us-states-with-name-length.geojson`) files:

```
ruby us-states-with-name-length.rb
```

The JS is for displaying on the map. GeoJSON is for displaying on GitHub.

Then you can open the site and see it displayed:

```
open index.html
```

There's also a working a [working
demo](http://bl.ocks.org/kyletolle/8553741).

