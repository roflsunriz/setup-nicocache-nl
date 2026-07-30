# 変更履歴

このプロジェクトの主な変更はこのファイルに記録する。

書式は [Keep a Changelog](https://keepachangelog.com/ja/1.1.0/) に基づく。

## [Unreleased]

### Security

- push前監査で検出された既知の依存脆弱性を解消するため、安全版へ依存関係とロックファイルを更新した。

### Changed

- 利用者が本体と外部依存関係を安全に更新できるよう、独立アップデーターの入手、対象フォルダーの選択、本体更新、Temurin・FFmpeg・Bouncy Castle・Apache Ant・7-Zip の更新手順を追加した。
- 利用者向け文書の調子を統一するため、README と全ガイドの敬体表現を常体へ改めた。
- 作業開始時の共通指針見落としを防ぐため、調査やコマンド実行より前に `COMMON-AGENTS.md` を先頭から末尾まで読み、EOFを確認する必須ゲートを追加した。
- 現行 NicoCache_nl の Windows MSI/ZIP、初回セットアップ、利用者データ分離、TLS、更新・削除の挙動に合わせ、旧来の JAR・Ant 前提手順を利用者向けドキュメントから更新した。
