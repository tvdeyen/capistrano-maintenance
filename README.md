Capistrano Maintenance Extension
=================================

This gem simply offers the recently removed `deploy:web:disable` and `deploy:web:enable` tasks to your Capistrano deployment.

Usage
-----

Install the gem via rubygems:

    gem install capistrano-maintenance

And put this line into your deploy.rb file:

    require 'capistrano/maintenance'

That's it. Everthing works like expected.

Configuration
-------------

Everything should work out of the box general, but there are some additional adjustments you can make in your deploy.rb.

    # change the default filename from maintenance.html to disabled.html
    set :maintenance_basename, 'disabled'

    # change default directory from default of #{shared_path}/system
    set :maintenance_dirname, "#{shared_path}/public/system"

    # use local template instead of included one with capistrano-maintenance
    set :maintenance_template_path, 'app/views/maintenance.html'

	# disable the warning on how to configure your server
	set :maintenance_config_warning, false
