# Mimeo

[![Build Status](https://secure.travis-ci.org/stdbrouw/mimeo.png)](http://travis-ci.org/stdbrouw/mimeo)

Mimeo is the airplane mode for your application. Automatically cache and then serve common JavaScript libraries or any kind of file from your development machine. Why? Because localhost is always faster and because being able to code without an internet connection is still kind of useful sometimes.

Mimeo comes in two flavors, each express.js HTTP servers, so they're easily attached to any existing application. You can also use it standalone, though the `mimeo` command-line interface. Lastly, Mimeo is packaged together with [Draughtsman](https://github.com/stdbrouw/draughtsman), a web server that aids in front-end prototyping and development.

Mimeo will keep files cached indefinitely so don't use it for files that change often. Mimeo does not understand HTTP cache or expires headers.

## The cache servers

### Generic server

The `servers.cache` server will fetch and then immediately cache anything you ask of it. For example: 

    http://localhost:4000/?url=http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.1/jquery.min.js

### JavaScript library server

This server provides a shortcut for quickly fetching and then serving cached versions of common JavaScript libraries. Anything that's not already in its cache, it will fetch from CloudFlare's CDNJS content delivery network. Here's an example that's equivalent to the first one:

    http://localhost:4000/jquery/1.7.1/jquery.min.js

## API

For now, read the code. (All 80 lines!)

## CLI

Not implemented yet. But it will look something like this: 

    # serve both mimeo caches on your local machine
    mimeo serve
    # clean the cache
    mimeo clean
    # find the location of your cache
    mimeo where
