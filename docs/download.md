# ダウンロード
<div style="text-align: right;">最終更新日：2026/03/17</div>
---

!!! warning "常に最新版を確認すること"

    これらのパッケージは最新ではない可能性がある。 必ず[アップローダ](https://nicocache.jpn.org/)を確認すること。

    利用による損害等の補償はしない。 最新情報は [NicoCache 本スレ](https://ff2ch.syoboi.jp/?q=NicoCache) を参照。

## PowerShell インストールスクリプト

全手順を自動化するインストールスクリプト。  

詳しい使い方は [PowerShell インストールスクリプト](fast-installer.md) を参照。  

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
$targetURL = "https://nicocache.jpn.org/download.php?id=19&key=514e8a406c60c969adc4ff934d5e65427cdc09c74cab334e543f7c96f80b4d81"
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
