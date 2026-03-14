# ステップ 7: 設定ファイルの初期化
# proxy.pac の作成・NicoCacheGUI.property の設定変更

function Invoke-Step07 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName = '設定ファイルの初期化'
    $ncDir    = 'C:\NicoCache_nl'

    Write-StepHeader "ステップ 7: $stepName"

    try {
        Invoke-Action -Description "proxy_sample.pac から proxy.pac を作成します" -DryRun:$DryRun -Action {
            $dest = "$ncDir\proxy.pac"
            if (-not (Test-Path -LiteralPath $dest)) {
                Copy-Item -LiteralPath "$ncDir\proxy_sample.pac" -Destination $dest
            }
        }

        Invoke-Action -Description "NicoCacheGUI.property の HideWindow / LogWindowAlwaysOnTop を設定します" -DryRun:$DryRun -Action {
            $propFile = "$ncDir\NicoCacheGUI.property"
            if (Test-Path -LiteralPath $propFile) {
                $content = Get-Content -LiteralPath $propFile -Encoding utf8
                $content = $content `
                    -replace '^HideWindow=.*',          'HideWindow=true' `
                    -replace '^LogWindowAlwaysOnTop=.*', 'LogWindowAlwaysOnTop=false'
                $content | Set-Content -LiteralPath $propFile -Encoding utf8
            }
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message 'proxy.pac を作成し、NicoCacheGUI.property を設定しました'
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
