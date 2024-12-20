FROM ruby:3.1.1

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 
RUN apt-get update && apt-get install -y nodejs

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs chromium chromium-driver yarn

ENV APP_PATH /myapp

RUN mkdir $APP_PATH
WORKDIR $APP_PATH
ENV BUNDLE_PATH /myapp/vendor/bundle

COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock
RUN bundle install

COPY . $APP_PATHR

RUN yarn install

EXPOSE 3000

USER root

VOLUME /myapp/public
VOLUME /myapp/tmp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD /bin/bash -c "bundle install && rm -f tmp/pids/server.pid && bundle exec rails server"


