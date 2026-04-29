# NicoCache_nl Usage Guide

NicoCache_nl のインストール、設定、トラブルシューティングをまとめた日本語ドキュメントです。

- 公開サイト: https://roflsunriz.github.io/setup-nicocache-nl/
- リポジトリ: https://github.com/roflsunriz/setup-nicocache-nl

## このリポジトリで読める内容

| ページ | 内容 |
|---|---|
| [ホーム](docs/index.md) | NicoCache_nl の概要 |
| [ダウンロード](docs/download.md) | 本体や関連ソフトの入手先 |
| [通常インストール(Win)](docs/install-win.md) | Windows 向けの通常インストール手順 |
| [通常インストール(Linux)](docs/install-linux.md) | Linux 向けの通常インストール手順 |
| [通常インストール(Mac)](docs/install-mac.md) | macOS 向けの通常インストール手順 |
| [通常インストール(Solaris)](docs/install-solaris.md) | Solaris 向けの通常インストール手順 |
| [簡単インストーラー(Win)](docs/fast-installer-win.md) | PowerShell スクリプトを使った Windows セットアップ |
| [アップデート](docs/update.md) | NicoCache_nl 本体の更新手順 |
| [依存関係ソフトウェアの更新](docs/update-dependencies.md) | Java / FFmpeg / 7-Zip などの更新手順 |
| [nlFilters 概要](docs/nl-filters.md) | ページ書き換え機能の概要 |
| [nlFilters 構文リファレンス](docs/nl-filters-syntax.md) | nlFilters の構文詳細 |
| [正規表現](docs/regex.md) | nlFilters で使う正規表現の解説 |
| [拡張機能](docs/extensions.md) | extensions の使い方 |
| [トラブルシューティング](docs/trouble-shooting.md) | 問題の切り分けと対処手順 |
| [サポートサイト](docs/support-site.md) | 関連サイト、掲示板、参考リンク |

## 使い始める

1. まず [ダウンロード](docs/download.md) で必要なファイルを確認する
2. 利用環境に応じて [通常インストール](docs/install-win.md) または [簡単インストーラー(Win)](docs/fast-installer-win.md) を選ぶ
3. 必要に応じて [アップデート](docs/update.md) と [依存関係ソフトウェアの更新](docs/update-dependencies.md) を参照する
4. 動作確認や問題解決は [トラブルシューティング](docs/trouble-shooting.md) を参照する

## PowerShell インストールスクリプト

Windows では `scripts/` にある PowerShell スクリプトでセットアップを自動化できます。

- [簡単インストーラー(Win)](docs/fast-installer-win.md)
- [通常インストール(Win)](docs/install-win.md)

### 事前準備

PowerShell 7 の導入と実行ポリシーの設定が必要な場合があります。

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Enable-ScriptExecution.ps1" -OutFile "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
```

### スクリプトをダウンロードして実行

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" -OutFile "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
pwsh -File "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
```

### ネットワーク経由で直接実行

PowerShell 7 (`pwsh`) が必要です。

```powershell
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1') }"
```

## ローカルでプレビューする

MkDocs でローカル確認できます。

```bash
pip install -r requirements.txt
mkdocs serve --livereload --dirty
```

ブラウザで `http://127.0.0.1:8000` を開くと確認できます。

## デプロイ

`main` ブランチに push すると GitHub Actions が MkDocs Material でビルドし、GitHub Pages へデプロイします。

## ライセンス

このリポジトリは [MIT License](LICENSE) に基づいて公開しています。
