# ダウンロード

## 推奨: GitHub Release の Windows パッケージ

[NicoCache_nl の GitHub Release](https://github.com/roflsunriz/NicoCache_nl/releases) から、同じバージョンの配布物と SHA-256 ファイルを取得する。

| ファイル | 用途 |
|---|---|
| `NicoCache_nl-<version>.msi` | 通常の Windows インストール。スタートメニュー・デスクトップの起動導線、更新、修復、アンインストールに対応。 |
| `NicoCache_nl-<version>.zip` | 展開して利用する版。MSI と同じ自己完結アプリイメージを含む。 |
| `NicoCache_nl-Updater-<updater-version>.msi` | 本体と外部依存関係を管理する独立アップデーター。専用 Java ランタイムを含む。 |
| `*.sha256` | ダウンロードした MSI または ZIP の検証用。 |

MSI/ZIP は専用 Java ランタイム、本体、証明書生成に必要なライブラリ、既定設定、標準 nlFilter を含む。旧手順で必要だった Java、Ant、Bouncy Castle、7-Zip を個別に導入する必要はない。

PowerShell では次のようにハッシュを確認できる。

```powershell
Get-FileHash .\NicoCache_nl-<version>.msi -Algorithm SHA256
Get-Content .\NicoCache_nl-<version>.msi.sha256
Get-FileHash .\NicoCache_nl-Updater-<updater-version>.msi -Algorithm SHA256
Get-Content .\NicoCache_nl-Updater-<updater-version>.msi.sha256
```

表示された SHA-256 が配布元の値と一致した場合だけインストールすること。

## 独立アップデーター { #standalone-updater-download }

独立アップデーターは NicoCache_nl 本体と Temurin、FFmpeg、Bouncy Castle、Apache Ant、7-Zip を一つの GUI から確認・更新する。アップデーターの版番号は本体のリリースタグとは独立しているため、ファイル名の版番号が本体と一致していなくても問題はない。

`NicoCache_nl-Updater-<updater-version>.msi` と対応する `.msi.sha256` を同じ GitHub Release から取得し、上記の手順で検証してからインストールする。スタートメニューまたはデスクトップの **NicoCache_nl Updater** から起動できる。専用 Java ランタイムを内包するため、本体側の Java ランタイムが破損していても起動できる。具体的な操作は[アップデート手順](update.md#standalone-updater)を参照すること。

## 従来形式・開発者向けの配布物

避難所の [NicoCache関連ファイル置き場](https://nicocache.jpn.org/) には、従来形式のアーカイブ、フィルター、Extension などが置かれることがある。ファイル名や番号を固定したダウンロード URL は、差し替え・移動で無効になるため、このガイドでは案内しない。配布内容、更新日、ハッシュを確認してから使用すること。

`NicoCache_nl.jar` を直接起動する構成では、対応する Java を用意し、TLS・設定・起動を手動で管理する必要がある。[手動インストール](install-linux.md) を参照すること。

## 関連配布物

- 標準外のフィルターまとめ: [roflsunriz/filter-matome Releases](https://github.com/roflsunriz/filter-matome/releases)
- 本体の更新内容: [NicoCache_nl CHANGELOG](https://github.com/roflsunriz/NicoCache_nl/blob/main/CHANGELOG.md)

フィルターは本体の標準機能ではないものを含む。導入前に対象バージョン、内容、配布元を確認し、利用者データ側の対応フォルダーに追加すること。
