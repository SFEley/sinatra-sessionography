$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'

set :environment, :test
require 'sinatra/sessionography'

# Simple getter for testing
get '/session' do
  session.inspect
end

# Simple setter for testing
post '/session' do
  params.each{|k,v| session[k.to_sym] = (v.is_a?(String) ? v.to_sym : v)}
  session.inspect
end

# Hook to our application so Rack::Test works; see: http://www.sinatrarb.com/testing.html
module SinatraApp
  def app
    Sinatra::Application
  end
end

Spec::Runner.configure do |config|
  include SinatraApp
  include Rack::Test::Methods
end
