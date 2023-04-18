# Design Doc: compose-cd

## 背景

- CI/CD(Continuous Integration/Deployment)は最高
  - ここでの雰囲気は以下
  - CI: 全部Git管理してcommit毎に色々検証
    - これでPull Request上でマズいものはチェックする
  - CD: HEADのものを自動でどーんとデプロイ
  - k8s+ArgoCDによる最高の体験
- `docker-compose` でもContinuous Deploymentしたい！
  - k8s+ArgoCDは素晴らしいが，環境構築もメンテもダルい
  - コストに見合わない単純な(`docker-compose`で十分な)やつでもどうにかならんか
- 開発場所とデプロイ先を分けたい
  - デプロイ先で `docker-compose build` とかやりたくない
  - → イメージは(ちゃんとビルド・プッシュして)コンテナレジストリから
  - → 設定ファイル群はGit管理
  - `git pull` と `docker-compose up -d`だけでデプロイしたい(するようにしている)

## 課題

- `docker-compose` で立てたサービスの更新がダルい
  - イメージの更新がダルい
    - 例: `:latest`
    - `:v1.0` とかでも実際のイメージ(digest)は裏でどんどん更新されていくことは多い
    - 新しいものがあるなら更新したい(逆に，真にイメージを固定したいならdigest pinningするべき)
  - 設定とかも更新したい
    - `git pull` して `docker-compose down/up -d` するだけではある
    - めんどい


## 概要

- 定期的に以下を実行するスクリプト
  - `git pull`
  - `docker-compose pull`
  - `docker-compose down`
  - `docker-compose up -d`

## 実装

### compose-cd(本体)

- Shell script(Bash)
  - 移植性を考えるとBashはやや微妙だが，`docker-compose`を使うような環境では問題ないだろう
- 定期実行部以外のすべての実装はこのファイル1つに集約(ポン置きで動く)
- 設定ファイルは `/etc/compose-cd/config` (`compose-cd install`時に生成)
  - グローバルな設定を `HOGE=value` の形でしておき，実態としては `source` するだけ
  - `DISCORD_WEBHOOK`: 
### 定期実行部分

- `compose-cd update` を定期的に実行する
- systemd timerで実装
- 定期実行以外に要求は無いので実際はcronでも雑なスクリプトでのループでもよい