FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

# Copy application code
COPY . .

# Precompile assets
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
RUN bundle exec rake assets:precompile SECRET_KEY_BASE=dummy

# Expose port
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
