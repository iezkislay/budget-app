# Use an official Ruby runtime as a parent image
FROM ruby:3.1.2

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql

# Set up PostgreSQL
RUN service postgresql start && \
    su - postgres -c "createuser -s budgy" && \
    su - postgres -c "psql -c \"ALTER USER budgy PASSWORD 'yourpassword';\""

# Install Rails gems
COPY Gemfile Gemfile.lock /app/
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the rest of the application code into the container
COPY . /app/

# Expose port 3000
EXPOSE 3000

# Start the Rails application
CMD service postgresql start && rails db:create && rails db:migrate && rails server -b 0.0.0.0

