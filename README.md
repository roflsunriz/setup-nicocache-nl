# NicoCache_nl Wiki

NicoCache_nl の非公式セットアップガイド・使い方 Wiki です。

**公開 URL:** https://roflsunriz.github.io/setup-nicocache-nl/

---

## 概要

[NicoCache_nl](https://nicocache.jpn.org/) はニコニコ動画の動画・サムネイルをローカルにキャッシュするプロキシサーバーソフトウェアです。このリポジトリは NicoCache_nl のインストール・設定・トラブルシューティングを日本語でまとめた Wiki です。

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

このリポジトリのドキュメントは [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.ja) に基づき公開しています。
