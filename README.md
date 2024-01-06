# compose-cd
[![shellcheck](https://github.com/sksat/compose-cd/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/sksat/compose-cd/actions/workflows/shellcheck.yml)
[![latest release](https://img.shields.io/github/v/release/sksat/compose-cd)](https://github.com/sksat/compose-cd/releases/latest)
![release date](https://img.shields.io/github/release-date/sksat/compose-cd)
[![license](https://img.shields.io/github/license/sksat/compose-cd)](https://github.com/sksat/compose-cd/blob/main/LICENSE)
![stars](https://img.shields.io/github/stars/sksat/compose-cd?style=social)
![downloads](https://img.shields.io/github/downloads/sksat/compose-cd/total)
![code size](https://img.shields.io/github/languages/code-size/sksat/compose-cd)

Continuous Deployment for docker-compose

## Install
```sh
$ wget https://github.com/sksat/compose-cd/releases/latest/download/compose-cd.tar.zst
$ tar xvf compose-cd.tar.zst
$ ./compose-cd install
    --search-root "/srv"
    --git-pull-user <user for `git pull`>
    --discord-webhook "https://discord.com/api/webhooks/*****"
```

## Dependencies
- `bash`
- `find`
- `getopt`
- `git`
- `curl`
- `jq`
- `sudo`
- `docker`
- `docker-compose`
- `systemd`

## How to use

```sh
$ mkdir /srv && cd /srv
$ git clone <compose-cd managed repository> # example: https://github.com/sksat/mc.yohane.su
```

Please add `.compose-cd` file to the same directory of `docker-compose.yml`.

## How it Works

`compose-cd` finds `docker-compose` services including `.compose-cd` in the same directory as `docker-compose` configuration(`docker-compose.yml`).

The main feature of `compose-cd` is `compose-cd update` command.
It loads common configuration from `/etc/compose-cd/config` and update services under `SEARCH_ROOT`.
This "update" includes following

- `git pull`
- `docker-compose pull`

`compose-cd update` runs every minute by systemd timer([compose-cd.timer](https://github.com/sksat/compose-cd/blob/main/compose-cd.timer)).

## FAQ

### compose-cd manages a Git repository?
No. `compose-cd` manages `docker-compose` services including `.compose-cd`.

So, we can create monorepo that includes `compose-cd` managed `docker-compose` services.
In this use case, it is highly recommended to use `compose-cd` version 0.4+ because `.compose-apply` behavior changed(ref: #30).

### How to limit the files that cause a restart?
Please add `.compose-apply` file to the same directory of the `.compose-cd`.
Write the list of files you want to trigger restart in this file.
It supports wildcard.

example: [mc.yohane.su](https://github.com/sksat/mc.yohane.su/blob/main/.compose-apply)

### How to use private repository?
`compose-cd` just executes `git pull` on `GIT_PULL_USER`.
Please use SSH type remote-url.

GitHub's [deploy keys](https://docs.github.com/en/developers/overview/managing-deploy-keys) would be useful.
Other Git hosting services probably have similar features.

### How to use private container image?
`compose-cd` just executes `docker-compose pull`.
Please run `docker login` beforehand.

### How to pin container image from configuration files?
Please use following option to prevent pull container image without changes on Git repository.
```sh
UPDATE_REPO_ONLY=true
UPDATE_IMAGE_BY_REPO=true
```

It is also recommended to [digest pinning](https://docs.renovatebot.com/docker/#digest-pinning) in `docker-compose.yml` like following.
```yaml
services:
  paper:
    image: ghcr.io/sksat/papermc-docker:1.18.1@sha256:6b100740af773991eb8f7d15d3f249b54a17c5be679c2a70d0c5b733e63e50a0
```
At first glance, updating this configuration may seem to be very tedious, but it is possible to automate this update using [Renovate Bot](https://renovatebot.com).

Example:
  - https://github.com/sksat/mc.yohane.su/pull/232


### How to to not bring down containers, only run docker compose up

Sometimes you don't want to bring the stack down before running docker-compose up. This allows docker-compose to decide which containers actually require restarts.

If this is what you want, then add `SERVICE_UP_ONLY` to your `.compose-cd` file, like this:

```
SERVICE_UP_ONLY=true
```

### How to inject secrets from a password manager

If you are using a password manager like 1Password, you can instruct compose-cd to use an alternate command to bring up the docker-compose stack. 

For 1Password Connect Server, install the application, then add the environment variables to the service configuration.
Add the following to the installed service, by running `systemctl edit compose-cd`: 

```
[Service]
# Set environment variables related to your custom_up_command(s)
Environment="OP_CONNECT_HOST=https://op.your.domain"
Environment="OP_CONNECT_TOKEN=yourconnecttoken"
```


Then within each docker-compose stack you can create op.env file with your configuration values.

```
POSTGRES_SERVER="op://vault-name/coder/database/server"
POSTGRES_DB="op://vault-name/coder/database/db"
POSTGRES_USER="op://vault-name/coder/database/user"
POSTGRES_USER_PW="op://vault-name/coder/database/password"
```

Following the [secrets-reference-syntax](https://developer.1password.com/docs/cli/secrets-reference-syntax/), these configuration items and secrets will be supplies whenever the docker compose stack is recreated, and the secrets never have to hit the filesystem or your monorepo (except of course in the container definition files...).

Finally, inside of your `.compose-cd` file, specify a custom up command. When using `op`, it should look like this:

```
CUSTOM_UP_COMMAND=op run --env-file=op.env -- docker compose up -d
```

This will use op to fetch the secret references and feed it to Docker Compose. Note that the secrets are still being baked into their respective container configurations, but they will not otherwise touch the filesystem.

Finally, if the secrets change, the same command will cause the containers to be rebuilt - but otherwise running `op run --env-file=op.env -- docker compose up -d` when the stack is already running will not cause any container restarts.


## Blog
- [マイクラサーバをGitHubで運用する](https://sksat.hatenablog.com/entry/2021/08/26/015620)

## Slide
- VRC-LT #9
[![slide page 0](https://speakerd.s3.amazonaws.com/presentations/3b08ab8f117b4696ba0f74aaedc91515/slide_0.jpg)](https://speakerdeck.com/sksat/teleka-dot-suwozhi-eruji-shu)

- さくらのマイクロコミュニティ マイクラサーバ管理者の会 #2
[![slide_page_0](https://files.speakerdeck.com/presentations/5b91a59141ae403580dbee3738f8a549/slide_0.jpg)](https://speakerdeck.com/sksat/mo-guo-falsesabaguan-li-zhe-yo-zi-dong-hua-seyo)

## License
MIT. See [LICENSE](./LICENSE) for more details.
