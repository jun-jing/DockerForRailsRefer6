FROM ruby:3.0

LABEL maintainer="tewbooathtb@gmail.com"

# ENV http_proxy 127.0.0.1:55680
# ENV https_proxy 127.0.0.1:55680
# --build-arg http_proxy=127.0.0.1:55680 --build-arg https_proxy=127.0.0.1:55680 .

# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
apt-transport-https

# Ensure we install an up-to-date version of Node
# See https://github.com/yarnpkg/yarn/issues/2888
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Ensure latest packages for Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn \
  vim

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

ENV BUNDLE_PATH /gems

RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
# RUN gem sources --remove https://rubygems.org/
# RUN gem sources -a https://gems.ruby-china.com
RUN bundle install

COPY . /usr/src/app/

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["bin/rails", "s", "-b", "0.0.0.0"]


### ruby 3.0 prerequisite(docker -itv and executes below commands)

## Install Yarn 
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  # curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  # echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# sudo apt update && sudo apt install yarn
  # apt update && apt install yarn

## install webpacker:install
# bin/rails webpacker:install
  # RUN bin/rails webpacker:install
## We expose the port
  # EXPOSE 3000