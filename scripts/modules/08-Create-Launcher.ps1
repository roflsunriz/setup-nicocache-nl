# ステップ 8: ランチャーの作成・実行ポリシー設定・タスクスケジューラー登録
# RunNicoCache.ps1 の生成、スクリプト実行ポリシーの設定、ログオン時自動起動タスクの登録

function Invoke-Step08 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName = 'ランチャー・タスクスケジューラーの設定'
    $ncDir    = 'C:\NicoCache_nl'
    $ps1Path  = "$ncDir\RunNicoCache.ps1"
    $taskName = 'NicoCacheAutoStart'

    Write-StepHeader "ステップ 8: $stepName"

    try {
        Invoke-Action -Description "RunNicoCache.ps1 ランチャースクリプトを $ps1Path に作成します" -DryRun:$DryRun -Action {
            $launcherContent = @'
Set-Location -Path $PSScriptRoot
Start-Process -FilePath "javaw" -ArgumentList "-jar", "NicoCache_nl.jar"
'@
            $launcherContent | Out-File -LiteralPath $ps1Path -Encoding utf8 -Force
        }

        Invoke-Action -Description "スクリプト実行ポリシーを RemoteSigned (LocalMachine) に設定します" -DryRun:$DryRun -Action {
            Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
        }

        Invoke-Action -Description "タスクスケジューラーに '$taskName' を登録します（ログオン時自動起動）" -DryRun:$DryRun -Action {
            $action  = New-ScheduledTaskAction -Execute 'pwsh.exe' `
                           -Argument "-WindowStyle Hidden -File `"$ps1Path`""
            $trigger = New-ScheduledTaskTrigger -AtLogOn
            Register-ScheduledTask -TaskName $taskName `
                                   -Action $action `
                                   -Trigger $trigger `
                                   -Description 'NicoCacheをログオン時に起動するタスク' `
                                   -Force | Out-Null
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message 'ランチャーを作成し、タスクスケジューラーに登録しました'
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
