Sessionography
==============

This is a simple testing helper for Sinatra sessions. It was written because
having to use [this sort of approach][1] to test sessions made me sad.
Sessionography replaces Sinatra's `session` helper with a reference to a
simple hash in a module variable, enabling session calls that maintain state
across requests without the complexity and limitations of trying to use
`Rack::Session` with [Rack::Test][2].

It will not help you sing better. It does not make omelettes. And if you're
testing something that actually _cares_ about how sessions get set (e.g., if
you're working on Sinatra itself or a low-level Rack component) you won't want
to use this. But most of us just want to get on with testing our apps.

Setting up
----------
    $ gem install sinatra-sessiongraphy

(Or `sudo gem install` if you're the last person on Earth who isn't using [RVM][3] yet.)

Then, in your **test\_helper.rb** file or your **spec\_helper.rb** file, just `require sinatra/sessionography`.  If you're using the **Sinatra::Base** style you'll also need to explicitly include the helper:

    # spec_helper.rb
    require 'myapp'
    require 'sinatra/sessionography'
    
    MyApp.helpers Sinatra::Sessionography

    
Testing Tips
------------
Your app code can continue to call `session[:whatever]` as it already does.  It'll simply bypass any `Rack::Session` middleware and set a hash in memory.  

If you'd like to access that hash in your test cases, there are module methods available: 

    # This example is in RSpec, because that is how I roll.
    describe HypotheticalApp do
      before(:each) do
        # You should initialize the session every time, with a .clear or
        # an assignment.  Here, we simulate pre-existing state.
        Sinatra::Sessionography.session = {:foo => 'bar', :too => 'tar'}
      end
      
      it "should do something to the session" do
        post "/something", {:hey => :ho}
        Sinatra::Sessionography.session['hey'].should == 'ho'
      end
      
      it "should pay attention to the session" do
        Sinatra::Sessionography.session[:user] = User.find_by_name('Tina Fey')
        get "/something"
        last_response.body.should =~ /Tina Fey/
      end
      
    end

The session will of course persist across Sinatra requests.  That's the point of a session.  However, it will _also_ persist between test cases, which is probably not what you want, so in your setup or teardown code you should always call `Sinatra::Sessionography.session.clear` or else set it to _nil_ or some other useful value.

Future Enhancements
-------------------
I knocked this off quickly because I needed it (for [Sinatra::Flash][4]) but it'd be fairly easy to give it a few other features useful for testing:

* Multiple sessions scoped by name, for simulating interactions between different users;
* Logging or remembering of changes to session state, so that test cases can trace more complex interactions with the session over time;
* Generalization to a Rack::Session::Test (or perhaps Rack::MockSession) component for testing Rack applications outside of just Sinatra.

I don't need any of those _today,_ so I'm not going to build them right away.  But if you'd like to see them, feel free to leave an issue here and let me know.  (Or just build it and contribute back, of course.  The source, it is open like the sky.)


License
-------
This project is licensed under the [Don't Be a Dick License][5], version 0.2, and is copyright 2010 by Stephen Eley. See the [LICENSE.markdown][5] file for elaboration on not being a dick.

[1]:http://groups.google.com/group/sinatrarb/msg/338ece48db7963cf
[2]:http://github.com/brynary/rack-test
[3]:http://rvm.beginrescueend.com
[4]:http://github.com/SFEley/sinatra-flash