FROM heroku/heroku:16

RUN apt-get clean && apt-get update -y \
    && apt-get install -y --no-install-recommends git-core build-essential sudo libffi-dev libxml2-dev libssl-dev curl apt-utils\
    && rm -rf /var/lib/apt/lists/*

# Add wef user to sudo group
RUN useradd -ms /bin/bash tentacles
RUN echo '%tentacles ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /tentacles /bundle

WORKDIR /tentacles

COPY Gemfil* /tentacles/

# Give access to tentacles user
RUN chown -hR tentacles:tentacles /tentacles /bundle

USER tentacles

 # Set bundler config
ENV BUNDLE_JOBS=10 \
    BUNDLE_PATH=/bundle \
    BUNDLE_APP_CONFIG=/tentacles/.bundle-docker/

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config
RUN bundle install --clean

COPY . /tentacles/

EXPOSE 3000
ENV PORT 3000
