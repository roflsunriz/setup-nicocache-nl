# NicoCache_nl のアップデート

## 独立アップデーターを使う方法（Windows、推奨） { #standalone-updater }

独立アップデーターは、NicoCache_nl 本体の更新と管理対象の外部依存関係の更新を一つの GUI から実行する。本体とは別の専用 Java ランタイムで動作し、ダウンロード、ハッシュ検証、バックアップ、適用、失敗時の復元を担当する。

1. 使用中の NicoCache_nl を GUI から終了する。
2. [GitHub Release](download.md#standalone-updater-download) から `NicoCache_nl-Updater-<updater-version>.msi` と対応する `.msi.sha256` を取得し、SHA-256 を照合する。
3. MSI をインストールし、スタートメニューまたはデスクトップの **NicoCache_nl Updater** を起動する。
4. 画面上部の「NicoCache_nl本体」に表示された更新対象を確認する。「未インストール」または別のフォルダーが表示された場合は「変更…」を押し、`NicoCache_nl.exe` または `NicoCache_nl.jar` があるインストール先を選ぶ。選択した場所は次回起動用に保存される。
5. 「NicoCache_nl」タブで「更新を確認」を押し、導入版と最新版を確認する。
6. 更新がある場合は「NicoCache_nlを更新」を押して確認画面を承認する。アップデーターが MSI と SHA-256 を取得・検証した後、Windows Installer を起動する。
7. Windows Installer を完了し、NicoCache_nl を起動する。`http://127.0.0.1:8080/` でバージョンを確認し、動画再生とキャッシュ作成を確認する。

外部依存関係も同じアップデーターで更新できる。対象と操作方法は[依存関係ソフトウェアの更新](update-dependencies.md#standalone-updater-dependencies)を参照すること。

## Windows MSI 版

1. 使用中の NicoCache_nl を GUI から終了する。
2. [GitHub Release](download.md) から新しい MSI と SHA-256 を取得し、ハッシュを照合する。
3. 新しい MSI を実行する。同じ製品として更新され、`config.properties` と利用者データは保持される。
4. 起動後、`http://127.0.0.1:8080/` でバージョンを確認し、動画再生とキャッシュ作成を確認する。

更新中に CA 証明書、Windows 自動プロキシー、自動起動を取り消す必要はない。これらはアンインストール時だけ、初回セットアップ前の状態へ戻す。

## ZIP・手動配置版

本体を上書きする前に、少なくとも次を別の場所へバックアップする。

- `config.properties`
- `certs/`（秘密鍵を含むため安全な場所へ）
- `cache/`、`thcache/`、`data/`
- 自分で追加した `local/`、`nlFilters/`、Extension

新しい配布物を別フォルダーに展開してから、既定資材と追加資材を混在させないように移行すること。`defaults/` や標準 `local/`・nlFilter を旧版から上書きすると、現行の設定・TLS 対象・ページ対応が古いまま残るおそれがある。

更新後に HTTPS キャッシュが動かない場合は、`config.properties` の古い `mitmHostPort` を残していないか、`defaults/30_NicoCache_nl_TLS.properties` が新しい配布物のものかを確認する。証明書の作り直しは、必要な場合だけ [TLS の手順](install-linux.md#https-mitm-の設定) に従うこと。
