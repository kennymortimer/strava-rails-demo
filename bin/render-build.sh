#!/usr/bin/env bash
# exit on error
set -o errexit

# Install PostgreSQL client
apt-get update -qq && apt-get install -y postgresql-client libpq-dev

# Install dependencies
bundle install

# Asset compilation
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Database setup
bundle exec rake db:migrate 