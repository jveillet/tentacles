FROM ruby:2.6.1
# Bundler options
#
# The default value is taken from Heroku's build options, so they should be
# good enough for most cases. For development, be sure to set a blank default
# in docker-compose.override.yml.
ARG BUNDLER_OPTS="--without development:test \
                  --jobs 4 \
                  --deployment"

# Environment variables
ENV DEBIAN_FRONTEND="noninteractive"
ARG APP_HOME=/home/tentacles/app
ARG RACK_ENV="production"
ARG PORT=3000

# Install the Gems in the home directory for non-root users
ENV GEM_HOME=/home/tentacles/gems
ENV PATH=/home/tentacles/gems/bin:$PATH

# Fetch the last version of NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Install essentials softwares whith dev headers
RUN apt-get clean \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Gulp
RUN npm install --global gulp-cli

# Create a non-root user
RUN groupadd -r tentacles \
    && useradd -m -r -g tentacles tentacles

# Creating the path to the vendor directory because we have private gems
# that need to be installed and Docker fails to assume the correct
# permissions.
RUN mkdir -p ${APP_HOME} \
    && chown -R tentacles:tentacles ${APP_HOME}

# Move to the application folder
WORKDIR ${APP_HOME}

# Use the custom non-root user
USER tentacles

# Copy over the files, in case the Docker Compose file does not specify a
# mount point.
COPY --chown=tentacles:tentacles . ./

# Install Bundler dependencies
RUN bundle install ${BUNDLER_OPTS}

# Install local NPM dependencies
RUN npm install

# Expose the webserver port
EXPOSE ${PORT}

ENTRYPOINT ["bundle", "exec"]

CMD ["foreman", "start", "web"]
