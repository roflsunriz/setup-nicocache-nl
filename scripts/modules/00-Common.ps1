# NicoCache_nl インストーラ 共通ユーティリティ
# このファイルはメインスクリプトから dot-source で読み込まれる

function Invoke-Action {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Description,
        [Parameter(Mandatory)]
        [scriptblock]$Action,
        [switch]$DryRun
    )
    if ($DryRun) {
        Write-Host "  [DRY-RUN] $Description" -ForegroundColor Cyan
    } else {
        Write-Host "  >> $Description" -ForegroundColor DarkGray
        & $Action
    }
}

function Write-StepHeader {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Title
    )
    Write-Host ""
    Write-Host "  ---- $Title ----" -ForegroundColor Yellow
}

function New-StepResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Step,
        [Parameter(Mandatory)]
        [ValidateSet('Success', 'Failed', 'Skipped')]
        [string]$Status,
        [string]$Message = ''
    )
    return [PSCustomObject]@{
        Step    = $Step
        Status  = $Status
        Message = $Message
    }
}

function Get-7ZipPath {
    [CmdletBinding()]
    param()
    $cmd = Get-Command '7z' -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $defaultPath = 'C:\Program Files\7-Zip\7z.exe'
    if (Test-Path -LiteralPath $defaultPath) { return $defaultPath }
    throw '7-zip が見つかりません。ステップ 2 が正常に完了しているか確認してください。'
}

function Refresh-EnvironmentPath {
    [CmdletBinding()]
    param()
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path    = @($machinePath, $userPath) | Where-Object { $_ } | Join-String -Separator ';'
}
