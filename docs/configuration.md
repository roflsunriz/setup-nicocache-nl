# 設定とデータ管理

NicoCache_nl の設定は `config.properties` に保存する。既定値の一覧は `defaults/00_NicoCache.properties`、`defaults/10_NicoCache_nl.properties`、`defaults/25_NicoCache_nl_NEW.properties`、TLS 関連は `defaults/30_NicoCache_nl_TLS.properties` にある。既定ファイルは更新で置き換わるため、直接編集しないこと。

## 変更方法

1. NicoCache_nl を終了する。
2. `config.properties` をバックアップする。
3. 変更したいキーだけを記述または変更する。
4. 再起動し、`http://127.0.0.1:8080/` と動画再生で確認する。

`#` から始まる行はコメントである。設定ファイル先頭の文字コード判定用の行は削除しないこと。

## よく使う設定

| キー | 内容 |
|---|---|
| `listenPort=8080` | 待受ポート。変更時は PAC とブラウザー側設定も同じポートへ合わせる。 |
| `allowFrom=local` | 接続元を自分の PC に限定する既定値。LAN で公開する必要がない限り変更しない。 |
| `cacheFolder=` | 動画キャッシュの保存先。未指定時は `cache`。パスを変更する場合は空き容量とバックアップ方針を確認する。 |
| `needFreeSpace=100` | この空き容量（MB）を下回ると新しいキャッシュを停止する。 |
| `title=true` / `tidyTitle=true` | 新規キャッシュのファイル名へタイトルを使うか、整形するか。 |
| `resumeDownload=true` | 途中で止まった動画の取得を再開する。 |
| `cacheThumbnail=false` | サムネイルをローカルへ保存する。必要に応じて `thcacheFolder` と合わせて設定する。 |
| `localFileServer=true` | `/local/` のローカル資材配信を有効にする。既定で有効。 |
| `localFlv=true` | `/cache/` を利用したローカル再生支援を有効にする。 |
| `enableMitM=true` | HTTPS MitM を有効にする。証明書の生成・信頼・PAC 設定が完了している場合だけ使う。 |
| `userDataRoot=` | 利用者データの保存先。Windows パッケージ版では初回セットアップが絶対パスを設定する。 |

## キャッシュを削除・移動する前に

キャッシュ、サムネイル、コメントなどは利用者データ側に保存されます。削除前に NicoCache_nl を終了し、必要なファイルをバックアップしてください。アプリケーション本体を更新・削除しても、利用者データは自動削除されません。

キャッシュを外部から大きく移動・削除した後は、NicoCache_nl を再起動して状態を読み直してください。`checkRealCache=true` は外部操作を追跡しますが、大量移動時の負荷に注意が必要です。
