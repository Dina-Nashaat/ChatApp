FROM ruby:2.5-slim

LABEL Name=chatapp Version=0.0.1
ENV APP_HOME /chatapp

RUN apt-get update -qq && \
    apt-get install -y mysql-client \
    --no-install-recommends

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . $APP_HOME

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0 "]
