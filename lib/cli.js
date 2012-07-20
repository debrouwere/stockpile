(function() {
  var argv, envv, mimeo, optimist, q;

  optimist = require('optimist');

  envv = require('envv');

  mimeo = require('./index');

  q = new envv.cdn.Query();

  argv = require('optimist').argv;

  exports.run = function() {
    var port;
    switch (argv._[0]) {
      case 'serve':
        port = argv._[1] || 3500;
        mimeo.servers.libs.listen(port);
        return console.log("Mimeo listening on port " + port);
      case 'clean':
        mimeo.filecache.clean();
        return console.log("Cleaned cache at " + mimeo.filecache.basepath);
      case 'where':
        return console.log(mimeo.filecache.basepath);
      case 'find':
        return q.find(argv._[1], function(errors, locations) {
          var base, location, _i, _len, _results;
          if (locations.length) {
            base = locations[0].split('/').slice(5).join('/');
            console.log("Mimeo: \n\t" + base);
            console.log("CDN: ");
            _results = [];
            for (_i = 0, _len = locations.length; _i < _len; _i++) {
              location = locations[_i];
              _results.push(console.log("\t" + location));
            }
            return _results;
          } else {
            return console.log("" + argv._[1] + " not found on any public CDN");
          }
        });
    }
  };

}).call(this);
