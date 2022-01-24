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

## License
MIT. See [LICENSE](./LICENSE) for more details.
