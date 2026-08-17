# ダウンロード

## GitHub Releaseから入手する

[NicoCache_nl Releases](https://github.com/roflsunriz/NicoCache_nl/releases)から、OSと
CPUアーキテクチャに合う本体、独立アップデーター、対応する`.sha256`を取得する。

### NicoCache_nl本体

| OS | ファイル | 用途 |
|---|---|---|
| Windows | `NicoCache_nl-<version>.msi` | 通常の推奨。導入、更新、修復、アンインストールに対応する。 |
| Windows | `NicoCache_nl-v<version>.zip` | MSIと同じアプリケーションルートを展開して使う。 |
| Linux | `NicoCache_nl-<version>-linux-<arch>.deb` | Debian、Ubuntu系のパッケージ。 |
| Linux | `NicoCache_nl-<version>-linux-<arch>.rpm` | Fedora、RHEL系のパッケージ。 |
| Linux | `NicoCache_nl-<version>-linux-<arch>.zip` | 任意の場所へ展開するアプリイメージ。 |
| macOS | `NicoCache_nl-<version>-macos-<arch>.pkg` | `/Applications/NicoCache_nl`へ導入するパッケージ。 |
| macOS | `NicoCache_nl-<version>-macos-<arch>.dmg` | アプリケーションフォルダーを収録する。 |
| macOS | `NicoCache_nl-<version>-macos-<arch>.zip` | 任意の場所へ展開するアプリイメージ。 |

`<arch>`は`x64`や`arm64`である。現在公開されている資産のOS・CPUと使用中の環境が一致する
ものだけを選ぶ。Solaris向けの配布と動作保証はない。

すべての現行パッケージは専用Javaランタイム、本体JAR、ランチャー、診断アプリ、証明書生成、
既定設定、標準nlFilterを含む。通常利用のためにJava、Ant、Bouncy Castle、PowerShell 7、
7-Zipを先に導入する必要はない。

## SHA-256を照合する

配布ファイルと同名の`.sha256`を同じ場所へ保存する。PowerShellでは次のように照合できる。

```powershell
$package = Get-Item .\NicoCache_nl-1.4.2.msi
$expected = (Get-Content "$($package.FullName).sha256" -Raw).Split()[0]
$actual = (Get-FileHash $package.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw 'SHA-256が一致しません' }
```

Linux/macOSでは次のように確認できる。

```sh
sha256sum -c NicoCache_nl-1.4.2-linux-x64.deb.sha256
# macOSでsha256sumがない場合
shasum -a 256 NicoCache_nl-1.4.2-macos-arm64.pkg
cat NicoCache_nl-1.4.2-macos-arm64.pkg.sha256
```

表示された値が一致した場合だけ導入する。ファイル名と版は実際に取得した資産へ置き換える。

## 独立アップデーター { #standalone-updater-download }

独立アップデーターはNicoCache_nl本体とTemurin、FFmpeg、Bouncy Castle、Apache Ant、
7-Zip、GPAC/MP4Boxを一つのGUIから確認・更新する。本体とは版番号が独立している。

| OS | ファイル |
|---|---|
| Windows | `NicoCache_nl-Updater-<updater-version>.msi` |
| Linux | `NicoCache_nl-Updater-<updater-version>-linux-<arch>.<deb|rpm|zip>` |
| macOS | `NicoCache_nl-Updater-<updater-version>-macos-<arch>.<pkg|dmg|zip>` |

専用Javaランタイムを内包するため、本体のJavaが破損していても起動できる。具体的な操作は
[アップデート手順](update.md#standalone-updater)を参照すること。

## 従来形式・開発者向けの配布物

避難所の [NicoCache関連ファイル置き場](https://nicocache.jpn.org/) には、従来形式のアーカイブ、フィルター、Extension などが置かれることがある。ファイル名や番号を固定したダウンロード URL は、差し替え・移動で無効になるため、このガイドでは案内しない。配布内容、更新日、ハッシュを確認してから使用すること。

`NicoCache_nl.jar`を直接起動する構成では、対応するJava 17・21・25 LTSと、TLS、設定、
起動管理を自分で用意する必要がある。通常利用ではOS別の自己完結パッケージを選ぶ。

## filter-matome（統合拡張スイート）

[filter-matome](https://github.com/roflsunriz/filter-matome)は
次の資材を組み合わせてNicoCache_nlとニコニコ動画へ機能を追加する統合拡張スイートである。

- `nlFilters/`: ブラウザー側の機能群を読み込むnlFilter
- `local/`: 視聴履歴、マイリスト2、コメントフィルター2、ローカル動画プレイヤー、
  視聴ページ操作パネル、キャッシュ管理、動画情報表示、動画取得予約などのブラウザー側資材
- `extensions/`: キャッシュ操作、動画取得、シリーズ通知、FFmpeg・GPAC連携などを担う
  コンパイル済みJava Extensionとソース
- `scripts/`: 設定・更新・メディア処理・開発者向け操作をまとめた、任意利用のJava Toolbox

[filter-matome Releases](https://github.com/roflsunriz/filter-matome/releases)
から`filter-matome-<version>.7z`を取得し、アーカイブ内の`GUIDE.html`または
[filter-matome Usage Guide](https://roflsunriz.github.io/filter-matome/USAGE/)を確認して一式を導入する。

`config.properties`の
`userDataRoot`で実際の利用者データルートを確認し、NicoCache_nlを終了してから、配布物の
`local`、`nlFilters`、`extensions`を利用者データ側の同名フォルダーへ上書きする。
Java Toolboxを使う場合だけ、`scripts`をアプリケーションルートへ配置する。更新前には
各機能の設定・データと自分で追加した背景画像をバックアップし、配置後はNicoCache_nlを
再起動してブラウザーをハード再読み込みすること。

## 本体の変更履歴

- [NicoCache_nl CHANGELOG](https://github.com/roflsunriz/NicoCache_nl/blob/main/CHANGELOG.md)
