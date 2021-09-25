FROM ruby:2.6.5

ENV APP_PATH /workspace
ENV BUNDLE_VERSION 2.2.27
ENV RAILS_PORT 3000

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn postgresql-client libpq-dev \
    && mkdir -p $APP_PATH
WORKDIR $APP_PATH

RUN gem install bundler --version "$BUNDLE_VERSION"
ADD Gemfile* $APP_HOME/
RUN bundle install
ADD . $APP_HOME
RUN yarn install --check-files

EXPOSE $RAILS_PORT
ENTRYPOINT [ "bundle", "exec" ]
