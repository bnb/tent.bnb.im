# middleman 3.1 needs bundler 1.x and activesupport 3.2, so the build runs on
# ruby 2.3 (debian stretch, now only on archive.debian.org)
FROM ruby:2.3-stretch AS build
# the image already has python 2 for pygments.rb. stretch's apt keys have
# expired, so execjs gets its js runtime from the node image instead
COPY --from=node:16-buster-slim /usr/local/bin/node /usr/local/bin/node
# github dropped the git:// protocol the Gemfile still points at
RUN gem install bundler -v 1.17.3 \
  && git config --global url."https://github.com/".insteadOf git://github.com/
WORKDIR /site
COPY Gemfile Gemfile.lock ./
RUN bundle _1.17.3_ install --jobs 4
COPY . .
RUN bundle exec middleman build

FROM caddy:2-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /site/build /srv
