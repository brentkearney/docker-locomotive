#!/usr/bin/env bash

echo
echo "Setting system timezone..."
dpkg-reconfigure -f noninteractive tzdata

echo
echo "Setting GEM environment..."
rm -rf ~root/.gem
export GEM_HOME /var/lib/gems/2.2.0
export GEM_PATH /var/lib/gems/2.2.0
export GEM_SPEC_CACHE /var/lib/gems/2.2.0/specs
gem environment

echo
echo "Installing latest bundler..."
gem uninstall bundler-1.10.6
gem install bundler

if [ ! -f /home/app/engine/app ]; then
	echo
	echo "Setting up Ruby on Rails..."
	gem install rails -v 4.2.6
	ln -sf /var/lib/gems/2.2.0/gems/railties-4.2.6/bin/rails /usr/local/bin/rails
	cd /home/app; rails new engine --skip-bundle --skip-active-record --skip
	cd /home/app/engine
	echo "gem 'locomotivecms', '~> 3.1.1'" >> "Gemfile"
	echo "gem 'puma'" >> "Gemfile"
fi

echo 
echo "Installing ruby gems..."
RAILS_ENV=production bundle install
chown -R app:app /var/lib/gems

if [ ! -f config/initializers/locomotive.rb ]; then
	echo 
	echo "Installing locomotive..."
	cd /home/app/engine; ./bin/rails generate locomotive:install
	sed -i 's/localhost/db/g' /home/app/engine/config/mongoid.yml
fi
chown app:app -R /home/app

echo
echo "Compiling Assets..."
su - app -c "cd /home/app/engine; RAILS_ENV=production bundle exec rake assets:precompile --trace"

echo
echo "Starting Phusion Passenger Stand-alone..."
RAILS_ENV=production bundle exec passenger start -a 0.0.0.0 -p 80 -e production
