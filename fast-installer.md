# 高速インストーラでのインストール方法

1. Windows + Rで「ファイル名を指定して実行」を開き、「powershell」と打ち込む
2. Eclipse Adoptium OpenJDK をインストールする
```powershell
winget install EclipseAdoptium.Temurin.17.JDK
```
3. 7-zipをインストール
```powershell
winget install 7zip.7zip
```
4. 高速インストーラをダウンロードして実行
```powershell
Set-Location $env:USERPROFILE\Downloads
Invoke-WebRequest -Uri "https://www.dropbox.com/scl/fi/phqqtgfzb3yxsgzml54i2/NicoCache_nl-Setup.exe?rlkey=07d3x698ul6nnxsp7jzl042rz&st=nslk4ige&dl=1" -OutFile "NicoCache_nl-Setup-2025-04-03.exe"
.\NicoCache_nl-Setup-2025-04-03.exe
```
5. インストールの終わりにスクリプトが自動実行されて以下の作業が行われる
- ANT_HOMEとPATHの自動設定
- 証明書の作成とWindows証明書ストアへの自動インストール
- プロキシサーバーの自動設定
- タスクスケジューラへの自動設定
- Firefoxの証明書の設定
- NicoCache_nl本体の自動更新

6. 大抵の場合、高速インストーラより最新の差分があるので[避難所](https://nicocache.jpn.org/)から本体をダウンロードして上書き更新する
7. 必要に応じて拡張機能をインストールしたり、nlFiltersを導入したり、config.propertiesやNicoCacacheGUI.propertyやproxy.pacの設定を調整する