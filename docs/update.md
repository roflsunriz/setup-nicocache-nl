# NicoCache_nl のアップデート

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

新しい配布物を別フォルダーに展開してから、既定資材と追加資材を混在させないように移行してください。`defaults/` や標準 `local/`・nlFilter を旧版から上書きすると、現行の設定・TLS対象・ページ対応が古いまま残るおそれがあります。

更新後に HTTPS キャッシュが動かない場合は、`config.properties` の古い `mitmHostPort` を残していないか、`defaults/30_NicoCache_nl_TLS.properties` が新しい配布物のものかを確認します。証明書の作り直しは、必要な場合だけ [TLS の手順](install-linux.md#https-mitm-の設定) に従ってください。
