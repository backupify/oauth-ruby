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


# Install gems
RUN bundle install && \
    # Create a wrapper script to run tests with load path
    echo '#!/bin/bash\nruby -I"/usr/local/bundle/gems/mocha-0.9.8/lib" -I"lib:test" "$@"' > /usr/local/bin/ruby-with-gems && \
    chmod +x /usr/local/bin/ruby-with-gems

CMD ["bash"]
