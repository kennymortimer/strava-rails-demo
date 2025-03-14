FROM ruby:3.2.2-slim

# Install PostgreSQL client and development libraries
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential postgresql-client libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application
COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=dummy

# Set up the entry point
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
