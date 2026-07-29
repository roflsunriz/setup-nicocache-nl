# 手動インストール（Solaris）

Solaris では [共通の手動インストール手順](install-linux.md) に従います。使用できる Java の版を `java -version` で確認してから、展開先で `./NicoCache_nl.sh` または `java -jar NicoCache_nl.jar` を実行します。

HTTPS を使う場合は `genCerts.sh` により `certs/ca.cer` を生成し、使用するブラウザーまたは OS の信頼済み認証局へ登録します。ブラウザーのプロキシー自動設定 URL は `http://127.0.0.1:8080/proxy.pac` です。

サービス化・ログイン時起動は、Solaris の運用方針に応じて SMF またはユーザーセッション側で設定します。すべての利用者へ開放する必要がない限り、`allowFrom=local` を維持してください。
