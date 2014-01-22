//From: http://stackoverflow.com/questions/5797852/in-node-js-how-do-i-include-functions-from-my-other-files
var fs = require("fs");
function read(f){return fs.readFileSync(f).toString()};
function include(f){eval.apply(global,[read(f)])}; 

include('us-states.js');

statesJSON = JSON.stringify(statesData);

fs.writeFile('us-states.json', statesJSON, function (err) {
  if (err) throw err;
  console.log('Wrote states json file.');
});
