optimist = require 'optimist'
envv = require 'envv'
stockpile = require './index'

q = new envv.cdn.Query()
argv = require('optimist').argv

exports.run = ->
    switch argv._[0]
        when 'serve'
            port = argv._[1] or 3500
            stockpile.servers.libs.listen port
            console.log "Stockpile listening on port #{port}"
        when 'clean'
            stockpile.filecache.clean()
            console.log "Cleaned cache at #{stockpile.filecache.basepath}"
        when 'where'
            console.log stockpile.filecache.basepath
        when 'find'
            q.find argv._[1], (errors, locations) ->
                if locations.length      
                    base = locations[0].split('/')[5..].join('/')
                    console.log "Stockpile: \n\t#{base}"
                    console.log "CDN: "
                    for location in locations
                        console.log "\t#{location}"
                else
                    console.log "#{argv._[1]} not found on any public CDN"