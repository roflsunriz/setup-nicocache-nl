# 依存関係ソフトウェアの更新

## 独立アップデーターを使う方法（Windows、推奨） { #standalone-updater-dependencies }

[独立アップデーター](download.md#standalone-updater-download)は、次の外部依存関係を一つの GUI から確認・更新できる。
    
- Eclipse Temurin（NicoCache_nl で確認済みの Java 17・21・25 LTS。推奨・既定は Java 25）    
- FFmpeg    
- Bouncy Castle    
- Apache Ant    
- 7-Zip    
- GPAC/Mp4box    
    
1. NicoCache_nl を終了する。更新対象が使用中で置換できない場合、アップデーターは処理を失敗として既存内容を復元する。
2. **NicoCache_nl Updater** を起動し、画面上部の更新対象フォルダーを確認する。誤っている場合は「変更…」から NicoCache_nl のインストール先を選ぶ。
3. 「外部依存関係」タブを開き、Temurin LTS を選ぶ。通常は「25（推奨）」を使用する。
4. 「環境を確認」を押し、現在の導入状況と更新候補を確認する。
5. 「インストールまたは更新」を押し、対象を確認して続行する。
6. 完了後に新しいコマンドプロンプトまたは PowerShell を開き、必要なツールの版を確認する。NicoCache_nl も起動し、通常どおりキャッシュできることを確認する。

Temurin、FFmpeg、Apache Ant、7-Zip は WinGet を優先して導入する。WinGet パッケージがない場合は公式配布 API を使用する。マシン全体への導入が必要なパッケージでは Windows の許可画面が表示されることがあり、`PATH` と `JAVA_HOME` も必要に応じて更新される。Bouncy Castle は NicoCache_nl 専用ライブラリとして管理される。

## Windows パッケージ利用者

MSI/ZIP 版は専用 Java ランタイムと証明書生成に必要な依存ライブラリを同梱する。個別のファイルを手作業で置換せず、更新が必要な場合は独立アップデーターを使用すること。推測による置換は起動不能や証明書生成失敗の原因になる。

ブラウザーは、OS またはブラウザーの通常の更新機能で最新の安定版を利用すること。Firefox では証明書ストアの利用方式により CA 証明書の再登録が必要になることがある。

## JAR を直接利用する構成

Java は本体が対応する LTS を使用する。現行の Windows パッケージは JDK 25 を含むが、手動起動用の `RunNicoCache.ps1` は検出した Java 17・21・25 から選択できる。更新前に現在の Java を確認すること。

```powershell
java -version
```

Bouncy Castle やビルドツールは開発・手動証明書生成向けである。配布元が指定する組み合わせとハッシュを確認し、稼働中の `lib/` を推測で置き換えないこと。

## FFmpeg

FFmpeg は一部の変換・音声抽出に使われる。該当機能を利用する場合だけ、OS 向けの信頼できる配布元から導入・更新し、`ffmpeg -version` で起動を確認する。NicoCache_nl の通常のキャッシュ・再生だけに必須ではない。
