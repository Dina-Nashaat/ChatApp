FROM ruby:2.5.5

LABEL Name=chatapp Version=0.0.1
ENV APP_HOME /chatapp

RUN apt-get update && \
    apt-get install -y default-mysql-client \
                    libxml2-dev libxslt-dev libgmp-dev\
                    --no-install-recommends

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock ./

ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler && bundle install --jobs 2 --verbose

COPY . $APP_HOME

CMD whenever --update-crontab
