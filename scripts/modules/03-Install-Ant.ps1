# ステップ 3: Apache Ant のインストール
# ダウンロード・展開・C:\ant への移動・環境変数（ANT_HOME / PATH）の設定

function Invoke-Step03 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName   = 'Apache Ant のインストール'
    $antVersion = '1.10.15'
    $antZip     = "apache-ant-$antVersion-bin.zip"
    $antUrl     = "https://dlcdn.apache.org//ant/binaries/$antZip"
    $workDir    = 'C:\NicoCache_nl\WorkingDirectory'
    $antDest    = 'C:\ant'

    Write-StepHeader "ステップ 3: $stepName"

    try {
        # 冪等性チェック: C:\ant が既に存在する場合はスキップ
        if (-not $DryRun -and (Test-Path -LiteralPath $antDest)) {
            Write-Host "  C:\ant は既に存在します。スキップします。" -ForegroundColor DarkGray
            return New-StepResult -Step $stepName -Status 'Skipped' `
                -Message 'C:\ant が既に存在するためスキップしました'
        }

        $7z = if ($DryRun) { '7z' } else { Get-7ZipPath }

        Invoke-Action -Description "Apache Ant $antVersion をダウンロードします ($antUrl)" -DryRun:$DryRun -Action {
            Invoke-WebRequest -Uri $antUrl -OutFile "$workDir\$antZip"
        }

        Invoke-Action -Description "Apache Ant を $workDir に展開します" -DryRun:$DryRun -Action {
            Push-Location $workDir
            try {
                & $7z x $antZip -y | Out-Null
                if ($LASTEXITCODE -ne 0) {
                    throw "7z の展開に失敗しました (ExitCode: $LASTEXITCODE)"
                }
            } finally {
                Pop-Location
            }
        }

        Invoke-Action -Description "apache-ant-$antVersion を $antDest に移動します" -DryRun:$DryRun -Action {
            Move-Item -LiteralPath "$workDir\apache-ant-$antVersion" -Destination $antDest
        }

        Invoke-Action -Description "ユーザー環境変数 ANT_HOME を $antDest に設定します" -DryRun:$DryRun -Action {
            [Environment]::SetEnvironmentVariable('ANT_HOME', $antDest, 'User')
        }

        Invoke-Action -Description 'ユーザー環境変数 PATH に C:\ant\bin を先頭追加します' -DryRun:$DryRun -Action {
            $currentPath = [Environment]::GetEnvironmentVariable('Path', 'User') ?? ''
            if ($currentPath -notlike '*C:\ant\bin*') {
                [Environment]::SetEnvironmentVariable('Path', "C:\ant\bin;$currentPath", 'User')
            }
            # 現在のセッションにも反映
            $env:ANT_HOME = $antDest
            if ($env:Path -notlike '*C:\ant\bin*') {
                $env:Path = "C:\ant\bin;$env:Path"
            }
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message "Apache Ant $antVersion をインストールし、環境変数を設定しました"
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
