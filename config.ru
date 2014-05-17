# config: utf-8

require './app'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '/*', :headers => :any, :methods => :get
  end
end

run Ergo::App.new
