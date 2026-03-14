#Requires -Version 7.0
<#
.SYNOPSIS
    NicoCache_nl 自動インストーラ

.DESCRIPTION
    docs/install.md の全手順を自動化するインストーラスクリプト。
    各処理はモジュールに分割されており、失敗時のリトライと最終リザルト画面を備える。

.PARAMETER DryRun
    このスイッチを指定すると、実際の変更は行わず動作内容のシミュレーション出力のみを行う。

.EXAMPLE
    # 通常インストール（管理者権限が自動的に要求される）
    pwsh -File Install-NicoCache.ps1

.EXAMPLE
    # DryRun で事前確認
    pwsh -File Install-NicoCache.ps1 -DryRun

.EXAMPLE
    # ネットワーク経由で直接実行
    iex "& { $(iwr -useb 'https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1') }"

.EXAMPLE
    # ネットワーク経由で DryRun 確認（一時ファイルに保存してから実行）
    $tmp = New-TemporaryFile
    irm "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" | Set-Content $tmp
    pwsh -File $tmp -DryRun
#>
[CmdletBinding()]
param(
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding          = [System.Text.Encoding]::UTF8

# =============================================================================
# 定数
# =============================================================================
$REPO_RAW_BASE = 'https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts'

$MODULE_FILES = @(
    'modules/00-Common.ps1',
    'modules/01-Setup-Directories.ps1',
    'modules/02-Install-Winget-Tools.ps1',
    'modules/03-Install-Ant.ps1',
    'modules/04-Install-NicoCache.ps1',
    'modules/05-Install-BouncyCastle.ps1',
    'modules/06-Generate-Certificates.ps1',
    'modules/07-Setup-Config.ps1',
    'modules/08-Create-Launcher.ps1',
    'modules/09-Launch-NicoCache.ps1'
)

# =============================================================================
# 管理者権限チェックと自動昇格
# =============================================================================
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host '管理者権限が必要です。UAC プロンプトを表示します...' -ForegroundColor Yellow

    # iex 経由で実行された場合は $PSCommandPath が空のためスクリプトを一時保存する
    if ($PSCommandPath -ne '') {
        $scriptPath = $PSCommandPath
    } else {
        $tempDir = Join-Path $env:TEMP 'NicoCacheInstaller'
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        $scriptPath = Join-Path $tempDir 'Install-NicoCache.ps1'
        Write-Host "  スクリプトを一時ディレクトリに保存しています ($scriptPath)..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri "$REPO_RAW_BASE/Install-NicoCache.ps1" -OutFile $scriptPath
    }

    $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    if ($DryRun) { $argList += ' -DryRun' }
    Start-Process pwsh -Verb RunAs -ArgumentList $argList
    exit
}

# =============================================================================
# ウェルカムバナー
# =============================================================================
Clear-Host
Write-Host '================================================================' -ForegroundColor Green
Write-Host '  NicoCache_nl 自動インストーラへようこそ                       ' -ForegroundColor Green
Write-Host '================================================================' -ForegroundColor Green

if ($DryRun) {
    Write-Host ''
    Write-Host '================================================================' -ForegroundColor Cyan
    Write-Host '  [DRY-RUN] 動作確認モード: 実際の変更は行いません             ' -ForegroundColor Cyan
    Write-Host '================================================================' -ForegroundColor Cyan
}
Write-Host ''

# =============================================================================
# モジュールの準備
# =============================================================================

# スクリプトが直接ファイルとして実行されているか (iex 経由か) を判定する
$scriptDir = if ($PSScriptRoot -ne '') { $PSScriptRoot } else { Join-Path $env:TEMP 'NicoCacheInstaller' }
$modulesDir = Join-Path $scriptDir 'modules'

# モジュールが未ダウンロードの場合はリポジトリから取得する
if (-not (Test-Path -LiteralPath (Join-Path $modulesDir '00-Common.ps1'))) {
    Write-Host 'モジュールをリポジトリからダウンロードしています...' -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $modulesDir -Force | Out-Null

    foreach ($moduleFile in $MODULE_FILES) {
        $uri  = "$REPO_RAW_BASE/$moduleFile"
        $dest = Join-Path $scriptDir $moduleFile
        Write-Host "  ダウンロード中: $moduleFile" -ForegroundColor DarkGray
        Invoke-WebRequest -Uri $uri -OutFile $dest
    }
    Write-Host '  モジュールのダウンロードが完了しました。' -ForegroundColor Green
    Write-Host ''
}

