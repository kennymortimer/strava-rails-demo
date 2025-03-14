FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y postgresql-client libpq-dev

# Set working directory
WORKDIR /app

# Add Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application code
COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
