# 手動インストール（macOS）

macOS では [共通の手動インストール手順](install-linux.md) に従う。Java を導入し、展開先で `./NicoCache_nl.sh` または `java -jar NicoCache_nl.jar` を実行すること。

HTTPS を利用する場合は `genCerts.sh` で生成した `certs/ca.cer` をキーチェーンアクセスから信頼できる認証局として登録し、ブラウザーのプロキシー自動設定へ `http://127.0.0.1:8080/proxy.pac` を指定する。証明書の信頼範囲は必要な範囲に限定し、不要になった CA はキーチェーンから削除すること。

ログイン時起動は LaunchAgent など、macOS 標準の方法で設定する。アプリの実体・作業ディレクトリ・`userDataRoot` が一致するように指定すること。
