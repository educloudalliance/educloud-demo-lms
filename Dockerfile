FROM phusion/passenger-customizable:0.9.19
MAINTAINER Sampo Software devs team "shaliko.usubov@samposoftware.com"

ENV HOME /root
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

RUN rm -rf /var/lib/apt/lists/* && \
    apt-get update -qq && apt-get install -y ca-certificates build-essential libpq-dev imagemagick nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    bash -lc 'rvm install ruby-2.4.1 && rvm --default use ruby-2.4.1@saml-idp --create && gem install bundler'

RUN usermod -u 1000 app
RUN usermod -G staff app

ADD docker/nginx/env.conf /etc/nginx/main.d/env.conf
ADD docker/nginx/sites-enabled/web.conf /etc/nginx/sites-enabled/web.conf

RUN mkdir /home/app/web
ADD . /home/app/web
WORKDIR /home/app/web

RUN chown -R app:app /home/app/web
