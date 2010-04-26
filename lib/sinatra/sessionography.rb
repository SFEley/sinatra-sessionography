require 'sinatra/base'

module Sinatra
  # Eases testing by overriding Sinatra's #session helper to access a module hash.  Also
  # provides a direct module method to that hash for test verification.  
  # 
  # If your application is using the {Sinatra::Base} style (as you probably should most of the time
  # you'll also need to include this module as a helper when setting up your test suite:
  # 
  # @example (Assuming your app is declared with `class MyApp < Sinatra::Base`)
  #   require 'myapp'
  #   require 'sinatra/sessionography'
  #   MyApp.helpers Sinatra::Sessionography
  module Sessionography
    
    # Use this in your test cases to get or set session variables outside of your application code.
    #
    # @return [Hash] A session hash.
    def self.session
      @session ||= {}
    end
    
    # Set up the session with a copy of your own hash for testing. (Optional; it'll default to an  
    # empty hash or to the contents of 'rack.session' if you don't do this.)
    # 
    # @param [Hash] val The hash to use as the session. Note that we clone the object; we don't maintain
    #   a live link to the same hash.
    def self.session=(val)
      @session = val.clone
    end
    
    # Replaces Sinatra's #session helper to completely bypass Rack::Session, thus mocking out 
    # sessions in tests.
    #
    # Let's be clear: this session is _global._  Not per-user.  *Using this in production code 
    # would be bad.* (Important safety tip, thanks Egon.)
    #
    # @return [Hash] The same session hash accessible from {Sinatra::Sessionography.session}
    def session
      Sessionography.session
    end
  end
  
  helpers Sessionography
end