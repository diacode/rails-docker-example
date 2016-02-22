FROM ruby:2.3

# Install extra packages
# nodejs: for precompile JS assets
# nginx: as reverse proxy for the Puma web server
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    nginx

# Setup our app's folder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install gems excluding dev and test
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --without development test

# Precompile assets
COPY Rakefile .
COPY config config
COPY app/assets app/assets
COPY vendor vendor
RUN bundle exec rake assets:precompile

# Copy nginx and Puma custom conf
COPY ./deploy/puma.rb ./config/
COPY ./deploy/nginx.conf /etc/nginx/nginx.conf

# Copy the full app
COPY . /usr/src/app

CMD ["foreman", "start"]