# 設定とデータ管理

NicoCache_nlの設定はアプリケーションルートの`config.properties`に保存する。既定値は用途別に
次のファイルへ分かれている。既定ファイルは更新で置き換わるため、直接編集しない。

- `defaults/application.properties`
- `defaults/network.properties`
- `defaults/video-cache.properties`
- `defaults/thumbnail-cache.properties`
- `defaults/rewriting.properties`
- `defaults/https-mitm.properties`
- `defaults/legacy-cache-compatibility.properties`

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
| `cacheThumbnail=true` | サムネイルをローカルへ保存する。必要に応じて `thcacheFolder` と合わせて設定する。 |
| `localFileServer=true` | `/local/` のローカル資材配信を有効にする。既定で有効。 |
| `localRewriter=true` | ローカル資材にも対象nlFilterを適用する。 |
| `enableMitm=true` | HTTPS MitMを有効にする。現行ニコニコ動画でキャッシュ・書き換えを使うために必要。 |
| `userDataRoot=` | 利用者データの保存先。初回セットアップがOS別の既定候補または選択した絶対パスを設定する。 |

設定キーは大文字・小文字を区別する。`enableMitM`ではなく`enableMitm`を使用する。

## キャッシュを削除・移動する前に

キャッシュ、サムネイル、コメント、証明書、追加した`local`・`nlFilters`・Extensionは利用者
データ側に保存される。削除前にランチャーから本体を停止し、必要なファイルをバックアップする。
アプリケーション本体を更新・削除しても、利用者データは自動削除されない。

キャッシュを外部から大きく移動・削除した後は、NicoCache_nl を再起動して状態を読み直すこと。`checkRealCache=true` は外部操作を追跡するが、大量移動時の負荷に注意が必要である。
