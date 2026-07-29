# ダウンロード

## 推奨: GitHub Release の Windows パッケージ

[NicoCache_nl の GitHub Release](https://github.com/roflsunriz/NicoCache_nl/releases) から、同じバージョンの配布物と SHA-256 ファイルを取得します。

| ファイル | 用途 |
|---|---|
| `NicoCache_nl-<version>.msi` | 通常の Windows インストール。スタートメニュー・デスクトップの起動導線、更新、修復、アンインストールに対応。 |
| `NicoCache_nl-<version>.zip` | 展開して利用する版。MSI と同じ自己完結アプリイメージを含む。 |
| `*.sha256` | ダウンロードした MSI または ZIP の検証用。 |

MSI/ZIP は専用 Java ランタイム、本体、証明書生成に必要なライブラリ、既定設定、標準 nlFilter を含みます。旧手順で必要だった Java、Ant、Bouncy Castle、7-Zip を個別に導入する必要はありません。

PowerShell では次のようにハッシュを確認できます。

```powershell
Get-FileHash .\NicoCache_nl-<version>.msi -Algorithm SHA256
Get-Content .\NicoCache_nl-<version>.msi.sha256
```

表示された SHA-256 が配布元の値と一致した場合だけインストールしてください。

## 従来形式・開発者向けの配布物

避難所の [NicoCache関連ファイル置き場](https://nicocache.jpn.org/) には、従来形式のアーカイブ、フィルター、Extension などが置かれることがあります。ファイル名や番号を固定したダウンロード URL は、差し替え・移動で無効になるため、このガイドでは案内しません。配布内容、更新日、ハッシュを確認してから使用してください。

`NicoCache_nl.jar` を直接起動する構成では、対応する Java を用意し、TLS・設定・起動を手動で管理する必要があります。[手動インストール](install-linux.md) を参照してください。

## 関連配布物

- 標準外のフィルターまとめ: [roflsunriz/filter-matome Releases](https://github.com/roflsunriz/filter-matome/releases)
- 本体の更新内容: [NicoCache_nl CHANGELOG](https://github.com/roflsunriz/NicoCache_nl/blob/main/CHANGELOG.md)

フィルターは本体の標準機能ではないものを含みます。導入前に対象バージョン、内容、配布元を確認し、利用者データ側の対応フォルダに追加してください。
