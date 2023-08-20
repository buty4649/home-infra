# home-infra

@buty4649 の自宅インフラを構成管理するリポジトリ

## Usage

### 初回のみ

1. `attributes/secret/keys/default` 配下に秘密の鍵を配置する。
2. `bundle install`
3. sshできるようにsshd_configを設定する
  - パスワード認証できないようなので公開鍵認証でログインできるようにしておく

### deploy

```
☆ dry-run
❯ bundle exec hocho apply b-gateway --sudo --dry-run

❯ bundle exec hocho apply b-gateway --sudo
```
