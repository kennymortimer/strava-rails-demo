#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Asset compilation
bundle exec rake assets:precompile

# Database setup
bundle exec rake db:migrate 