# 調査知見

- Zensicalは旧Git更新日時プラグインを実行しない。`scripts/build-docs.py` が全履歴の `git log` から日付を一時コピーへ付けるため、CI/Pagesの `fetch-depth: 0` を維持する。
- ローカルのZensical表示だけでは更新日生成を確認できない。公開相当は `python scripts/build-docs.py` と生成ページで検証する。
- Dependabot分類がCIより遅れた場合は `callback_workflow_file` の呼出し側を `workflow_dispatch` し、現在のPR番号・head SHA・全チェックを再照合する。workflow名変更時はこの入力も更新する。
