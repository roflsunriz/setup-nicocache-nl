# インストール（Linux）

## 1. パッケージを選ぶ

[ダウンロード](download.md)からCPUに合うLinux本体と`.sha256`を取得する。

- Debian、Ubuntu系: `.deb`
- Fedora、RHEL系: `.rpm`
- その他または任意の場所へ置く場合: `.zip`

DEB/RPMはアプリケーションを`/opt/nicocache-nl`へ配置し、`nicocache-nl`コマンドを登録する。
ZIPは書き込み可能な専用フォルダーへ展開する。すべて専用Javaランタイムを含むため、通常は
外部Javaを導入しない。

## 2. 導入して起動する

```sh
# Debian、Ubuntu系
sudo apt install ./NicoCache_nl-1.4.2-linux-x64.deb

# Fedora、RHEL系
sudo dnf install ./NicoCache_nl-1.4.2-linux-x64.rpm

# パッケージ版の起動
nicocache-nl
```

ZIPでは展開先のランチャーを実行する。

```sh
chmod +x NicoCache_nl NicoCacheDiagnostics
./NicoCache_nl
```

`NicoCache_nl`は同梱`jre/bin/java`から`NicoCacheLauncher.jar`を起動する。本体はランチャーの
「本体を起動」を押すまで起動しない。

## 3. 初回セットアップ

最初の通常起動では、次の4項目が推奨値として選択された初回セットアップを表示する。

1. 利用者データの保存先
2. HTTPS MitMと証明書生成
3. ローカルCAの信頼登録と`proxy.pac`
4. XDG autostartによるログイン時起動

Linuxの既定利用者データは、`XDG_DATA_HOME`があればその下の`NicoCache_nl`、なければ
`~/.local/share/NicoCache_nl`である。CA登録には`trust`、自動プロキシーにはGNOMEの
`gsettings`を使用する。利用できない機能や権限不足がある場合は失敗理由を表示し、その試行で
行った変更をロールバックする。

Firefoxが独自の証明書ストアを使う場合は、利用者データの`certs/ca.cer`をFirefoxの認証局へ
追加する。秘密鍵や`certs/`の内容は公開しないこと。

## 4. 動作確認

ランチャーから本体を起動し、次を確認する。

1. `http://127.0.0.1:8080/`に版が表示される
2. `http://127.0.0.1:8080/proxy.pac`を取得できる
3. ブラウザーで動画を再生すると利用者データの`cache/`へ保存される
4. ランチャーの「本体を停止」で本体と診断アプリが終了する

## 5. 手動JAR構成

開発・互換検証でJARを直接起動する場合だけ、Java 17・21・25 LTSを用意する。通常利用では
同梱ランタイムと`./NicoCache_nl`を使う。Solarisは配布・CI・アップデーターの対象外である。
