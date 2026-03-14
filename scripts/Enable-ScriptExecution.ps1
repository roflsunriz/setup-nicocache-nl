<#
.SYNOPSIS
    PowerShell 7 のインストールとスクリプト実行ポリシーを設定するスクリプト

.DESCRIPTION
    Install-NicoCache.ps1 を実行する前の事前準備として、以下を行う:
      1. PowerShell 7 (pwsh) を winget でインストールする
      2. LocalMachine スコープの実行ポリシーを RemoteSigned に設定する

    管理者権限が必要。未昇格の場合は自動的に UAC プロンプトを表示して再起動する。
    Windows PowerShell 5.1 から実行可能。PowerShell 7 はこのスクリプトでインストールされる。

.PARAMETER DryRun
    このスイッチを指定すると、実際の変更は行わず動作内容のシミュレーション出力のみを行う。

.EXAMPLE
    # 通常実行 - Windows PowerShell (powershell.exe) から実行可能
    powershell -ExecutionPolicy Bypass -File Enable-ScriptExecution.ps1

.EXAMPLE
    # DryRun で事前確認
    powershell -ExecutionPolicy Bypass -File Enable-ScriptExecution.ps1 -DryRun
#>
[CmdletBinding()]
param(
    [switch]$DryRun
)

# PowerShell 5.1 と 7 の両方で動作するよう Set-StrictMode は 2.0 に留める
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

# =============================================================================
# 管理者権限チェックと自動昇格
# =============================================================================
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host '管理者権限が必要です。UAC プロンプトを表示します...' -ForegroundColor Yellow

    # pwsh が利用可能ならそちらで昇格、未インストールなら powershell.exe にフォールバック
    $shellExe = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell' }
    $argList  = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($DryRun) { $argList += ' -DryRun' }
    Start-Process $shellExe -Verb RunAs -ArgumentList $argList
    exit
}

# =============================================================================
# ウェルカムバナー
# =============================================================================
Write-Host ''
Write-Host '================================================================' -ForegroundColor Green
Write-Host '  NicoCache_nl セットアップ 事前準備スクリプト                  ' -ForegroundColor Green
Write-Host '================================================================' -ForegroundColor Green

if ($DryRun) {
    Write-Host ''
    Write-Host '================================================================' -ForegroundColor Cyan
    Write-Host '  [DRY-RUN] 動作確認モード: 実際の変更は行いません             ' -ForegroundColor Cyan
    Write-Host '================================================================' -ForegroundColor Cyan
}
Write-Host ''

# =============================================================================
# ステップ 1: PowerShell 7 のインストール
# =============================================================================
Write-Host '  ---- ステップ 1: PowerShell 7 のインストール ----' -ForegroundColor Yellow
Write-Host ''

$pwshCmd = Get-Command pwsh -ErrorAction SilentlyContinue

if ($pwshCmd) {
    $pwshVersion = & pwsh -NoProfile -Command "& { `$PSVersionTable.PSVersion.ToString() }"
    Write-Host "  PowerShell 7 はすでにインストールされています (v$pwshVersion)。スキップします。" -ForegroundColor DarkGray
} else {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Warning '  winget が見つかりません。Windows 10 1809 以降、または App Installer が必要です。'
        Write-Host '  PowerShell 7 を手動でインストールしてください:' -ForegroundColor Yellow
        Write-Host '  https://github.com/PowerShell/PowerShell/releases/latest' -ForegroundColor White
    } else {
        if ($DryRun) {
            Write-Host '  [DRY-RUN] winget install Microsoft.PowerShell を実行します' -ForegroundColor Cyan
        } else {
            Write-Host '  PowerShell 7 をインストールしています...' -ForegroundColor Yellow
            winget install Microsoft.PowerShell `
                --accept-source-agreements `
                --accept-package-agreements `
                --silent `
                --disable-interactivity `
                --source winget

            # 0 = 成功, -1978335189 (0x8A15002B) = 既インストール済み のどちらも正常
            if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
                Write-Warning "  PowerShell 7 のインストールに失敗しました (ExitCode: $LASTEXITCODE)"
                Write-Host '  手動でインストールしてください: https://github.com/PowerShell/PowerShell/releases/latest' -ForegroundColor Yellow
            } else {
                Write-Host '  PowerShell 7 のインストールが完了しました。' -ForegroundColor Green
            }
        }
    }
}

Write-Host ''

# =============================================================================
# ステップ 2: スクリプト実行ポリシーの変更
# =============================================================================
Write-Host '  ---- ステップ 2: スクリプト実行ポリシーの設定 ----' -ForegroundColor Yellow
Write-Host ''

$currentPolicy = Get-ExecutionPolicy -Scope LocalMachine
Write-Host "  現在の実行ポリシー (LocalMachine): $currentPolicy" -ForegroundColor White
Write-Host "  変更後の実行ポリシー (LocalMachine): RemoteSigned" -ForegroundColor White
Write-Host ''

if ($DryRun) {
    Write-Host '  [DRY-RUN] Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force' -ForegroundColor Cyan
    Write-Host '  [DRY-RUN] 実際の変更は行いません。' -ForegroundColor Cyan
} else {
    if ($currentPolicy -eq 'RemoteSigned') {
        Write-Host '  実行ポリシーはすでに RemoteSigned です。変更の必要はありません。' -ForegroundColor Green
    } else {
        Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
        Write-Host '  実行ポリシーを RemoteSigned に設定しました。' -ForegroundColor Green
    }
}

Write-Host ''
Write-Host '  現在の実行ポリシー一覧:' -ForegroundColor White
Get-ExecutionPolicy -List | Format-Table -AutoSize

# =============================================================================
# 完了メッセージと次の手順の案内
# =============================================================================
Write-Host '================================================================' -ForegroundColor Green
if ($DryRun) {
    Write-Host '  [DRY-RUN] 事前準備シミュレーション完了                        ' -ForegroundColor Green
} else {
    Write-Host '  事前準備が完了しました                                        ' -ForegroundColor Green
}
Write-Host '================================================================' -ForegroundColor Green
Write-Host ''
Write-Host '次の手順:' -ForegroundColor Yellow
Write-Host '  1. このターミナルを閉じる' -ForegroundColor White
Write-Host '  2. 「Windowsキー + R」を押して「pwsh」と入力して Enter' -ForegroundColor White
Write-Host '     （PowerShell 7 のターミナルが開きます）' -ForegroundColor DarkGray
Write-Host '  3. Install-NicoCache.ps1 を実行する' -ForegroundColor White
Write-Host ''

Read-Host 'Press Enter to close'
