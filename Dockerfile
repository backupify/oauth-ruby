FROM ubuntu:14.04

ENV CFLAGS="-Wno-error -Wno-error=format-security -Wno-deprecated-declarations"
ENV CXXFLAGS="$CFLAGS"
ENV GEM_HOME="/usr/local/bundle"
ENV PATH="$GEM_HOME/bin:$PATH"
ENV BUNDLE_PATH="$GEM_HOME"
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV RUBYLIB="/usr/local/bundle/gems/mocha-0.9.8/lib"

RUN apt-get update && apt-get install -y software-properties-common && \
    apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    zlib1g-dev \
    libreadline-dev \
    libyaml-dev \
    ruby2.5 \
    ruby2.5-dev \
    bundler \
    rake \
    libcurl4-openssl-dev \
    libcurl3 \
    libcurl3-dev

WORKDIR /app
COPY . .
RUN rm -f Gemfile.lock

# Install development dependencies first    
RUN gem install rake -v '10.5.0' --no-ri --no-rdoc && \
    gem install json_pure -v '1.4.3' --no-ri --no-rdoc && \
    gem install jeweler -v '1.4.0' --no-ri --no-rdoc --ignore-dependencies && \
    gem install mocha -v '0.9.8' --no-ri --no-rdoc --ignore-dependencies && \
    gem install webmock -v '1.6.4' --no-ri --no-rdoc --ignore-dependencies && \ 
    gem install ffi -v '1.9.25' --no-ri --no-rdoc --ignore-dependencies && \
    gem install test-unit -v '3.0.9' --no-ri --no-rdoc && \
    gem install minitest -v '5.12.0' --no-ri --no-rdoc && \
    gem install racc -v '1.4.14' --no-ri --no-rdoc && \
    gem install nokogiri -v '1.10.10' --no-ri --no-rdoc

# Now install all gems through bundler
RUN bundle install && \
    # Create a wrapper script to run tests with proper load path
    echo '#!/bin/bash\nruby -I"/usr/local/bundle/gems/mocha-0.9.8/lib" -I"lib:test" "$@"' > /usr/local/bin/ruby-with-gems && \
    chmod +x /usr/local/bin/ruby-with-gems

CMD ["bash"]
