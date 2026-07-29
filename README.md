# app-ttrss

記事購読機能をコンテナで動かすためのリポジトリです。
データベース、アプリの永続領域、追加設定を指定した保存先へ置けます。

## 使い方

```bash
cp .env.example .env.local
./scripts/init-data-dirs.sh
docker compose --env-file .env.local up -d
```

既定では自動再起動しません。必要な期間だけ起動し、使い終わったら停止します。

```bash
docker compose --env-file .env.local stop
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
- `APP_BIND_ADDRESS`: 既定の`127.0.0.1`のまま使い、管理画面をホスト外部へ
  直接公開しません。
- `RESTART_POLICY`: 既定は `no` です。常時運用する場合だけ
  `unless-stopped` へ変更します。
- `TTRSS_DB_PASS`: データベースのパスワードです。必ず変更します。
- `TTRSS_SELF_URL_PATH`: ブラウザから見える正式な公開アドレスです。
- `APP_TTRSS__...`: 親リポジトリからまとめて設定するときに使います。

## データ

公開リポジトリに上げるもの:

- `compose.yaml`
- `.env.example`
- `scripts/`
- `README.md`

公開リポジトリに上げないもの:

- `.env.local`
- `data/app/`
- `data/db/`
- `data/config.d/`
- `ttrss_admin_password.txt`

既存環境から移す場合は、旧 `ttrss` ディレクトリを `HOST_DATA_DIR` に指定します。

## 補足

- すでに初期化済みで起動ログに初期パスワードが残っていない場合は、管理者パスワードを再設定してください。
- リバースプロキシ連携は親リポジトリ側の設定で扱います。
