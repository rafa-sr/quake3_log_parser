FROM ruby:3.0.0-alpine3.13

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN apk add --no-cache bash alpine-sdk libffi-dev && \
bundle install --system --without development test

ADD . /app
ENV PATH="/app/bin:${PATH}"

