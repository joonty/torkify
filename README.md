# Torkify

Torkify integrates with [tork][1], which is a solution for automating tests as you change your source files.

Torkify hooks in to tork's remote events, and allows you to write ruby code that's called when particular events fire. This makes it easy for you to write code that triggers cool stuff when your tests pass or fail.

## An example

You define callbacks by creating an observer that defines certain methods. Here's an example that creates a system notification:

```ruby
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

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]: https://github.com/sunaku/tork
