/*******************************
  Treatment Assignment Explanation
  Example: Cuba
      Ryan McWay
      11/12/2019
*******************************/
// Two cites: one treatment, one control. 
// Both with interior and outer radius. 
// Show a cruise liner path to treatment, 
// Show a cruise liner path passing by both cities. 
// Show some dots for households inside and outside radius

/*******************************
  Center and Label for Map
*******************************/

var center = ee.Geometry.Point(-76.46503866322672, 20.395208976047105);
var zoom_level = 8.1;
Map.centerObject(center, zoom_level);

/*******************************
      Create Radius and Households
*******************************/

// 50 kilometers around the cities for port assignment
var outer_buffer_treatment = ee.Feature(treatment).buffer(50000);
Map.addLayer(outer_buffer_treatment, {color:'green'}, "outer_buffer_treatment");
var outer_buffer_control = ee.Feature(control).buffer(50000);
Map.addLayer(outer_buffer_control, {color:'green'}, "outer_buffer_control");

// 15 kilometers around the cities for treatment identification
var interior_buffer_treatment = ee.Feature(treatment).buffer(15000);
Map.addLayer(interior_buffer_treatment, {color:'red'}, "interior_buffer_treatment");
var interior_buffer_control = ee.Feature(control).buffer(15000);
Map.addLayer(interior_buffer_control, {color:'red'}, "interior_buffer_control");

/*******************************
  Adding Points to Map
*******************************/
// Add Ports
// Map.addLayer(control, {color:'ffec02', symbol:'teardrop'}, "Control");
// Map.addLayer(treatment, {color:'0b4a8b'}, "Treatment");

// Add Households
Map.addLayer(households, {color:'bf04c2'}, "Households");

// Add Cruise Liner
Map.addLayer(cruise_path, {color:'#000000'}, 'cruise path')

/*******************************
      Creating Legend
*******************************/
// set position of panel
var legend = ui.Panel({
  style: {
    position: 'bottom-left',
    padding: '25px 25px'
  }
});
// Create legend title
var legendTitle = ui.Label({
  value: 'Example: Cuba',
  style: {
    fontWeight: 'bold',
    fontSize: '18px',
    margin: '0 0 4px 0',
    padding: '0'
    }
});
 
// Add the title to the panel
legend.add(legendTitle);
 
// Function to that creates and styles 1 row of the legend.
var makeRow = function(color, name) {
      // Create the label that is actually the colored box.
      var colorBox = ui.Label({
        style: {
          backgroundColor: '#' + color,
          // Use padding to give the box height and width.
          padding: '5px',
          margin: '0 0 4px 0'
        }
      });
 
      // Create the label filled with the description text.
      var description = ui.Label({
        value: name,
        style: {margin: '0 0 4px 5px'}
      });
 
      // return the panel
      return ui.Panel({
        widgets: [colorBox, description],
        layout: ui.Panel.Layout.Flow('horizontal')
      });
};
 
//  Palette colors for legend
var palette =['000000', 'bf04c2', 'ffe10c', '0b4a8b', 'FF0000', '008000'];
//  Names in legend
var names = ['Cruise Liner Path',
            'Households Location',
            'Control Port: Manzanillo',
            'Treatment Port: Santiago de Cuba',
            'Treatment Assignment: 15 Km Radius', 
            'Assignment to Port: 50 Km Radius'];
 
// Add color and names
for (var i = 0; i < 5; i++) {
  legend.add(makeRow(palette[i], names[i]));
  }  
 
// Add legend to Map 
// (alternatively you can also print the legend to the console)
Map.add(legend);



