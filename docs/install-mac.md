# インストール（macOS）

## 1. 配布物を選ぶ

[ダウンロード](download.md)からCPUに合うmacOS本体と`.sha256`を取得する。

- `.pkg`: `/Applications/NicoCache_nl`へ導入する通常のパッケージ
- `.dmg`: `NicoCache_nl`フォルダーを収録したディスクイメージ
- `.zip`: 任意の書き込み可能な場所へ展開するアプリイメージ

現在の配布物は専用Javaランタイムを含む。通常は外部Javaを導入しない。

## 2. 起動する

PKGを導入した場合は`/Applications/NicoCache_nl/NicoCache_nl`、DMGまたはZIPでは展開した
フォルダーの`NicoCache_nl`を実行する。このランチャーは同梱JREから起動管理GUIを開き、本体は
「本体を起動」を押すまで起動しない。

```sh
cd /Applications/NicoCache_nl
./NicoCache_nl
```

## 3. 初回セットアップ

初回セットアップでは、利用者データ、HTTPS MitM、ローカルCA、`proxy.pac`、ログイン時起動を
選択する。macOSの既定利用者データは`~/Library/Application Support/NicoCache_nl`である。

- CAの信頼登録: macOSの`security`
- 自動プロキシー: `networksetup`
- ログイン時起動: `~/Library/LaunchAgents`

OSの認証が必要な場合はmacOSの確認に従う。途中で失敗した場合は、その試行で行った変更を
ロールバックする。Firefoxが独自の証明書ストアを使う場合は、利用者データの`certs/ca.cer`を
Firefoxにも登録する。

## 4. 動作確認と削除

本体を起動し、`http://127.0.0.1:8080/`、`proxy.pac`、動画キャッシュを確認する。終了は
ランチャーの「本体を停止」を使う。

PKG/DMG/ZIPのアプリケーションを削除しても利用者データは自動削除されない。不要になった場合は
先に本体を停止し、CA、プロキシー、LaunchAgentの復元状態を確認してから利用者データを削除する。
