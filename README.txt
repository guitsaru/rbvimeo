rbVimeo
    by Matt Pruitt
    www.guitsaru.com

== DESCRIPTION:

A ruby wrapper for the Vimeo API

== FEATURES/PROBLEMS:

This does not handle authentication.  It only gets public videos from Vimeo.

== SYNOPSIS:

vimeo = RBVIMEO::Vimeo.new(api_key, api_signature)
vid = vimeo.video(video_id)

== INSTALL:

To install, run 'gem install rbvimeo'

In order to run the specs, first make a test_settings.yml file (a sample is
provided) using your api key and api secret.

== LICENSE:

(The MIT License)

Copyright (c) 2008 Matt Pruitt

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
