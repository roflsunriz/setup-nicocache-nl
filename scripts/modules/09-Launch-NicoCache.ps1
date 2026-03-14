# ステップ 9: NicoCache_nl の起動
# ランチャースクリプト (RunNicoCache.ps1) を通じて NicoCache_nl を起動する

function Invoke-Step09 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName = 'NicoCache_nl の起動'
    $ncDir    = 'C:\NicoCache_nl'
    $ps1Path  = "$ncDir\RunNicoCache.ps1"

    Write-StepHeader "ステップ 9: $stepName"

    try {
        if ($DryRun) {
            Invoke-Action -Description "NicoCache_nl を起動します ($ps1Path)" -DryRun:$DryRun -Action {}
            return New-StepResult -Step $stepName -Status 'Success' `
                -Message '[DRY-RUN] NicoCache_nl の起動をシミュレートしました'
        }

        $launch = Read-Host '  NicoCache_nl を今すぐ起動しますか？ [Y/N]'
        if ($launch -eq 'Y' -or $launch -eq 'y') {
            Invoke-Action -Description "NicoCache_nl を起動します ($ps1Path)" -DryRun:$DryRun -Action {
                Start-Process pwsh -ArgumentList "-WindowStyle Hidden -File `"$ps1Path`""
            }
            return New-StepResult -Step $stepName -Status 'Success' `
                -Message 'NicoCache_nl を起動しました'
        } else {
            return New-StepResult -Step $stepName -Status 'Skipped' `
                -Message "起動をスキップしました。手動で $ps1Path を実行してください"
        }
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
