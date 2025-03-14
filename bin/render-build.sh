#!/usr/bin/env bash
# exit on error
set -o errexit

# Configure bundler to use system libraries for pg gem
bundle config --local build.pg --with-pg-config=/usr/bin/pg_config

# Install dependencies
bundle install

# Asset compilation
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Database setup
bundle exec rake db:migrate 