FROM ruby:3.0.4

ENV APP_PATH /ceap
ENV RAILS_PORT 3000
ENV RAILS_ENV = 'production'

RUN apt-get update -qq && apt-get install -y build-essential \
  libpq-dev nodejs postgresql-client && mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock
RUN gem install bundle && bundle install

COPY . $APP_PATH

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
EXPOSE $RAILS_PORT

CMD ["rails", "server", "-b", "0.0.0.0"]
