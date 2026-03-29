# ダウンロード
!!! warning "常に最新版を確認すること"

    これらのパッケージは最新ではない可能性がある。 必ず[アップローダ](https://nicocache.jpn.org/)を確認すること。

    利用による損害等の補償はしない。 最新情報は [NicoCache 本スレ](https://ff2ch.syoboi.jp/?q=NicoCache) を参照。

## PowerShell インストールスクリプト

全手順を自動化するインストールスクリプト。  

詳しい使い方は [PowerShell インストールスクリプト(Windows)](fast-installer-win.md) を参照。  

---

## 個別パッケージ（手動インストール用）

スクリプトを使わずに手動でセットアップする場合や、特定のコンポーネントだけを更新する場合に参照。

## Eclipse Temurin OpenJDK

[Eclipse Temurin OpenJDK (JDK17 LTS)](https://adoptium.net/temurin/releases/?os=windows&arch=x64&package=jdk&version=17)

```powershell
$jdkVersion = "17"
winget install EclipseAdoptium.Temurin.$($jdkVersion).JDK --source winget
```
```powershell
$jdkVersion = "17"
winget upgrade EclipseAdoptium.Temurin.$($jdkVersion).JDK --source winget
```

## FFmpeg

[FFmpeg](https://www.gyan.dev/ffmpeg/builds/)

```powershell
winget install Gyan.FFmpeg --source winget
```
```powershell
winget upgrade Gyan.FFmpeg --source winget
```

## BouncyCastle

[BouncyCastle](https://www.bouncycastle.org/download/bouncy-castle-java/#latest)

```powershell
# バージョンを指定
$bcVersion = "1.83"
$jdkVersion = "18"

Set-Location "C:\NicoCache_nl\lib"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk$($jdkVersion)on/$($bcVersion)/bcprov-jdk$($jdkVersion)on-$($bcVersion).jar" -OutFile "bcprov.jar"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcutil-jdk$($jdkVersion)on/$($bcVersion)/bcutil-jdk$($jdkVersion)on-$($bcVersion).jar" -OutFile "bcutil.jar"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcpkix-jdk$($jdkVersion)on/$($bcVersion)/bcpkix-jdk$($jdkVersion)on-$($bcVersion).jar" -OutFile "bcpkix.jar"
```

## Apache Ant

[Apache Ant](https://ant.apache.org/bindownload.cgi)

```powershell
# バージョンを指定
$antVersion = "1.10.15"

Set-Location $env:TEMP
Invoke-WebRequest -Uri "https://dlcdn.apache.org//ant/binaries/apache-ant-$($antVersion)-bin.zip" -OutFile "apache-ant-$($antVersion)-bin.zip"
7z x "apache-ant-$($antVersion)-bin.zip"
Move-Item -Path "$env:TEMP\apache-ant-$($antVersion)" -Destination "C:\ant"
```

## 7-zip

[7-zip](https://7-zip.opensource.jp/)

```powershell
winget install 7zip.7zip --source winget
```
```powershell
winget upgrade 7zip.7zip --source winget
```

## メインアップローダ

[https://nicocache.jpn.org/](https://nicocache.jpn.org/)

```powershell
# バージョンを指定 (YYYY-MM-DD形式)
$ncVersion = "2026-01-15"
$targetURL = "https://nicocache.jpn.org/api/files/19/download"
$ncDir = "C:\NicoCache_nl"

Set-Location $ncDir
Invoke-WebRequest -Uri $targetURL -OutFile "$ncDir\NicoCache_nl-$($ncVersion).7z"
7z x "$ncDir\NicoCache_nl-$($ncVersion).7z" "-o$ncDir" -y
$nestedDir = "$ncDir\NicoCache_nl"
if (Test-Path $nestedDir) {
    
Get-ChildItem -Path $nestedDir -Force | Move-Item -Destination $ncDir -Force
    
Remove-Item -Path $nestedDir -Recurse -Force
}
```

## 旧アップローダのミラー

- [https://nicocache.jpn.org/second/](https://nicocache.jpn.org/second/)
- [https://nicocache.jpn.org/hofu/](https://nicocache.jpn.org/hofu/)


## フィルターまとめ

- 無制限の視聴履歴  
- 無制限のマイリスト機能  
- 強力なコメントフィルター  
- 動画プレイヤー拡張  
- ローカルプレーヤー・キャッシュ済みデータの再生  
- マルチリンクビデオコントローラー  
- 背景画像設定  
- コメントヒートマップ など

- [https://github.com/roflsunriz/filter-matome/releases](https://github.com/roflsunriz/filter-matome/releases)

```powershell
# GitHubリリースの最新アセット（7zファイル）を取得し、自動でダウンロードフォルダにダウンロード&展開

# リリース対象のGitHubリポジトリURL
$repoOwner = "roflsunriz"
$repoName = "filter-matome"
$apiUrl = "https://api.github.com/repos/$repoOwner/$repoName/releases/latest"

# ユーザーのダウンロードフォルダを取得
$downloadDir = [Environment]::GetFolderPath("UserProfile") + "\Downloads"

# 最新リリース情報を取得
$release = Invoke-WebRequest -Uri $apiUrl -UseBasicParsing | ConvertFrom-Json

# 一番最初のアセット（.7z）のURLを取得
$asset = $release.assets | Where-Object { $_.name -match "\.7z$" } | Select-Object -First 1
if (-not $asset) { $asset = $release.assets | Select-Object -First 1 }

$downloadUrl = $asset.browser_download_url
$fileName = $asset.name
$destPath = Join-Path $downloadDir $fileName

Write-Output "最新リリースファイル [$fileName] をダウンロードしています..."

Invoke-WebRequest -Uri $downloadUrl -OutFile $destPath

# 7-Zipで展開
Write-Output "7-Zipで展開中..."
& 7z x $destPath "-o$downloadDir" -y

Write-Output "完了: $fileName が $downloadDir に展開されました。"
```

補足  
- 7zipがインストールされていて、コマンドライン(7z.exe)がパスに通っている必要があります。    

