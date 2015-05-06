Capistrano 2 Maintenance Extension
==================================

This gem simply offers the recently removed `deploy:web:disable` and `deploy:web:enable` tasks to your Capistrano 2  deployment.

**NOTE** This version only works with Capistrano 2.x. For a Capistrano 3 compatible version please use [the official extension](https://github.com/capistrano/maintenance).

Usage
-----

Install the gem via rubygems:

```sh
gem install capistrano-maintenance --version=0.0.5
```

or use bundler:

```ruby
# Gemfile
gem 'capistrano-maintenance', '0.0.5', group: 'development'
```

```sh
bundle install
```

And put this line into your deploy.rb file:

```ruby
require 'capistrano/maintenance'
```

Now, you can disable the web:

```sh
cap deploy:web:disable
```

You can also specify a string to specify reason and how long it is until:

```sh
cap deploy:web:disable REASON="For server upgrades" UNTIL="3AM EST"
```

When maintenance is done, you can enable the web:

```sh
cap deploy:web:enable
```

If you are using [multistage capistrano](https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension), you'll also need to include the stage before `deploy:web:disable` and `deploy:web:enable`:

```sh
cap production deploy:web:disable
cap production deploy:web:enable
```

Configuration
-------------

Everything should work out of the box general, but there are some additional adjustments you can make in your deploy.rb.

```ruby
# change the default filename from maintenance.html to disabled.html
set :maintenance_basename, 'disabled'

# change default directory from default of #{shared_path}/system
set :maintenance_dirname, "#{shared_path}/public/system"

# use local template instead of included one with capistrano-maintenance
set :maintenance_template_path, 'app/views/maintenance.html.erb'

# disable the warning on how to configure your server
set :maintenance_config_warning, false
```

For your custom maintenance template, you have access to the following variables, if they're defined:

* reason
* deadline

These are the environment variables passed in via REASON="something" and UNTIL="later"
