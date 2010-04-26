require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sinatra::Sessionography do
  before(:each) do
    Sinatra::Sessionography.session.clear
  end
  
  it "shows an empty session when nothing is initialized" do
    get "/session"
    last_response.body.should == "{}"
  end

  it "writes sessions" do
    post "/session", {:dog => :woof}
    Sinatra::Sessionography.session[:dog].should == :woof
  end
  
  it "reads sessions" do
    Sinatra::Sessionography.session[:duck] = :quack
    get "/session"
    last_response.body.should == "{:duck=>:quack}"
  end
  
  it "can be set with an initializing hash" do
    Sinatra::Sessionography.session = {:sheep => :baa}
    get "/session"
    last_response.body.should == "{:sheep=>:baa}"
  end
  
  it "persists state across requests" do
    post "/session", {:snail=>:slurp, :monkey=>:howl, :deer=>'Shoot me!'}
    post "/session", {:cow=>:moo, :deer=>nil}
    get "/session"
    last_response.body.should == "{:snail=>:slurp, :monkey=>:howl, :deer=>nil, :cow=>:moo}"
  end
end