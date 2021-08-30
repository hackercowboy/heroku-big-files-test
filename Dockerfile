FROM ruby:3.0.1-alpine as build

ENV BUNDLE_WITHOUT development:test
ENV BUNDLE_PATH /app/vendor/bundle
ENV BUNDLE_BIN /app/vendor/bundle/bin
ENV BUNDLE_DEPLOYMENT 1

ENV PATH /app/vendor/bundle/bin:$PATH
ENV RAILS_ENV production

RUN apk add --no-cache bash build-base cmake git openssl-dev postgresql-dev shared-mime-info tzdata nodejs yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./

RUN bundle install
RUN SECRET_KEY_BASE=dummy rake assets:precompile --trace
RUN SECRET_KEY_BASE=dummy rake assets:clean

RUN rm -rf tmp

FROM ruby:3.0.1-alpine

ENV BUNDLE_WITHOUT development:test
ENV BUNDLE_PATH /app/vendor/bundle
ENV BUNDLE_BIN /app/vendor/bundle/bin
ENV BUNDLE_DEPLOYMENT 1

ENV PATH /app/vendor/bundle/bin:$PATH
ENV RAILS_ENV production

RUN apk add --no-cache bash shared-mime-info tzdata postgresql-dev nodejs yarn imagemagick

COPY --from=build /app /app

CMD [ "rails", "-s" ]