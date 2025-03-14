#!/usr/bin/env bash
# exit on error
set -o errexit

# Install PostgreSQL dependencies
apt-get update -qq && apt-get install -y postgresql-client libpq-dev

# Install dependencies
bundle install

# Asset compilation
bundle exec rake assets:precompile

# Database setup
bundle exec rake db:migrate 