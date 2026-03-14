# ステップ 5: BouncyCastle ライブラリのダウンロード
# Maven Central から bcprov・bcutil・bcpkix をダウンロードして C:\NicoCache_nl\lib に配置する

function Invoke-Step05 {
    [CmdletBinding()]
    param([switch]$DryRun)

    $stepName  = 'BouncyCastle ライブラリのダウンロード'
    $bcVersion = '1.83'
    $libDir    = 'C:\NicoCache_nl\lib'
    $baseUrl   = 'https://repo1.maven.org/maven2/org/bouncycastle'

    $libs = @(
        [PSCustomObject]@{
            Artifact = "bcprov-jdk18on/$bcVersion/bcprov-jdk18on-$bcVersion.jar"
            OutFile  = 'bcprov.jar'
        },
        [PSCustomObject]@{
            Artifact = "bcutil-jdk18on/$bcVersion/bcutil-jdk18on-$bcVersion.jar"
            OutFile  = 'bcutil.jar'
        },
        [PSCustomObject]@{
            Artifact = "bcpkix-jdk18on/$bcVersion/bcpkix-jdk18on-$bcVersion.jar"
            OutFile  = 'bcpkix.jar'
        }
    )

    Write-StepHeader "ステップ 5: $stepName"

    try {
        foreach ($lib in $libs) {
            $outFile  = $lib.OutFile
            $outPath  = "$libDir\$outFile"
            $artifact = $lib.Artifact
            $url      = "$baseUrl/$artifact"

            if (-not $DryRun -and (Test-Path -LiteralPath $outPath)) {
                Write-Host "  $outFile は既に存在します。スキップします。" -ForegroundColor DarkGray
                continue
            }

            Invoke-Action -Description "$outFile をダウンロードします ($url)" -DryRun:$DryRun -Action {
                Invoke-WebRequest -Uri $url -OutFile $outPath
            }
        }

        return New-StepResult -Step $stepName -Status 'Success' `
            -Message "BouncyCastle $bcVersion (bcprov, bcutil, bcpkix) をダウンロードしました"
    } catch {
        return New-StepResult -Step $stepName -Status 'Failed' -Message $_.Exception.Message
    }
}
