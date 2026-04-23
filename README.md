# app-ttrss

Tiny Tiny RSS を独立リポジトリとして扱うための新しい正本候補です。旧 installer のテンプレート展開をやめて、repo 単独で起動できる構成に寄せています。

## 起動

```bash
cp .env.example .env.local
./scripts/init-data-dirs.sh
docker compose up -d
```

ブラウザ:

- `http://localhost:8280/tt-rss/`

`APP_PORT` を変える場合は `.env.local` の `TTRSS_SELF_URL_PATH` も合わせて更新してください。

## 管理対象

Git に含めるもの:

- `compose.yaml`
- `.env.example`
- `scripts/`
- `README.md`

Git に含めないもの:

- `.env.local`
- `data/app/`
- `data/db/`
- `data/config.d/`

## 初期化

```bash
./scripts/init-data-dirs.sh
```

初回起動後に管理者初期パスワードを保存する場合:

```bash
./scripts/capture-admin-password.sh
```

保存先:

- `./ttrss_admin_password.txt`

## 補足

- 旧 installer と同様に、初回ログから admin password を採取して `ttrss_admin_password.txt` に保存できます
- すでに初期化済みで起動ログに初期パスワードが残っていない場合は、admin password を再設定して同じファイルへ保存します
- reverse proxy 連携は別 override file で追加する想定です
