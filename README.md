# Torkify

[![Build Status](https://travis-ci.org/joonty/torkify.png?branch=master)](https://travis-ci.org/joonty/torkify)

Torkify aims to be a one-stop shop for testing ruby applications, and handling callbacks after test execution for things like notifications.

Torkify integrates with [tork][1], which is a solution for automating test execution, as you change your source files.

Torkify hooks in to tork's remote events, and allows you to add gems and build callbacks that run when tests fail or pass. This makes it easy for you to write code that triggers cool stuff when your tests explode (your imagination is the limit).

Plus, [tork][1] is a fantastic tool that makes it very easy to run tests immediately and automatically in a pre-loaded environment.

## An example

You define callbacks by creating an observer that defines certain methods. Here's an example that creates a system notification:

```ruby
# my_tork_notifier.rb
require 'torkify'

class SystemNotifier
  def notify(text)
    # Do a system call to fire a popup notification, e.g. `notify-send`
  end

  def on_pass(event)
    notify "Test passed: #{event.file}"
  end

  def on_fail(event)
    notify "Test failed: #{event.file}, log file #{event.log_file}"
  end
end

listener = Torkify.listener
listener.add_observer SystemNotifier.new
listener.start
```

This connects to an existing tork process that's running in the current directory.

## Usage

Create a ruby script, load torkify and set up a new listener:

```ruby
# my_tork_notifier.rb

require 'torkify'

listener = Torkify.listener
```

This listener allows you to add observer objects which you create yourself:

```ruby
# my_tork_notifier.rb

listener.add_observer MyObserver.new
listener.start  # connect to tork and pass all events to the observer(s)
```

### Observer callback methods

Your observer classes can define any number of the following methods:

 * `on_startup`: when torkify starts
 * `on_shutdown`: when torkify shuts down
 * `on_test`: when a test is started
 * `on_pass`: when a test passes
 * `on_fail`: when a test fails
 * `on_pass_now_fail`: when a previously passed test fails
 * `on_fail_now_pass`: when a previously failed test passes
 * `on_absorb`: when tork re-absorbs the environment

Each method takes an optional event object as a parameter: this contains all the contextual information about that event. See **callback event objects** below for a complete list of accessible attributes on the events.

### Options for starting torkify

Calling `start()` on the listener will try and attach to a running tork process in the same directory as the script is run. This starts the process `tork-remote tork-engine` in the current directory. If you want to change the command that's called (e.g. if bundler is giving you grief), then you can pass that as the first parameter to start:

```ruby
# my_tork_notifier.rb

listener.start 'bundle exec tork-remote tork-engine'  # Will use this command instead
```

If tork is running in a different directory, you can pass in a path as the second parameter:

```ruby
# my_tork_notifier.rb

listener.start 'tork-remote tork-engine', '/home/user/project'
```

`start()` will assume that tork is running, and will exit if no tork process is found. If you want it to keep looping until tork starts, use `start_loop()`:

```ruby
# my_tork_notifier.rb

listener.start_loop   # you can pass the same parameters as with start()
```

### Starting with tork

You may not want to keep tork and torkify separate - for convenience, torkify allows you to start both at the same time. It forks torkify as a child process and runs tork in the parent, allowing you to interact with tork via STDIN but giving you the callbacks of torkify. Just use `start_with_tork()`:

```ruby
# my_tork_notifier.rb

listener.start_with_tork 'bundle exec tork', 'default:logdir'   # Starts both tork and torkify
```

Both parameters are optional. The first is the command to execute tork, and the second is the `$TORK_CONFIGS` environment variable.

### Multiple observers

You can add multiple observers to your listener:

```ruby
require 'torkify'

class FirstObserver
  #...
end

class SecondObserver
  #...
end

listener.Torkify.listener
listener.add_observer FirstObserver.new
listener.add_observer SecondObserver.new
listener.start
```

### Callback event objects

Here's an example observer, and the accessible data on the events provided in the callbacks:

```ruby

class MyObserver
  def on_test(event)
    event.type      #=> "test"
    event.file      #=> "spec/example_spec.rb"
    event.log_file  #=> "spec/example_spec.rb.log"
    event.lines     #=> [10, 11, 12]
    event.worker    #=> 0
  end

  def on_pass(event)
    event.type      #=> "pass"
    event.file      #=> "spec/example_spec.rb"
    event.log_file  #=> "spec/example_spec.rb.log"
    event.lines     #=> [10, 11, 12]
    event.worker    #=> 0
    event.exit_code #=> 0
    event.pid       #=> 22813
  end

  def on_fail(event)
    event.type      #=> "fail"
    event.file      #=> "spec/example_spec.rb"
    event.log_file  #=> "spec/example_spec.rb.log"
    event.lines     #=> [10, 11, 12]
    event.worker    #=> 0
    event.exit_code #=> 0
    event.pid       #=> 22813
  end

  # The event has an inner event, which is the same type of event
  # that's passed to #on_fail()
  def on_pass_now_fail(event)
    event.type       #=> "pass_now_fail"
    event.file       #=> "spec/example_spec.rb"
    event.event.type #=> "fail"
  end

  # The event has an inner event, which is the same type of event
  # that's passed to #on_pass()
  def on_fail_now_pass(event)
    event.type       #=> "fail_now_pass"
    event.file       #=> "spec/example_spec.rb"
    event.event.type #=> "pass"
  end

  def on_absorb(event)
    event.type      #=> "absorb"
  end

  def on_startup(event)
    event.type      #=> "startup"
  end

  def on_shutdown(event)
    event.type      #=> "shutdown"
  end
end
```

## Installation

Add this line to your application's Gemfile:

    gem 'torkify'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install torkify

## Usage

TODO: Write usage instructions here

## Contributing

The guidelines are:

 * The tests must pass (run python vdebugtests.py in the top directory of the plugin)
 * Your commit messages should follow the rules outlined [here][2]

The steps are:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: https://github.com/sunaku/tork
[2]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
