# ステップ 4: NicoCache_nl 本体のインストール
# 避難所アップローダからダウンロードして展開する

function Invoke-Step04 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName  = 'NicoCache_nl 本体のインストール'
    $ncVersion = '2026-01-15'
    $ncFile    = "NicoCache_nl-$ncVersion.7z"
    $ncUrl     = 'https://nicocache.jpn.org/download.php?id=19&key=514e8a406c60c969adc4ff934d5e65427cdc09c74cab334e543f7c96f80b4d81'
    $ncDir     = 'C:\NicoCache_nl'

    Write-StepHeader "ステップ 4: $stepName"

    try {
        # 冪等性チェック: NicoCache_nl.jar が既に存在する場合はスキップ
        if (-not $DryRun -and (Test-Path -LiteralPath "$ncDir\NicoCache_nl.jar")) {
            Write-Host "  NicoCache_nl.jar は既に存在します。スキップします。" -ForegroundColor DarkGray
            return New-StepResult -Step $stepName -Status 'Skipped' `
                -Message 'NicoCache_nl.jar が既に存在するためスキップしました'
        }

        $7z = if ($DryRun) { '7z' } else { Get-7ZipPath }

        Invoke-Action -Description "NicoCache_nl $ncVersion をダウンロードします" -DryRun:$DryRun -Action {
            Invoke-WebRequest -Uri $ncUrl -OutFile "$ncDir\$ncFile"
        }

        Invoke-Action -Description "NicoCache_nl-$ncVersion.7z を $ncDir に展開します" -DryRun:$DryRun -Action {
            Push-Location $ncDir
            try {
                & $7z x $ncFile -y | Out-Null
                if ($LASTEXITCODE -ne 0) {
                    throw "7z の展開に失敗しました (ExitCode: $LASTEXITCODE)"
                }
            } finally {
                Pop-Location
            }
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message "NicoCache_nl $ncVersion をインストールしました"
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
