# extensionsのインストール方法
<div style="text-align: right;">最終更新日：2026/03/15</div>
---

## extensionsとは？
extensionsはNicoCacheの拡張機能である。Javaファイルとして作り、コンパイルすることで独自の機能を付加することが可能である。

## .classファイルが同梱されている場合
1. extensionsフォルダに移動してNicoCacheを再起動する

## .classファイルが同梱されていない場合
1. extensions\build.cmdに.javaファイルをドラッグ・アンド・ドロップする
2. エラーが無ければ.classファイルが生成される
3. .classファイルが生成されない場合は作者に修正を依頼する

# extensionsの更新方法

## .classファイルが同梱されている場合
1. .classファイルを上書き更新してNicoCacheを再起動する

## .classファイルが同梱されていない場合
1. extensions\build.cmdに.javaファイルをドラッグ・アンド・ドロップする
2. エラーが無ければ.classファイルが上書き更新される。更新日時が新しくなる。
!!! warning
    更新日時が新しくなっていることを確認する。
3. .classファイルが上書き更新されない場合は作者に修正を依頼する