# setup-nicocache-nl の実現手段と調査知見

作業着手前にこの文書を全文読む。共通方針と目的・行動義務・禁止事項は [AGENTS.md](AGENTS.md) を参照する。

## 共通方針に対する固有の実現手段

- 対象の共通ルール: 検証の言語別ビルド・文書構成。
- 理由: このリポジトリは利用者向け文書サイトであり、ZensicalとPythonスクリプトがGitの更新日を生成HTMLへ反映するため。
- 適用範囲: 既存docs/と文書サイトの生成・公開。
- 代替手段・検証: python scripts/build-docs.pyの厳格ビルドとリンク・生成ページ・更新日を確認し、公開時はPagesの実結果も確認する。
- 文書構成: 実現手段・環境・過去の調査知見はこの文書を正本とする。利用者向け導入・使用法はREADME、更新の入口はhow-to-update、実測結果はverification、変更意図はCHANGELOGに残す。共通方針の品質・秘密情報保護・ユーザー指示を免除しない。
- 移行基準: 2026-10-16の既定ブランチ `075e0c024c0fd06fa159149b2e61058d898d0f35`。以下は出典の本文を移動したもので、過去の確認日時・適用条件・未検証事項を維持する。


<a id="agents-project-notes"></a>

移動元: [AGENTS.md](AGENTS.md)。

## 文書ビルドの調査知見

- Zensical は旧 Git 更新日時プラグインを実行しない。公開用の `scripts/build-docs.py` は全履歴の `git log` から日付を取得して一時的な文書コピーへ付ける。CI と Pages では `fetch-depth: 0` を維持する。


<a id="readme-4"></a>

移動元: [README.md](README.md)。

## ローカルでプレビューする

Zensical を使うと、公開前にローカルでページを確認できる。

```bash
pip install -r requirements.txt
zensical serve
```

ブラウザーで `http://127.0.0.1:8000` を開くと確認できる。


<a id="readme-5"></a>

移動元: [README.md](README.md)。

## デプロイ

`main` ブランチに push すると、GitHub Actions が Zensical でビルドし、GitHub Pages へデプロイする。公開用の厳格ビルドは `python scripts/build-docs.py` で再現できる。公開ページには、各ページの Git 最終更新日も表示される。


<a id="readme-7"></a>

移動元: [README.md](README.md)。

## 依存更新の自動処理

Dependabot は対象の依存関係を毎週確認します。patch／minor 更新は PR のチェック（CI）が成功した後に自動で squash merge されます。CI の失敗ジョブは 1 回だけ再実行します。再失敗した PR は残して手動で修正します。major 更新は手動で確認します。マージ後はデプロイ workflow を明示起動します。


<a id="update-1"></a>

移動元: [how-to-update.md](how-to-update.md)。

## 文書サイトの更新

`docs/` を編集したら、`python -m pip install -r requirements.txt` と `python scripts/build-docs.py` を実行し、`site/` のページと Git 最終更新日を確認する。Pages は全 Git 履歴を取得して同じスクリプトで公開する。問題が出た場合は変更コミットを revert し、Pages ワークフローを再実行する。


<a id="update-2"></a>

移動元: [how-to-update.md](how-to-update.md)。

## Dependabot PR の更新

前提は `.github/dependabot.yml` と PR 用 CI（CI）です。更新 PR の head SHA と `gh pr checks <PR番号>` の結果を確認してください。patch／minor は全チェック成功後に自動取り込みされます。初回 CI 失敗は failed jobs のみを 1 回再実行し、再失敗した PR は残して手動で修正します。

設定を変えたときは `actionlint .github/workflows/dependabot-automation.yml` と実際の PR の Actions 結果を確認します。問題があれば呼び出し先の共通 workflow SHA を直前の検証済み値へ戻すコミットを push します。取り込まれた依存更新に問題があれば通常の revert コミットで復旧します。

CI 完了より Dependabot の分類が遅れる場合は、`callback_workflow_file` が指す呼び出し側 workflow を `workflow_dispatch` し、同じ PR 番号・head SHA・全チェックを再確認する。呼び出し側のファイル名を変える際はこの入力も一緒に更新する。
