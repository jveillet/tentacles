# Tentacles
All the pull requests from your repositories (and the organizations you belong to) currated into a single web page.
All the results are displayed in a Github fashion (like the Pulls tab), but separated by repo.

_(Screencap coming later)_

__*This is a very very early development version, use at your own risks.*__

## Configuration

Create a Github Connected app via your picture profile > Settings > OAuth applications > Developer applications > Register a new application.

Add this Github settings for your connected app into a .env file in the root of the project:

```bash
PORT=<Your-Webserver-port>
GH_CLIENT_ID=<Your-Github-connected-app-client-Id>
GH_CLIENT_SECRET=<Your-Github-connected-app-client-secret>
GH_CALLBACK_URL=<Your-Tentacles-OAuth-Callback-URL>
```

## Installation (using docker)

```bash
git clone git@github.com:jveillet/tentacles.git
cd tentacles/
sh install.sh
docker-compose up
```
