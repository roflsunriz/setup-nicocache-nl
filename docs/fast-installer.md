# PowerShell インストールスクリプトを使ったインストール方法

[install.md](install.md) の全手順を自動化した PowerShell スクリプトを使って NicoCache_nl をセットアップする方法を説明します。

## 自動実行される作業

| 自動実行される作業 |
|---|
| C:\NicoCache_nl ディレクトリ構成の作成 |
| JDK 17・FFmpeg・7-zip の winget インストール |
| Apache Ant のダウンロード・展開・環境変数（ANT_HOME / PATH）設定 |
| NicoCache_nl 本体のダウンロード・展開 |
| BouncyCastle ライブラリのダウンロード |
| 証明書の生成と Windows 証明書ストアへのインポート |
| config.properties・proxy.pac の初期設定 |
| NicoCacheGUI.property の設定 |
| RunNicoCache.ps1 ランチャー生成・スクリプト実行ポリシー設定・タスクスケジューラー登録 |

> [!NOTE]
> Firefox への CA 証明書インポートは GUI 操作が必要なため自動化されていません。スクリプト実行後に手動でインポートしてください（スクリプトが手順を案内します）。

## 事前準備: PowerShell 7 のインストールと実行ポリシーの変更

初回のみ必要です。PowerShell 7 のインストールとスクリプト実行ポリシーの変更をまとめて行います。  
**Windows PowerShell（powershell.exe）から実行できます。PowerShell 7 は不要です。**

1. 「Windowsキー + R」を押して「ファイル名を指定して実行」を開く
2. `powershell` と入力して Enter
3. 以下を実行する

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Enable-ScriptExecution.ps1" -OutFile "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
```

UAC プロンプトが表示されたら「はい」を選択してください。完了後に案内される通り、ターミナルを閉じて `pwsh` で再起動してください。

---

## 方法 1: スクリプトをダウンロードして実行

スクリプトをローカルに保存してから実行する方法です。

1. 「Windowsキー + R」を押して「ファイル名を指定して実行」を開く
2. `pwsh` と入力して Enter（PowerShell 7 を起動）
3. 以下を実行する

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" -OutFile "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
pwsh -File "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
```

UAC プロンプトが表示されたら「はい」を選択してください。スクリプトが管理者権限で再起動して処理を開始します。

---

## 方法 2: ネットワーク経由で直接実行

ダウンロード不要でワンライナーで実行できます。PowerShell 7 (`pwsh`) が必要です。

PowerShell 7 未インストールの場合・実行ポリシーが未設定の場合は、先に以下を実施してください。  
**Windows PowerShell（powershell.exe）から実行できます。PowerShell 7 は不要です。**

1. 「Windowsキー + R」を押して「ファイル名を指定して実行」を開く
2. `powershell` と入力して Enter
3. 以下を実行する

```powershell
winget install Microsoft.Powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Enable-ScriptExecution.ps1" -OutFile "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\Enable-ScriptExecution.ps1"
```

UAC プロンプトが表示されたら「はい」を選択してください。完了後はターミナルを閉じてください。

---

4. 「Windowsキー + R」を押して `pwsh` と入力して Enter
5. 以下を実行する

```powershell
irm "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" | iex
```

---

## `-DryRun` オプション: 実行前の動作確認

実際の変更を行わず、スクリプトが何をするかを事前に確認できます。

```powershell
# ダウンロードして DryRun 確認（推奨）
pwsh -File "$env:USERPROFILE\Downloads\Install-NicoCache.ps1" -DryRun
```

ネットワーク経由で DryRun を行う場合は、一時ファイルに保存してから実行してください：

```powershell
$tmp = New-TemporaryFile
irm "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" | Set-Content $tmp
pwsh -File $tmp -DryRun
```

DryRun モードでは `[DRY-RUN]` プレフィックス付きで実行予定の操作が表示され、ファイル・レジストリ・証明書ストアへの変更は一切行われません。

---

## インストール後の手順

1. **Firefox への CA 証明書インポート**（スクリプト完了後に案内が表示されます）
    - Firefox を開く
    - 設定 → プライバシーとセキュリティ → 証明書 → 証明書を表示
    - 認証局証明書タブ → インポート
    - `C:\NicoCache_nl\certs\ca.cer` を選択
    - 「この認証局によるウェブサイトの識別を信頼する」にチェック → OK
    - Firefox を再起動する

2. **本体の最新版確認**
    インストールスクリプトに含まれる NicoCache_nl 本体は最新版ではない可能性があります。[避難所アップローダ](https://nicocache.jpn.org/)で最新版を確認し、必要に応じて上書き更新してください。

3. **設定の調整**（任意）
    `C:\NicoCache_nl\config.properties` を編集して設定を調整できます。デフォルト設定は `defaults` ディレクトリを参照してください。
