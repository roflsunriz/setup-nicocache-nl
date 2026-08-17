# NicoCache_nl とは

NicoCache_nl は、ニコニコ動画向けのローカル HTTP/HTTPS プロキシー兼キャッシュサーバーである。ブラウザーとニコニコ動画の間で動作し、動画・サムネイル・ページ用資材をローカルに保存して、次回以降の再生や表示を支援する。

## できること

- 現行のDomand/CMAF動画キャッシュを保存し、ネットワークに接続できない場合にも保存済みの動画を再生する
- `cache/` の動画、`thcache/` のサムネイル、コメント保存などを管理する
- `/local/` で JavaScript・CSS・HTML などを配信し、`nlFilters` でニコニコ動画のページを置換する
- Java Extension でプロキシーの処理、書き換え、完了通知などを拡張する
- 独立アップデーターから NicoCache_nl 本体と管理対象の外部依存関係を確認・更新する

HTTPS の通信内容を扱うには、初回セットアップで HTTPS と証明書の信頼を有効にする必要がある。証明書を信頼しない構成では、HTTPS のキャッシュ・書き換えは利用できない。

## はじめに

Windows、Linux、macOSでは、GitHub ReleaseのOS別自己完結パッケージまたはZIPを推奨する。
専用Javaランタイムを含むため、通常利用でJavaやビルドツールを別途導入する必要はない。
初回起動時に、利用者データ、HTTPS証明書、OSの自動プロキシー、ログイン時起動を選択できる。

1. [ダウンロード](download.md) から現行の配布物を入手する
2. [Windows](install-win.md)、[Linux](install-linux.md)、[macOS](install-mac.md)の手順に従う
3. NicoCache_nl を起動し、`http://127.0.0.1:8080/` を開いてバージョンが表示されることを確認する
4. ブラウザーで動画を再生し、利用者データフォルダーの `cache/` に保存されることを確認する

導入後の本体と外部依存関係の管理には、専用 Java ランタイムを含む[独立アップデーター](update.md#standalone-updater)を使用できる。

Solarisは配布・CI・アップデーターの対象外である。

## ファイルの置き場所

現行パッケージ版は、アプリケーション本体と利用者データを分ける。更新・再インストールで
個人のキャッシュや設定を上書きしないためである。

| 種類 | 保存先 | 扱い |
|---|---|---|
| アプリケーション | OS別パッケージまたはZIPの導入先 | 本体、既定の`local`・nlFilter、サンプルExtension。手編集しない。 |
| 利用者データ | 初回セットアップで選ぶ場所 | キャッシュ、証明書、追加した`local`・`nlFilters`・Extension、個人設定。 |
| 設定の接点 | アプリケーション側の `config.properties` | `userDataRoot` に利用者データの絶対パスを保存する。 |

標準資材を先に読み、利用者データ側の同名ファイルを後から適用する。カスタマイズは利用者データ側に置くこと。

既定候補はWindowsがドキュメント内の`NicoCache_nl`、Linuxが
`$XDG_DATA_HOME/NicoCache_nl`または`~/.local/share/NicoCache_nl`、macOSが
`~/Library/Application Support/NicoCache_nl`である。

## 安全上の注意

- CA 証明書の信頼と Windows の自動プロキシーは、内容を理解し、初回セットアップで明示的に選んだ場合だけ有効にすること。
- `certs/` には秘密鍵が含まれる。共有、公開、コミットをしないこと。
- 不具合報告のログや画面にはユーザー ID・URL などが含まれることがある。公開前に確認すること。
- 標準外の nlFilter・Extension は信頼できる配布元のものだけを追加すること。
