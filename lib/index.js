(function() {
  var FileCache, cached_proxy, crypto, express, fs, mime, request;

  fs = require('fs');

  fs.path = require('path');

  crypto = require('crypto');

  express = require('express');

  request = require('request');

  mime = require('mime');

  FileCache = (function() {

    function FileCache(basepath) {
      this.basepath = basepath;
      if (!fs.path.existsSync(this.basepath)) fs.mkdirSync(this.basepath);
    }

    FileCache.prototype.hash = function(uri) {
      var sum;
      sum = crypto.createHash('md5');
      sum.update(uri);
      return sum.digest('hex');
    };

    FileCache.prototype.has = function(uri, callback) {
      return fs.path.exists(this.path(uri), callback);
    };

    FileCache.prototype.path = function(uri) {
      return fs.path.join(this.basepath, this.hash(uri));
    };

    FileCache.prototype.get = function(uri, callback) {
      var _this = this;
      return this.has(uri, function(exists) {
        if (exists) {
          return fs.readFile(_this.path(uri), 'utf8', callback);
        } else {
          return callback(null, null);
        }
      });
    };

    FileCache.prototype.put = function(uri, content, callback) {
      return fs.writeFile(this.path(uri), content, 'utf8', callback);
    };

    FileCache.prototype.clean = function() {
      return fs.rmdirSync(this.basepath);
    };

    return FileCache;

  })();

  exports.filecache = new FileCache(fs.path.join(__dirname, '../cache'));

  exports.servers = {
    cache: express.createServer(),
    libs: express.createServer()
  };

  exports.find = function(url) {
    var base;
    return base = url.split('/').slice(-3).join('/');
  };

  cached_proxy = function(req, res) {
    var url;
    url = req.param('url');
    if (url == null) res.send(404);
    return exports.filecache.get(url, function(errors, file) {
      mime = mime.lookup(url);
      if (file != null) {
        res.contentType(mime);
        return res.send(file);
      } else {
        return request.get(url, function(errors, response, body) {
          if ((errors != null) || response.statusCode !== 200) {
            return res.send(404);
          } else {
            filecache.put(url, body);
            res.contentType(mime);
            return res.send(body);
          }
        });
      }
    });
  };

  exports.servers.cache.get('/', cached_proxy);

  exports.servers.libs.get('*', function(req, res) {
    var url;
    url = 'http://cdnjs.cloudflare.com/ajax/libs' + req.path;
    req.query.url = url;
    return cached_proxy(req, res);
  });

}).call(this);
