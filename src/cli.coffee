optimist = require 'optimist'
envv = require 'envv'
mimeo = require './index'

q = new envv.cdn.Query()
argv = require('optimist').argv

exports.run = ->
    switch argv._[0]
        when 'serve'
            port = argv._[1] or 3500
            mimeo.servers.libs.listen port
            console.log "Mimeo listening on port #{port}"
        when 'clean'
            mimeo.filecache.clean()
            console.log "Cleaned cache at #{mimeo.filecache.basepath}"
        when 'where'
            console.log mimeo.filecache.basepath
        when 'find'
            q.find argv._[1], (errors, locations) ->
                if locations.length      
                    base = locations[0].split('/')[5..].join('/')
                    console.log "Mimeo: \n\t#{base}"
                    console.log "CDN: "
                    for location in locations
                        console.log "\t#{location}"
                else
                    console.log "#{argv._[1]} not found on any public CDN"