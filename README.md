# NicoCache_nl セットアップガイド

NicoCache_nl の公式セットアップガイドです。

**公開 URL:** https://roflsunriz.github.io/setup-nicocache-nl/

---

## 概要

[NicoCache_nl](https://nicocache.jpn.org/) はニコニコ動画の動画・サムネイルをローカルにキャッシュするプロキシサーバーソフトウェアです。このリポジトリは NicoCache_nl のインストール・設定・トラブルシューティングを日本語でまとめたドキュメントです。

## ドキュメント構成

| ページ | 内容 |
|---|---|
| [ホーム](docs/index.md) | NicoCache_nl の概要 |
| [ダウンロード](docs/download.md) | ダウンロード方法 |
| [通常インストール](docs/install.md) | 手順を一つ一つ追ったインストール方法 |
| [簡単インストーラー](docs/fast-installer.md) | 高速インストーラーを使ったセットアップ |
| [アップデート](docs/update.md) | 本体のアップデート手順 |
| [nlFilters 概要](docs/nl-filters.md) | ページ書き換え機能の概要 |
| [nlFilters 構文リファレンス](docs/nl-filters-syntax.md) | nlFilters の構文詳細 |
| [正規表現](docs/regex.md) | nlFilters で使う正規表現の解説 |
| [拡張機能](docs/extensions.md) | extensions の使い方 |
| [トラブルシューティング](docs/trouble-shooting.md) | 問題の診断と解決手順 |
| [サポートサイト](docs/support-site.md) | 公式サイト・スレッドへのリンク |

## PowerShell インストールスクリプト

NicoCache_nl のセットアップを自動化する PowerShell スクリプトを `scripts/` ディレクトリに収録しています。

### 事前準備（初回のみ）

PowerShell 7 のインストールとスクリプト実行ポリシーの変更をまとめて行います。  
**Windows PowerShell（powershell.exe）から実行できます。PowerShell 7 は不要です。**

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Enable-ScriptExecution.ps1" -OutFile "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
```

完了後はターミナルを閉じて、「Windowsキー + R」→ `pwsh` で PowerShell 7 を起動してください。

### ダウンロードして実行

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" -OutFile "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
pwsh -File "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
```

### ネットワーク経由で直接実行（PowerShell 7 が必要）

> [!NOTE]
> PowerShell 7 未インストールの場合・実行ポリシーが未設定の場合は、先に[事前準備（初回のみ）](#事前準備初回のみ)を行ってください。

```powershell
irm "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" | iex
```

### DryRun で事前確認

実際の変更を行わずに実行内容を確認できます：

```powershell
pwsh -File "$env:USERPROFILE\Downloads\Install-NicoCache.ps1" -DryRun
```

詳しい使い方は [PowerShell インストールスクリプト](docs/fast-installer.md) を参照してください。

---

## ローカルでプレビューする

Python 3.12 以上が必要です。

```bash
pip install -r requirements.txt
mkdocs serve
```

ブラウザで http://127.0.0.1:8000 を開くと確認できます。

## デプロイ

`main` ブランチに push すると GitHub Actions が自動的に MkDocs Material でビルドし、GitHub Pages へデプロイします。

## ライセンス

このリポジトリは [MIT License](LICENSE) に基づき公開しています。
