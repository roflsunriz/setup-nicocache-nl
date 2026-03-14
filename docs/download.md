# ダウンロード

> [!WARNING]
> 
> これらのパッケージは最新ではない可能性がある。必ずアップローダを確認すること。
> 
> 利用による損害等の補償はしない。
> 
> 最新情報は [NicoCache 本スレ](https://ff2ch.syoboi.jp/?q=NicoCache) を参照。

## PowerShell インストールスクリプト

全手順を自動化するインストールスクリプト。詳しい使い方は [PowerShell インストールスクリプト](fast-installer.md) を参照。

### ダウンロードして実行

スクリプトをローカルに保存してから実行する方法。PowerShell 7 (`pwsh`) が必要。

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1" -OutFile "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
pwsh -File "$env:USERPROFILE\Downloads\Install-NicoCache.ps1"
```

### ネットワーク経由で直接実行

ダウンロード不要のワンライナー。PowerShell 7 (`pwsh`) が必要。

```powershell
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Install-NicoCache.ps1') }"
```

---

## 個別パッケージ（手動インストール用）

スクリプトを使わずに手動でセットアップする場合や、特定のコンポーネントだけを更新する場合に参照。

## Eclipse Temurin OpenJDK

[Eclipse Temurin OpenJDK (JDK17 LTS)](https://adoptium.net/temurin/releases/?os=windows&arch=x64&package=jdk&version=17)

```powershell
winget install EclipseAdoptium.Temurin.17.JDK --source winget
```

## FFmpeg

[FFmpeg](https://www.gyan.dev/ffmpeg/builds/)

```powershell
winget install Gyan.FFmpeg --source winget
```

## BouncyCastle

[BouncyCastle](https://www.bouncycastle.org/download/bouncy-castle-java/#latest)

```powershell
Set-Location "C:\NicoCache_nl\lib"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk18on/1.83/bcprov-jdk18on-1.83.jar" -OutFile "bcprov.jar"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcutil-jdk18on/1.83/bcutil-jdk18on-1.83.jar" -OutFile "bcutil.jar"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcpkix-jdk18on/1.83/bcpkix-jdk18on-1.83.jar" -OutFile "bcpkix.jar"
```

## Apache Ant

[Apache Ant](https://ant.apache.org/bindownload.cgi)

```powershell
Set-Location "C:\NicoCache_nl\WorkingDirectory"
Invoke-WebRequest -Uri "https://dlcdn.apache.org//ant/binaries/apache-ant-1.10.15-bin.zip" -OutFile "apache-ant-1.10.15-bin.zip"
7z x "apache-ant-1.10.15-bin.zip"
Move-Item -Path "C:\NicoCache_nl\WorkingDirectory\apache-ant-1.10.15" -Destination "C:\ant"
```

## 7-zip

[7-zip](https://7-zip.opensource.jp/)

```powershell
winget install 7zip.7zip --source winget
```

## メインアップローダ

[https://nicocache.jpn.org/](https://nicocache.jpn.org/)

```powershell
Set-Location "C:\NicoCache_nl"
Invoke-WebRequest -Uri "https://nicocache.jpn.org/download.php?id=19&key=514e8a406c60c969adc4ff934d5e65427cdc09c74cab334e543f7c96f80b4d81" -OutFile "NicoCache_nl-2026-01-15.7z"
7z x "NicoCache_nl-2026-01-15.7z"
```

## ミラーサイト

- [https://nicocache.jpn.org/second/](https://nicocache.jpn.org/second/)
- [https://nicocache.jpn.org/hofu/](https://nicocache.jpn.org/hofu/)
