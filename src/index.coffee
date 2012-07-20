fs = require 'fs'
fs.path = require 'path'
crypto = require 'crypto'
express = require 'express'
request = require 'request'

# creating and cleaning the cache are synchronous because these are generally init steps
class FileCache
    constructor: (@basepath) ->
        unless fs.path.existsSync @basepath
            fs.mkdirSync @basepath

    hash: (uri) ->
        sum = crypto.createHash 'md5'
        sum.update uri
        sum.digest 'hex'

    has: (uri, callback) ->
        fs.path.exists (@path uri), callback

    path: (uri) ->
        fs.path.join @basepath, @hash uri

    get: (uri, callback) ->
        @has uri, (exists) =>
            if exists
                fs.readFile (@path uri), 'utf8', callback
            else
                callback null, null

    put: (uri, content, callback) ->
        fs.writeFile (@path uri), content, 'utf8', callback

    clean: ->
        fs.rmdirSync @basepath

exports.filecache = filecache = new FileCache fs.path.join __dirname, '../cache'
exports.servers =
    cache: express.createServer()
    libs: express.createServer()

exports.find = (url) ->
    base = url.split('/').slice(-3).join('/')

exports.middleware =
    cache: (req, res, next) ->
        url = req.param 'url'
        unless url?
            if next?
                next()
            else
                res.send 404
        # test cache
        filecache.get url, (errors, file) ->
            res.contentType url
            if file?
                res.send file
            else
                # fetch if not in cache, and then put in cache
                request.get url, (errors, response, body) ->
                    if errors? or response.statusCode isnt 200
                        res.send 404
                    else
                        filecache.put url, body
                        res.send body

    libs: (base = '') ->
        (req, res, next) ->
            url = 'http://cdnjs.cloudflare.com/ajax/libs' + req.path.slice(base.length)
            req.query.url ?= url
            exports.middleware.cache req, res, next

# your run of the mill file cache, will fetch from the web at first and then keep the file
# cached indefinitely -- you're not supposed to use this for files that change often, as
# this cache does not understand HTTP cache or expires headers.
exports.servers.cache.get '/', exports.middleware.cache

# similar to `exports.cache`, this server provides a shortcut for quickly fetching cached versions
# of common JavaScript libraries, e.g. http://localhost:4000/jquery/1.7.1/jquery.min.js
exports.servers.libs.get '*', exports.middleware.libs()
