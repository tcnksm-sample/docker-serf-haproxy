FROM ubuntu

# Install serf
RUN apt-get install -y unzip wget
RUN wget --no-check-certificat https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip -O serf.zip
RUN unzip serf.zip
RUN chmod +x serf
RUN mv serf /usr/bin/serf

# Install HAProxy
RUN apt-get -y install haproxy
RUN sed -i -e 's/ENABLED=0/ENABLED=1/' /etc/default/haproxy

# Install supervisor
RUN apt-get install -qy supervisor

# Install basic packages for ruby
RUN apt-get -y update
RUN apt-get install -y build-essential git
RUN apt-get install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install ruby-build
RUN git clone https://github.com/sstephenson/ruby-build.git .ruby-build
RUN .ruby-build/install.sh
RUN rm -fr .ruby-build

# Install ruby-2.1.0
RUN ruby-build 2.1.0 /usr/local

# Add Handler
ADD default_haproxy.cfg /etc/haproxy/haproxy.cfg
ADD supervisord-haproxy.conf /etc/supervisor/conf.d/supervisord-haproxy.conf
ADD handler.rb /handler.rb

EXPOSE 80
CMD ["supervisord", "-n"]
