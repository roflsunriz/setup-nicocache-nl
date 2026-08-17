# NicoCache_nl Usage Guide

NicoCache_nl のインストール、設定、トラブルシューティングをまとめた日本語ドキュメントである。

- 公開サイト: https://roflsunriz.github.io/setup-nicocache-nl/
- リポジトリ: https://github.com/roflsunriz/setup-nicocache-nl

## このリポジトリで読める内容

| ページ | 内容 |
|---|---|
| [ホーム](docs/index.md) | NicoCache_nl の概要 |
| [ダウンロード](docs/download.md) | 本体や関連ソフトの入手先 |
| [インストール(Windows)](docs/install-win.md) | MSI/ZIP を使った推奨手順 |
| [インストール(Linux)](docs/install-linux.md) | DEB/RPM/ZIP を使った自己完結パッケージの導入手順 |
| [インストール(macOS)](docs/install-mac.md) | PKG/DMG/ZIP を使った自己完結パッケージの導入手順 |
| [Solaris](docs/install-solaris.md) | 現行の配布・検証対象外であることの案内 |
| [旧 PowerShell インストーラー](docs/fast-installer-win.md) | 既存 JAR 構成向けの参考資料 |
| [Windows Terminal](docs/windows-terminal.md) | Windows Terminalの開き方 |
| [アップデート](docs/update.md) | 独立アップデーターまたは手動による本体の更新手順 |
| [依存関係ソフトウェアの更新](docs/update-dependencies.md) | 独立アップデーターによる Java / FFmpeg / 7-Zip などの更新手順 |
| [設定とデータ管理](docs/configuration.md) | config.properties、利用者データ、キャッシュの管理 |
| [nlFilters 概要](docs/nl-filters.md) | ページ書き換え機能の概要 |
| [nlFilters 構文リファレンス](docs/nl-filters-syntax.md) | nlFilters の構文詳細 |
| [正規表現](docs/regex.md) | nlFilters で使う正規表現の解説 |
| [拡張機能](docs/extensions.md) | extensions の使い方 |
| [トラブルシューティング](docs/trouble-shooting.md) | 問題の切り分けと対処手順 |
| [サポートサイト](docs/support-site.md) | 関連サイト、掲示板、参考リンク |

## 使い始める

1. まず [ダウンロード](docs/download.md) で必要なファイルを確認する
2. 使用中のOSに合わせて[Windows](docs/install-win.md)、[Linux](docs/install-linux.md)、
   [macOS](docs/install-mac.md)のインストール手順を選ぶ
3. 導入後は [アップデート](docs/update.md) で独立アップデーターの入手方法と使い方を確認する
4. 動作確認や問題解決は [トラブルシューティング](docs/trouble-shooting.md) を参照する

## OS別のインストール

新規導入には専用Javaランタイムを含むOS別パッケージまたはZIPを使用する。初回起動時に、
利用者データ、HTTPS証明書、OSの自動プロキシー、ログイン時起動を選べる。

- [Windows のインストール](docs/install-win.md)
- [Linux のインストール](docs/install-linux.md)
- [macOS のインストール](docs/install-mac.md)
- [ダウンロード](docs/download.md)

## ローカルでプレビューする

MkDocs でローカル確認できる。

```bash
pip install -r requirements.txt
mkdocs serve --livereload --dirty
```

ブラウザーで `http://127.0.0.1:8000` を開くと確認できる。

## デプロイ

`main` ブランチに push すると GitHub Actions が MkDocs Material でビルドし、GitHub Pages へデプロイする。

## ライセンス

このリポジトリは [MIT License](LICENSE) に基づいて公開している。
