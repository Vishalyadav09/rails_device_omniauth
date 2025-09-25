FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /rails_devise_oauth

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.5.7

RUN bundle install