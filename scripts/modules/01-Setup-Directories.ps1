# ステップ 1: ディレクトリ作成
# C:\NicoCache_nl および WorkingDirectory を作成する

function Invoke-Step01 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName = 'ディレクトリ作成'
    Write-StepHeader "ステップ 1: $stepName"

    try {
        Invoke-Action -Description "C:\NicoCache_nl を作成します" -DryRun:$DryRun -Action {
            New-Item -ItemType Directory -Path 'C:\NicoCache_nl' -Force | Out-Null
        }

        Invoke-Action -Description "C:\NicoCache_nl\WorkingDirectory を作成します" -DryRun:$DryRun -Action {
            New-Item -ItemType Directory -Path 'C:\NicoCache_nl\WorkingDirectory' -Force | Out-Null
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message 'C:\NicoCache_nl, C:\NicoCache_nl\WorkingDirectory を作成しました'
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
