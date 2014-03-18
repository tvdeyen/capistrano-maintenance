require 'capistrano'

module Capistrano::Maintenance

  def self.load_into(configuration)
    configuration.load do

      _cset(:maintenance_dirname) { "#{shared_path}/system" }
      _cset :maintenance_basename, "maintenance"
      _cset(:maintenance_template_path) { File.join(File.dirname(__FILE__), "templates", "maintenance.html.erb") }

      namespace :deploy do

        namespace :web do

          desc <<-DESC
            Present a maintenance page to visitors. Disables your application's web \
            interface by writing a "#{maintenance_basename}.html" file to each web server. The \
            servers must be configured to detect the presence of this file, and if \
            it is present, always display it instead of performing the request.

            By default, the maintenance page will just say the site is down for \
            "maintenance", and will be back "shortly", but you can customize the \
            page by specifying the REASON and UNTIL environment variables:

              $ cap deploy:web:disable \\
                    REASON="hardware upgrade" \\
                    UNTIL="12pm Central Time"

            You can use a different template for the maintenance page by setting the \
            :maintenance_template_path variable in your deploy.rb file. The template file \
            should either be a plaintext or an erb file.

            Further customization will require that you write your own task.
          DESC
          task :disable, :roles => :web, :except => { :no_release => true } do
            require 'erb'
            on_rollback { run "rm -f #{maintenance_dirname}/#{maintenance_basename}.html" }

            if fetch(:maintenance_config_warning, true)
              warn <<-EOHTACCESS

                # Please add something like this to your site's Apache htaccess to redirect users to the maintenance page.
                # More Info: http://www.shiftcommathree.com/articles/make-your-rails-maintenance-page-respond-with-a-503

                ErrorDocument 503 /system/#{maintenance_basename}.html
                RewriteEngine On
                RewriteCond %{REQUEST_URI} !\.(css|gif|jpg|png)$
                RewriteCond %{DOCUMENT_ROOT}/system/#{maintenance_basename}.html -f
                RewriteCond %{SCRIPT_FILENAME} !#{maintenance_basename}.html
                RewriteRule ^.*$  -  [redirect=503,last]

                # Or if you are using Nginx add this to your server config:

                if (-f $document_root/system/maintenance.html) {
                  return 503;
                }
                error_page 503 @maintenance;
                location @maintenance {
                  rewrite  ^(.*)$  /system/maintenance.html last;
                  break;
                }
              EOHTACCESS
            end

            reason = ENV['REASON']
            deadline = ENV['UNTIL']

            template = File.read(maintenance_template_path)
            result = ERB.new(template).result(binding)

            put_options = { :mode => 0644 }
            if fetch(:put_via, false)
              put_options[:via] = fetch(:put_via)
            end

            put result, "#{maintenance_dirname}/#{maintenance_basename}.html", put_options
          end

          desc <<-DESC
            Makes the application web-accessible again. Removes the \
            "#{maintenance_basename}.html" page generated by deploy:web:disable, which (if your \
            web servers are configured correctly) will make your application \
            web-accessible again.
          DESC
          task :enable, :roles => :web, :except => { :no_release => true } do
            run "rm -f #{maintenance_dirname}/#{maintenance_basename}.html"
          end

        end

      end

    end

  end

end

if Capistrano::Configuration.instance
  Capistrano::Maintenance.load_into(Capistrano::Configuration.instance)
end
