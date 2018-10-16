FROM heroku/heroku:18

# Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV APP_HOME=/home/tentacles/src/tentacles
ENV RACK_ENV=development
ENV JEKYLL_ENV=development
ENV BUNDLE_APP_CONFIG=$APP_HOME/.bundle/
ENV BUNDLE_JOBS=10
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV PORT 3000

# Create the home directory for the new app user.
RUN mkdir -p $APP_HOME

# Copy the files needed for bundler and NPM
COPY Gemfile* $APP_HOME/
COPY package* $APP_HOME/
COPY .env $APP_HOME/

# Fetch the last version of Nodejs 8
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

# Install essentials softwares whith dev headers
RUN apt-get clean \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    ruby2.5-dev \
    sudo \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-gnutls-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install the last bundler version
# It is not available with the Heroku image
RUN gem install bundler --no-ri --no-rdoc

# Install Gulp
RUN npm install --global gulp-cli

# Add local user to sudo group
RUN useradd -ms /bin/bash tentacles
RUN echo '%tentacles ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy local files to the container and apply rights to the user
COPY . $APP_HOME/
RUN chown -hR tentacles:tentacles /home/tentacles/

# Move to the application folder
WORKDIR $APP_HOME

# Use custom user
USER tentacles

# Install Bundler dependencies
RUN bundle config
RUN bundle install

# Install local NPM dependencies
RUN npm install

EXPOSE 3000

RUN unset BUNDLE_PATH
RUN unset BUNDLE_BIN

ENTRYPOINT ["bundle", "exec"]

CMD ["foreman", "start", "web"]
