# ステップ 6: 証明書の生成とインポート
# genCerts.bat を実行して証明書を生成し、Windows 証明書ストアにインポートする
# Firefox への証明書インポートは GUI 操作のため、手順を案内するのみ

function Invoke-Step06 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName   = '証明書の生成とインポート'
    $ncDir      = 'C:\NicoCache_nl'
    $configPath = "$ncDir\config.properties"
    $caCerPath  = "$ncDir\certs\ca.cer"

    Write-StepHeader "ステップ 6: $stepName"

    try {
        Invoke-Action -Description "genCerts.bat を実行して証明書を生成します" -DryRun:$DryRun -Action {
            Push-Location $ncDir
            try {
                & .\genCerts.bat
                if ($LASTEXITCODE -ne 0) {
                    throw "genCerts.bat が失敗しました (ExitCode: $LASTEXITCODE)"
                }
            } finally {
                Pop-Location
            }
        }

        Invoke-Action -Description "config.properties.default を config.properties にコピーします" -DryRun:$DryRun -Action {
            Copy-Item -LiteralPath "$ncDir\config.properties.default" `
                      -Destination $configPath -Force
        }

        Invoke-Action -Description "config.properties に enableMitM=true を追記します" -DryRun:$DryRun -Action {
            $content = Get-Content -LiteralPath $configPath -Raw -Encoding utf8
            if ($content -notmatch 'enableMitM=') {
                Add-Content -LiteralPath $configPath -Value 'enableMitM=true' -Encoding utf8
            }
        }

        Invoke-Action -Description "CA 証明書を Windows 証明書ストア (CurrentUser\Root) にインポートします" -DryRun:$DryRun -Action {
            Import-Certificate -FilePath $caCerPath -CertStoreLocation 'Cert:\CurrentUser\Root' | Out-Null
        }

        # Firefox は GUI 操作のため手動案内
        Write-Host ''
        Write-Host '  ┌─────────────────────────────────────────────────────────────┐' -ForegroundColor Magenta
        Write-Host '  │  [手動作業] Firefox への CA 証明書インポート                │' -ForegroundColor Magenta
        Write-Host '  ├─────────────────────────────────────────────────────────────┤' -ForegroundColor Magenta
        Write-Host '  │  1. Firefox を開く                                          │' -ForegroundColor White
        Write-Host '  │  2. 設定 → プライバシーとセキュリティ → 証明書を表示       │' -ForegroundColor White
        Write-Host '  │  3. 認証局証明書タブ → インポート                          │' -ForegroundColor White
        Write-Host "  │  4. $caCerPath を選択               │" -ForegroundColor White
        Write-Host '  │  5. 「この認証局によるウェブサイトの識別を信頼する」にチェック│' -ForegroundColor White
        Write-Host '  │  6. OK → Firefox を再起動する                              │' -ForegroundColor White
        Write-Host '  └─────────────────────────────────────────────────────────────┘' -ForegroundColor Magenta
        Write-Host ''

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message '証明書を生成し Windows 証明書ストアにインポートしました（Firefox は手動でインポートが必要）'
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
