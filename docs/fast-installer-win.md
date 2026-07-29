# 旧 PowerShell インストーラー（Windows）

このリポジトリの PowerShell インストーラーは、JAR 形式を前提に Java、Ant、Bouncy Castle、証明書、PAC、タスクスケジューラーを個別設定する旧方式である。

現行の NicoCache_nl は、専用 Java ランタイムを含む MSI/ZIP と初回セットアップを提供する。新規導入では [Windows のインストール](install-win.md) を使用すること。旧スクリプトは、既存の JAR 構成を保守する場合だけの参考資料である。

旧方式から移行する場合は、先に `config.properties`、`certs/`、キャッシュ、追加した `local/`・`nlFilters/`・Extension をバックアップし、新しい配布物へ一度に上書きしないでください。新しい初回セットアップで利用者データの保存先を選び、必要な資材だけを移行します。