# dot-source でモジュールを読み込む
foreach ($moduleFile in $MODULE_FILES) {
    . (Join-Path $scriptDir $moduleFile)
}

# =============================================================================
# インストール実行
# =============================================================================
$stepFunctionNames = @(
    'Invoke-Step01',
    'Invoke-Step02',
    'Invoke-Step03',
    'Invoke-Step04',
    'Invoke-Step05',
    'Invoke-Step06',
    'Invoke-Step07',
    'Invoke-Step08',
    'Invoke-Step09'
)

$results = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($fnName in $stepFunctionNames) {
    $result = & $fnName -DryRun:$DryRun
    $results.Add($result)

    if ($result.Status -eq 'Failed') {
        Write-Host ''
        Write-Host "  [失敗] $($result.Step): $($result.Message)" -ForegroundColor Red

        if (-not $DryRun) {
            $retry = Read-Host '  このステップをリトライしますか？ [Y/N]'
            if ($retry -eq 'Y' -or $retry -eq 'y') {
                Write-Host '  リトライします...' -ForegroundColor Yellow
                $retryResult = & $fnName -DryRun:$DryRun
                $results[$results.Count - 1] = $retryResult

                if ($retryResult.Status -eq 'Success') {
                    Write-Host "  [リトライ成功] $($retryResult.Step)" -ForegroundColor Green
                } else {
                    Write-Host "  [リトライ失敗] $($retryResult.Message) — 次のステップに進みます。" -ForegroundColor Red
                }
            }
        }
    } elseif ($result.Status -eq 'Success') {
        Write-Host "  [成功] $($result.Step)" -ForegroundColor Green
    } elseif ($result.Status -eq 'Skipped') {
        Write-Host "  [スキップ] $($result.Step): $($result.Message)" -ForegroundColor Yellow
    }
}

# =============================================================================
# リザルト画面
# =============================================================================
Write-Host ''
Write-Host '================================================================' -ForegroundColor Green
$modeLabel = if ($DryRun) { '[DRY-RUN] インストールシミュレーション完了' } else { 'インストール完了' }
Write-Host "  $modeLabel" -ForegroundColor Green
Write-Host '================================================================' -ForegroundColor Green
Write-Host ''

$total   = $results.Count
$ok      = @($results | Where-Object { $_.Status -eq 'Success' }).Count
$skipped = @($results | Where-Object { $_.Status -eq 'Skipped' }).Count
$failed  = @($results | Where-Object { $_.Status -eq 'Failed'  }).Count
$rate    = if ($total -gt 0) { [Math]::Round((($ok + $skipped) / $total) * 100, 1) } else { 0 }

$rateColor = if ($failed -eq 0) { 'Green' } elseif ($failed -lt $total) { 'Yellow' } else { 'Red' }

Write-Host "完了率: $rate%  (成功: $ok / スキップ: $skipped / 失敗: $failed  [合計: $total ステップ])" `
    -ForegroundColor $rateColor
Write-Host ''
Write-Host 'ステップ結果一覧:' -ForegroundColor White
$results | Format-Table -AutoSize -Property Step, Status, Message

if ($failed -gt 0) {
    Write-Host '--- 失敗したステップ ---' -ForegroundColor Red
    $results | Where-Object { $_.Status -eq 'Failed' } | ForEach-Object {
        Write-Host "  * $($_.Step): $($_.Message)" -ForegroundColor Red
    }
    Write-Host ''
}

if (-not $DryRun -and $failed -eq 0) {
    Write-Host '✔ NicoCache_nl のインストールが正常に完了しました！' -ForegroundColor Green
    Write-Host ''
    Write-Host '次の手順（手動）:' -ForegroundColor Yellow
    Write-Host '  1. Firefox で CA 証明書をインポートしてください' -ForegroundColor White
    Write-Host '     （設定 → プライバシーとセキュリティ → 証明書を表示 → 認証局 → インポート）' -ForegroundColor DarkGray
    Write-Host '     ファイル: C:\NicoCache_nl\certs\ca.cer' -ForegroundColor DarkGray
    Write-Host '  2. 必要に応じて C:\NicoCache_nl\config.properties を編集してください' -ForegroundColor White
    Write-Host '  3. 次回ログオン時から NicoCache_nl が自動起動します' -ForegroundColor White
    Write-Host ''
}

Read-Host 'Enter キーを押して閉じます'
