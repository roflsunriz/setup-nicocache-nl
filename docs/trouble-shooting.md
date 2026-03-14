# トラブルシューティング
<div style="text-align: right;">最終更新日：2026/03/14</div>
---

以下の手順を0から順に実行して、原因を特定する。  
全て試しても解決しない場合は「[10. まだ問題が解決しない](#10-まだ問題が解決しない)」のテンプレートを使ってスレッドに質問する。

---

## 0. ログウィンドウの調査

NicoCache_nlのログウィンドウを最初から最後まで読む。

- `no method:` が表示されている → 拡張機能が動作していない（コンパイル漏れ、または依存する拡張機能が未導入）
- `java.lang~Exception` / `java.util~Exception` / `java.net~Exception` などのエラーが出ていないか確認する
- その他、ファイルが正常に読み込まれているかも確認する

---

## 1. 本体の更新

NicoCache_nl本体を最新版に更新して変化を確認する。

最新版かどうかは [NicoCache関連ファイル置き場 避難所](https://nicocache.jpn.org/) にあるファイル名の日付と、コンソールまたは `localhost:8080` に表示されるバージョン文字列を照合する。

古い場合は差分をダウンロードし、[アップデート](update.md) の手順に従ってビルド・再起動する。

---

## 2. 拡張機能・nlFiltersの取り外し

extensionsとnlFiltersを外して変化を確認する。

| 結果 | 原因 |
|------|------|
| 外しても問題が継続する | 拡張機能・nlFilters以外に原因がある |
| 外したら問題が消えた | 拡張機能またはnlFiltersが原因 |

さらに絞り込むには、問題のある拡張機能・nlFilter以外を外す。

> `extensions` / `nlFilters` フォルダは直下のサブフォルダ内のファイルを認識しない。この仕様を利用して退避できる。

### 拡張機能の外し方

`extensions` ディレクトリ直下のデフォルト以外の `.class` / `.java` ファイルを取り除くか、リネームする。

**デフォルトファイル構成**

```
extensions/
├── addTabSample.java
├── build.cmd
├── completeCacheSample.java
├── eventListenerSample.java
├── extLoggerSample.java
├── makedoc.cmd
└── readme.txt
```

**退避例**（`使ってない` フォルダに移動）

```
extensions/
├── ...（デフォルトファイル）
└── 使ってない/
    ├── NGCommentExtension.class
    └── NGCommentExtension.java
```

**拡張機能を外したら要再起動。**

### nlFiltersの外し方

`nlFilters` ディレクトリ直下のデフォルト以外の `.txt` ファイルを取り除くか、リネームする。

**デフォルトファイル構成**

```
nlFilters/
├── 01_globalFilter.txt
├── 05_topBarFilter.txt
├── 06_topBarが2段になるのを解消.txt
├── 10_thumbInfoFilter(ポップアップリンク用).txt
├── 15_thumbInfoFilter(基本).txt
├── 20_watchFilter.txt
└── 99_3列Filter+mod.txt
```

---

## 3. Java・ブラウザの更新

JavaとブラウザをLTS最新版に更新して変化を確認する。

**Javaのバージョン確認**

```
java -version
```

更新後は要再起動。ダウンロード: [Eclipse Temurin OpenJDK](https://adoptium.net/)

**ブラウザの更新**

- [Google Chrome](https://www.google.co.jp/chrome/browser/desktop/)
- [Mozilla Firefox](https://www.mozilla.org/ja/firefox/new/)

更新後はブラウザを再起動する。

---

## 4. ブラウザの変更

別のブラウザで問題が再現するか確認する。

| 結果 | 原因 |
|------|------|
| 別ブラウザでも問題が再現する | ブラウザ固有の問題ではない |
| 別ブラウザでは問題が消えた | ブラウザの拡張機能・プラグイン・ZenzaWatch・Userscriptなどが原因 |

---

## 5. NicoCache_nlの切り離し

NicoCache_nlを経由しない状態で問題が再現するか確認する。

`proxy.pac` を外してNicoCacheを通さずに問題のページにアクセスする。  

- Chromeの場合はWindowsの設定からプロキシを外す。
- 設定を開く→「プロキシ」で検索→「プロキシ設定を開く」をクリック→「LANの設定(L)」のボタンをクリック→「自動構成スクリプトを使用する(S)」のチェックを外す
- Firefoxの場合はメニュー → **設定** → **プライバシーとセキュリティ** → **ネットワーク設定** → **接続設定(E)...** → **直接接続(D)** にチェックを入れる

| 結果 | 原因 |
|------|------|
| 外したら正常に視聴できる | NicoCache_nlが原因 |
| 外しても正常に視聴できない | ブラウザ・OS・ネットワーク設定が原因（NicoCache_nlは無関係）|

---

## 6. キャッシュの削除

ブラウザのキャッシュとNicoCacheのキャッシュを削除してNicoCacheを再起動する。  
watchページのキャッシュメニューから動画キャッシュの削除も可能。  
`Ctrl + F5` でブラウザキャッシュを無視した強制リロードもできる。

### Chromeのキャッシュ削除

1. 右上のその他アイコン → **その他のツール** → **閲覧履歴を消去**
2. 期間を選択する
3. **キャッシュされた画像とファイル** にチェックを入れる
4. **データを消去** をクリック

### Firefoxのキャッシュ削除

1. メニュー → **設定** → **プライバシーとセキュリティ**
2. **Cookie とサイトデータ** セクション → **データを消去**
3. **キャッシュされたウェブコンテンツ** にチェックを入れる
4. **消去** をクリック

---

## 7. ネットワーク設定の確認

`http://127.0.0.1:8080/` にアクセスして確認する。

- バージョン情報 `NicoCache_nl version 2026-01-15` が表示される → プロキシ設定は正常
- 表示できない → [インストール](install.md) を参照

> `config.properties` に `localFileServer = true` が設定されていること（デフォルトでは設定済み）。

---

## 8. config.propertiesの確認

`config.properties` を `config.properties.old` にリネームしてNicoCacheを再起動し、問題が再現するか確認する。

| 結果 | 原因 |
|------|------|
| リネーム後も問題が継続する | config.propertiesの設定値は無関係 |
| リネーム後に問題が消えた | config.propertiesの設定値が原因 |

---

## 9. 再起動

PCを再起動して変化を確認する（特にJava更新直後と環境変数に反映されていない場合に有効）。

| 結果 | 原因 |
|------|------|
| 再起動後も問題が継続する | 他に原因がある |
| 再起動後に問題が消えた | OS・レジストリ等の問題 |

---

## 10. まだ問題が解決しない

### スレッドに質問する前に実施すること

1. **拡張機能の取り外し** — NicoCache_nlと同時利用している拡張機能とデフォルト以外の拡張機能・nlFilterを全て外す
2. **ブラウザ拡張機能の無効化** — ブラウザの拡張機能を全て無効化する
3. **config.propertiesのリネーム** — `config.properties` を `config.properties.old` にリネームする
4. **最新版への更新** — NicoCache本体・Java・ApacheAnt・BountyCastle・ブラウザ、FFmpegを最新版に更新する

### ログの提出について

- ログウィンドウの内容は自分で取捨選択せず、全て提出する
- 説明が難しい場合はスクリーンショットや動画で補足する
- ログが長い場合は [PasteBin](https://pastebin.pl/) / [GitHub Gist](https://gist.github.com/) などのコードシェアリングサービスを利用する  
  ※ 非ログイン状態でスニペットを作成すると後から変更・削除できない場合があるので注意

### デバッグモードの利用

nl本体側に問題があると思われる場合、デバッグモードで起動して `debug.log` を取得する。

**GUI起動の場合**  
`NicoCacheGUI.property` に `DebugMode=true` を記述してから `NicoCache_nl.jar` を起動する。

**バッチファイルから起動する場合**

```
NicoCache_nl.bat debug
```

**javaコマンドから直接起動する場合**

```
java -Ddareka.debug=true -Ddareka.logfile=debug.log -ea -jar NicoCache_nl.jar
```

> ※ `debug.log` には個人を特定できる情報（ユーザーIDなど）が含まれる場合があるので注意すること  
> ※ 常時デバッグモードで使用しないこと（ログが肥大化する）  
> ※「NicoCache関連ファイル置き場」にはアップロードしないこと

### 質問テンプレート

[NicoCache本スレッド](https://ff5ch.syoboi.jp/?q=NicoCache) に書き込む際は以下のテンプレートを使い、**可能な限り空欄を埋める**。情報を勝手に取捨選択しないこと。

```
■質問用テンプレ
≪動作環境≫
  【OS・Java・本体】
  【使用ブラウザとバージョン】
  【使用プレイヤー】
≪NicoCache環境≫
  【extension】
  【nlFilters】
  【プロキシ】
  【その他】
≪質問/障害内容と検証状況≫
  【事象・質問内容】
  【検証済の内容】
≪その他≫
  【トラブルシューティング試行有無】
  【特記事項】
```

【extension】【nlFilters】は使用している拡張機能・nlFilterを全て列挙する。

【プロキシ】はデフォルトのproxy.pacファイルを使用している場合はその旨を記述する。変更している場合はその旨を記述し、変更点も書く。

【その他】はその他変更している設定があれば記述する。

【事象・質問内容】はできるだけ詳しく起きている事象について記述する。
