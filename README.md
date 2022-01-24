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

## License
MIT. See [LICENSE](./LICENSE) for more details.
