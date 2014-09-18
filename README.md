# Stockpile

[![Build Status](https://secure.travis-ci.org/stdbrouw/stockpile.png)](http://travis-ci.org/stdbrouw/stockpile)

Stockpile is the airplane mode for your application. Automatically cache and then serve common JavaScript libraries or any kind of file from your development machine. Why? Because localhost is always faster and because being able to code without an internet connection is still kind of useful sometimes.

## Status

Stockpile is **no longer actively maintained**. For an easy way to manage front-end dependencies, try [Bower](http://bower.io/) instead.

## Usage

Stockpile comes in two flavors, each express.js HTTP servers, so they're easily attached to any existing application. You can also use it standalone, though the `stockpile` command-line interface. Lastly, Stockpile is packaged together with [Draughtsman](https://github.com/stdbrouw/draughtsman), a web server that aids in front-end prototyping and development.

Stockpile will keep files cached indefinitely so don't use it for files that change often. Stockpile does not understand HTTP cache or expires headers.

Install with `npm install stockpile`.

## The cache servers

### Generic server

The `servers.cache` server will fetch and then immediately cache anything you ask of it. For example: 

    http://localhost:3500/?url=http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.1/jquery.min.js

### JavaScript library server

This server provides a shortcut for quickly fetching and then serving cached versions of common JavaScript libraries. Anything that's not already in its cache, it will fetch from CloudFlare's CDNJS content delivery network. Here's an example that's equivalent to the first one:

    http://localhost:3500/jquery/1.7.1/jquery.min.js

## API

For now, read the code. (All 80 lines!)

## CLI

    # serve both Stockpile caches on your local machine
    stockpile serve <port:3500>
    # clean the cache
    stockpile clean
    # find the location of your cache
    stockpile where
    # figure out the paths to popular libraries on public CDNs
    # and on the Stockpile localhost.
    stockpile find <semver>

E.g. `stockpile find underscore.js@1.3.3` will return

    Stockpile: 
		underscore.js/1.3.3/underscore-min.js
	CDN: 
		http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.3.3/underscore-min.js

So you know you can find Underscore.js through Stockpile at `http://localhost:3500/underscore.js/1.3.3/underscore-min.js`