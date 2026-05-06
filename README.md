# app-ttrss

Tiny Tiny RSS を Docker で動かすためのリポジトリです。
データベース、アプリの永続領域、追加設定を指定した保存先へ置けます。

## 使い方

```bash
cp .env.example .env.local
./scripts/init-data-dirs.sh
docker compose --env-file .env.local up -d
```

ブラウザで開く画面:

- `http://localhost:8280/tt-rss/`

初回の管理者パスワードを保存する場合:

```bash
./scripts/capture-admin-password.sh
```

## 変更する値

`.env.example` は公開用の見本です。実際の値は `.env.local` に書きます。

- `HOST_DATA_DIR`: ttrss の実データを置く場所です。
- `TTRSS_DB_PASS`: データベースのパスワードです。必ず変更します。
- `TTRSS_SELF_URL_PATH`: ブラウザから見える正式な URL です。
- `APP_TTRSS__...`: 親リポジトリからまとめて設定するときに使います。

## データ

GitHub に上げるもの:

- `compose.yaml`
- `.env.example`
- `scripts/`
- `README.md`

GitHub に上げないもの:

- `.env.local`
- `data/app/`
- `data/db/`
- `data/config.d/`
- `ttrss_admin_password.txt`

既存環境から移す場合は、旧 `ttrss` ディレクトリを `HOST_DATA_DIR` に指定します。

## 補足

- すでに初期化済みで起動ログに初期パスワードが残っていない場合は、管理者パスワードを再設定してください。
- リバースプロキシ連携は親リポジトリ側の設定で扱います。
