FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y postgresql-client libpq-dev nodejs

# Set working directory
WORKDIR /app

# Set Rails environment
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Add Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test'
RUN bundle install

# Copy the application code
COPY . .

# Create a script to run migrations and start the server
RUN echo '#!/bin/bash\nbundle exec rake db:migrate\nexec bundle exec puma -C config/puma.rb' > /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Precompile assets
RUN SECRET_KEY_BASE=placeholder bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Start the server using the entrypoint script
CMD ["/app/entrypoint.sh"]
