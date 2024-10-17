# Time Crisis [POC]

Middleware for tracking when a portion of a page changes.

Time Crisis is middleware that takes a css selector and uses that to hash a portion of a page.

It then stores the hash as well as a timestamp, against the request path of the page in Redis using Kredis.

Stored values look like this:

```
"/:hash" => 1234567890
"/:created_at" => 2024-10-17 11:55:24 UTC
```

Values are currently stored as the page path with either `:hash` or `:created_at` appended for ease of access.

The middleware is set up like so:

`config.middleware.use TimeCrisis, selector: "#main"` 

Meaning we can change the selector (which gets passed to Nokogiri) to only monitor the portion of the page we want and ignore any other changes. If in doubt, set this to `body`.

## Installation

Clone the repo and run

`./bin/dev`

Head to the home page and change some content.


## Issues

- Sometimes you don't get a response but a `Sprockets::Asset` object handed to Nokogiri
