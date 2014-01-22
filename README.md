We start with some US states data (in `us-states.js`) from the [leaflet.js](http://leafletjs.com/examples/choropleth.html#interactive-choropleth-map) examples. And we want to process them to genreate a geojson file that includes the length of the state's name.

To create a `us-states.geojson` geojson file:
```
node us-states-to-json.js
```

To process the json data and create JS and GeoJSON files:

```
ruby us-states-with-name-length.rb
```

Then you can open the site and see it displayed:

```
open index.html
```

