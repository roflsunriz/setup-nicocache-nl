#=============================================================================
# Windows の自動プロキシ設定スクリプト
#=============================================================================
[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $AutoConfigUrl = 'http://localhost:8080/proxy.pac',

    [Parameter()]
    [string]
    $ProxyBypassList = 'localhost;127.0.0.1;<local>',

    [switch]
    $DryRun
)

Set-StrictMode -Version Latest

$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
$entries = [ordered]@{
    AutoConfigURL = @{ PropertyType = 'String'; Value = $AutoConfigUrl }
    AutoDetect    = @{ PropertyType = 'DWord';  Value = 0 }
    ProxyEnable   = @{ PropertyType = 'DWord';  Value = 0 }
    ProxyServer   = @{ PropertyType = 'String'; Value = '' }
    ProxyOverride = @{ PropertyType = 'String'; Value = $ProxyBypassList }
}

if ($DryRun) {
    Write-Host '  [DRY-RUN] Windows の自動プロキシ設定を以下の値に変更します:'
    foreach ($entry in $entries.GetEnumerator()) {
        $type = $entry.Value.PropertyType
        Write-Host "    - $($entry.Key) ($type) → $($entry.Value.Value)"
    }
    Write-Host '  [DRY-RUN] 実際の変更は行いません。'
    return
}

if (-not (Test-Path -LiteralPath $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

foreach ($entry in $entries.GetEnumerator()) {
    New-ItemProperty -Path $regPath -Name $entry.Key -PropertyType $entry.Value.PropertyType -Value $entry.Value.Value -Force | Out-Null
}

Write-Host "  自動プロキシ スクリプト ($AutoConfigUrl) を使用するよう Windows の設定を構成しました。"
