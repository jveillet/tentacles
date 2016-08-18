#!/bin/sh

USERNAME=tentacles
USERGROUP=tentacles
HOMEDIR=/home/${USERNAME}
UID=$(id -u)
GID=$(id -g)

FILE="
FROM ruby:2.2.3-slim\n
\n
# Define local mirror (if this one fail, just change http://ftp2.fr to http://ftp2.de)\n
RUN echo \"deb http://security.debian.org/ jessie/updates main contrib non-free\" > /etc/apt/sources.list\n
RUN echo \"deb-src http://security.debian.org/ jessie/updates main contrib non-free\" >> /etc/apt/sources.list\n
RUN echo \"deb http://ftp2.fr.debian.org/debian/ jessie main contrib non-free\" >> /etc/apt/sources.list\n
RUN echo \"deb-src http://ftp2.fr.debian.org/debian/ jessie main contrib non-free\" >> /etc/apt/sources.list\n
\n
RUN apt-get clean && apt-get update -y \\ \n
\t\t&& apt-get install -y --no-install-recommends git-core build-essential sudo libxml2-dev libssl-dev libpq-dev libxslt-dev \\ \n
\t\t&& rm -rf /var/lib/apt/lists/*\n
\n
# Add ${USERNAME} user to sudo group\n
RUN groupadd -f -g ${GID} ${USERGROUP}\n
RUN useradd -m -u ${UID} -g ${USERGROUP} ${USERNAME}\n
RUN echo '%${USERNAME} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers\n
\n
RUN mkdir -p /app\n
RUN mkdir -p /bundle\n
\n
WORKDIR /app\n
\n
COPY Gemfile /app/\n
COPY Gemfile.lock /app/\n
\n
# Give access to ${USERNAME} user\n
RUN chown -R ${USERNAME}:${USERGROUP} /app\n
RUN chown -R ${USERNAME}:${USERGROUP} /bundle\n
RUN chown -R ${USERNAME}:${USERGROUP} ${HOMEDIR}\n
\n
USER ${USERNAME}\n
\n
# Set bundler config\n
ENV BUNDLE_JOBS=10 \\ \n
    BUNDLE_PATH=/bundle \\ \n
    BUNDLE_APP_CONFIG=/app/.bundle-docker/\n
\n
# throw errors if Gemfile has been modified since Gemfile.lock\n
RUN bundle config\n
RUN bundle install --clean\n
\n
COPY . /app/\n
\n
 # Server
EXPOSE 3000
ENV PORT 3000
"

# Create Dockerfile and put the configuration in it
rm -f Dockerfile
touch Dockerfile
echo ${FILE} >> Dockerfile

# launch the docker environement setup
docker-compose build

# launch the bundle install (gem install)
docker-compose run --rm web bundle install
