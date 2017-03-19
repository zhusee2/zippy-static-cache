# zippy_static_cache
Modified Rack::StaticCache to work better with rack-zippy

Read [here](http://blog.zhusee.in/post/248961/enhance-page-speed-for-middleman-on-heroku) for the inspiration of this gem. 

## Installation
Place in your Gemfile
```
gem 'zippy_static_cache'
```

Run `$ bundle install`. Make sure you already have the [rack_zippy](https://github.com/eliotsykes/rack-zippy) gem included.

##Use

Example configuration for a [middleman](https://middlemanapp.com/) application. In `config.ru`
```
require 'rack'
require 'rack/contrib/try_static'
require 'rack-zippy'
require 'zippy_static_cache'

use ZippyStaticCache, :urls => ['/images', '/stylesheets', '/javascripts', '/fonts']
use Rack::Zippy::AssetServer, 'build'
use Rack::TryStatic,
  root: 'build',
  urls: %w[/],
  try: ['.html', 'index.html', '/index.html']
run lambda{ |env|
  four_oh_four_page = File.expand_path("../build/404/index.html", __FILE__)
  [ 404, { 'Content-Type'  => 'text/html'}, [ File.read(four_oh_four_page) ]]
}
```
