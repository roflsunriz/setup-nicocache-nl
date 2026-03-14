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

        Invoke-Action -Description "NicoCacheGUI.property を作成/更新します（HideWindow / LogWindowAlwaysOnTop）" -DryRun:$DryRun -Action {
            $propFile = "$ncDir\NicoCacheGUI.property"
            $settings = [ordered]@{
                HideWindow           = 'true'
                LogWindowAlwaysOnTop = 'false'
            }

            if (-not (Test-Path -LiteralPath $propFile)) {
                # ファイルが存在しない場合はデフォルト値で新規作成する
                $settings.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } |
                    Set-Content -LiteralPath $propFile -Encoding utf8
            } else {
                # ファイルが存在する場合は既存キーを置換、未存在キーは末尾に追記する
                [string[]]$lines = Get-Content -LiteralPath $propFile -Encoding utf8
                foreach ($entry in $settings.GetEnumerator()) {
                    $key = $entry.Key
                    $val = $entry.Value
                    if ($lines -match "^$key=") {
                        $lines = $lines -replace "^$key=.*", "$key=$val"
                    } else {
                        $lines += "$key=$val"
                    }
                }
                $lines | Set-Content -LiteralPath $propFile -Encoding utf8
            }
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message 'proxy.pac を作成し、NicoCacheGUI.property を作成/更新しました'
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
