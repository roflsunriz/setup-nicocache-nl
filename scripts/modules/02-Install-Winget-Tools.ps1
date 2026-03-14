# ステップ 2: 依存ツールのインストール
# winget を使って JDK17・FFmpeg・7-zip をインストールする

function Invoke-Step02 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName = '依存ツールのインストール'
    Write-StepHeader "ステップ 2: $stepName"

    # winget の存在確認
    if (-not $DryRun) {
        if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
            return New-StepResult -Step $stepName -Status 'Failed' `
                -Message 'winget が見つかりません。Windows 10 1809 以降、または App Installer が必要です。'
        }
    }

    $tools = @(
        [PSCustomObject]@{ Id = 'EclipseAdoptium.Temurin.17.JDK'; Name = 'Eclipse Temurin OpenJDK 17' },
        [PSCustomObject]@{ Id = 'Gyan.FFmpeg';                     Name = 'FFmpeg' },
        [PSCustomObject]@{ Id = '7zip.7zip';                       Name = '7-zip' }
    )

    try {
        foreach ($tool in $tools) {
            $toolId   = $tool.Id
            $toolName = $tool.Name
            Invoke-Action -Description "winget install $toolId ($toolName)" -DryRun:$DryRun -Action {
                winget install $toolId `
                    --accept-source-agreements `
                    --accept-package-agreements `
                    --silent `
                    --disable-interactivity
                # 0 = 成功, -1978335189 (0x8A15002B) = 既インストール済み のどちらも正常
                if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
                    throw "winget install $toolId が失敗しました (ExitCode: $LASTEXITCODE)"
                }
            }
        }

        # 現在のセッションの PATH を再読み込みする
        Invoke-Action -Description '環境変数 PATH をシステムから再読み込みします' -DryRun:$DryRun -Action {
            Refresh-EnvironmentPath
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message 'JDK 17, FFmpeg, 7-zip をインストールしました'
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
