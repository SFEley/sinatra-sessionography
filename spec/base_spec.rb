require File.dirname(__FILE__) + '/spec_helper'

class BaseApp < Sinatra::Base
  helpers Sinatra::Sessionography

  # Simple getter for testing
  get '/session' do
    session.inspect
  end

  # Simple setter for testing
  post '/session' do
    params.each{|k,v| session[k.to_sym] = (v.is_a?(String) ? v.to_sym : v)}
    session.inspect
  end

end

describe "Sinatra::Sessionography in a Sinatra::Base application" do
  def app
    BaseApp
  end
  
  before(:each) do
    Sinatra::Sessionography.session = nil
  end
  
  it "returns a blank hash when not set" do
    get '/session'
    last_response.body.should == "{}"
  end
  
  it "can set a hash" do
    post '/session', {:foo=>:bar}
    last_response.body.should == "{:foo=>:bar}"
  end
  
  it "can remember what's posted" do
    post '/session', {:hi=>:ho}
    get '/session'
    last_response.body.should == "{:hi=>:ho}"
  end
  
end