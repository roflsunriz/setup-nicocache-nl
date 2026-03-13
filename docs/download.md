# ダウンロード

> [!WARNING]
> これらのパッケージは最新ではない可能性がある。必ずアップローダを確認すること。
> 利用による損害等の補償はしない。
> 最新情報は [NicoCache 本スレ](https://ff2ch.syoboi.jp/?q=NicoCache) を参照。

## Eclipse Temurin OpenJDK

[Eclipse Temurin OpenJDK (JDK17 LTS)](https://adoptium.net/temurin/releases/?os=windows&arch=x64&package=jdk&version=17)

```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```

## FFmpeg

[FFmpeg](https://www.gyan.dev/ffmpeg/builds/)

```powershell
winget install Gyan.FFmpeg
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

## 高速インストーラ

[NicoCache_nl-Setup.exe (2025/06/23 版)](https://www.dropbox.com/scl/fi/phqqtgfzb3yxsgzml54i2/NicoCache_nl-Setup.exe?rlkey=07d3x698ul6nnxsp7jzl042rz&st=nslk4ige&dl=1)

使い方は[高速インストーラ](fast-installer.md)を参照。

## 7-zip

[7-zip](https://7-zip.opensource.jp/)

```powershell
winget install 7zip.7zip
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

## Prebuilt Package

パワーユーザー（コンピュータの専門家）向け。JDK をインストールできない環境での一時利用を想定。サポートなし・ドキュメントなし。

[Prebuilt.7z](https://www.dropbox.com/scl/fi/i94h472mz0mguap355pqv/Prebuilt.7z?rlkey=472b7xbgnghh42599mujhhrec&st=caa8dyia&dl=1)

```powershell
Set-Location "C:\NicoCache_nl\WorkingDirectory"
Invoke-WebRequest -Uri "https://www.dropbox.com/scl/fi/i94h472mz0mguap355pqv/Prebuilt.7z?rlkey=472b7xbgnghh42599mujhhrec&st=caa8dyia&dl=1" -OutFile "Prebuilt.7z"
7z x "Prebuilt.7z"
```
