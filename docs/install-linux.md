# 手動インストール（Linux・macOS・Solaris）

Windows 以外では、配布アーカイブを展開して Java から起動する。OS のパッケージ名や証明書ストアの操作はディストリビューションごとに異なるため、ここでは NicoCache_nl 側の共通手順を示す。

## 1. 配布物を検証して展開する

[配布元](download.md)から本体を取得し、提供されている SHA-256 を確認してから、書き込み可能な専用フォルダーへ展開する。キャッシュと証明書を含むため、共有・一時フォルダーには置かないこと。

## 2. Java を確認する

手動起動には Java が必要である。現行本体では Java 17・21・25 の運用経路があり、対応する LTS を使用する。

```sh
java -version
cd /path/to/NicoCache_nl
java -jar NicoCache_nl.jar
```

Unix 系の同梱スクリプトを使う場合は、次でも起動できる。`NICOCACHE_JAVA` で Java 実行ファイル、`NICOCACHE_OPTS` で JVM オプションを指定できる。

```sh
chmod +x NicoCache_nl.sh
./NicoCache_nl.sh
```

既定ポートは `8080` である。`http://127.0.0.1:8080/` にアクセスし、バージョンが表示されることを確認する。

## 3. HTTPS MitM の設定 { #https-mitm-の設定 }

HTTPS のキャッシュやページ書き換えには、CA と対象サイト証明書が必要である。

1. `certificate-targets.txt` の対象ドメインを確認する
2. `./genCerts.sh` を実行する
3. 生成された `certs/ca.cer` を、使用するブラウザーまたは OS の信頼済み認証局ストアへ登録する
4. `config.properties` に `enableMitM=true` を設定する
5. ブラウザーのプロキシー自動設定で `http://127.0.0.1:8080/proxy.pac` を指定する

Firefox など独自の証明書ストアを使うブラウザーでは、OS への登録とは別に `ca.cer` のインポートが必要である。CA を作り直す必要がある場合だけ、`certs/` の `ca.`・`site.` で始まる生成ファイルを安全にバックアップしてから削除し、再生成後に証明書を登録し直す。秘密鍵や `certs/` の内容は公開しないこと。

## 4. 設定と利用者データ

`config.properties.default` は説明用のひな型である。変更したい設定だけを `config.properties` に記述する。`defaults/` を直接編集すると更新で失われる。

主要な設定は次のとおりである。

| 設定 | 既定・用途 |
|---|---|
| `listenPort` | 待受ポート。既定は `8080`。変更時はブラウザー側の PAC も合わせる。 |
| `userDataRoot` | 利用者データの保存先。相対パスはアプリケーションフォルダー基準。 |
| `cacheFolder` | 動画キャッシュの保存先。未指定時は `cache`。 |
| `needFreeSpace` | 新規キャッシュを停止する空き容量の下限（MB）。既定は 100。 |
| `cacheThumbnail` / `thcacheFolder` | サムネイルキャッシュと保存先。 |
| `enableMitM` | HTTPS MitM を有効化する。CA 信頼・PAC と組み合わせる。 |

## OS ごとの補足

[macOS](install-mac.md) と [Solaris](install-solaris.md) は、この手動手順にそれぞれの証明書・自動起動方法を組み合わせる。
