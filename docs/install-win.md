# NicoCache_nl のインストール(Windows)
1. 「Windowsキー + Rキー」を同時押しする  
2. 出てきたウィンドウに「wt」または「wt.exe」と打つ  
3. Windows ターミナルが開くのでPowershell 7 をインストールする  
```powershell
winget install Microsoft.PowerShell --source winget
```
4. ターミナルを閉じる  
5. 「Windowsキー + Rキー」を同時押し、「wt」または「wt.exe」と入力し、再度ターミナルを開く  
6. 「ターミナル」の「∨」ボタンを押し、「設定」を開き、「スタートアップ」->「デフォルトのプロファイル」を「Powershell」（Windows PowerShellではない）に変更する  
![ターミナルの設定](./images/terminal-settings.png)
7. ターミナルを再起動する（ターミナルの表示にPowershell 7.5.5のようなバージョンが表示されていればOK）  
8. Cドライブ直下に`NicoCache_nl`ディレクトリを作成し、ユーザー環境変数`NICOCACHE_HOME`を設定する  
```powershell
$ncDir = "C:\NicoCache_nl"
New-Item -ItemType Directory -Path $ncDir
[Environment]::SetEnvironmentVariable("NICOCACHE_HOME", $ncDir, "User")
```
9. ターミナルでEclipse Temurin OpenJDK 17 と FFmpegをインストールする  
```powershell
$jdkVersion = "17"
winget install EclipseAdoptium.Temurin.$($jdkVersion).JDK --source winget
winget install Gyan.FFmpeg --source winget
```
10. 7-zipをインストールし、ユーザー環境変数のPathに7-zipを登録する  
```powershell
winget install 7zip.7zip --source winget
[Environment]::SetEnvironmentVariable("Path", "C:\Program Files\7-Zip;$env:Path", "User")
```
11. 環境変数を適用するためターミナルを再起動する。  
12. Apache Antをダウンロードし、展開し、Cドライブ直下に`ant`ディレクトリを移動  
```powershell
# バージョンを指定
$antVersion = "1.10.15"
$antDir = "C:\ant"

Set-Location $env:TEMP
Invoke-WebRequest -Uri "https://dlcdn.apache.org//ant/binaries/apache-ant-$($antVersion)-bin.zip" -OutFile "apache-ant-$($antVersion)-bin.zip"
7z x "apache-ant-$($antVersion)-bin.zip"
Move-Item -Path "$env:TEMP\apache-ant-$($antVersion)" -Destination $antDir
```
13. ユーザー環境変数のPathにantを登録。ANT_HOMEも登録  
```powershell
[Environment]::SetEnvironmentVariable("ANT_HOME", $antDir, "User")
[Environment]::SetEnvironmentVariable("Path", "$antDir\bin;$env:Path", "User")
```
14. ターミナルを再起動して環境変数を適用させる。  
15. `NicoCache_nl-2026-01-15.7z`を避難所アップローダからダウンロードして展開  
```powershell
# バージョンを指定 (YYYY-MM-DD形式)
$ncVersion = "2026-01-15"
$targetURL = "https://nicocache.jpn.org/download.php?id=19&key=514e8a406c60c969adc4ff934d5e65427cdc09c74cab334e543f7c96f80b4d81"

Set-Location $env:NICOCACHE_HOME
Invoke-WebRequest -Uri $targetURL -OutFile "NicoCache_nl-$($ncVersion).7z"
7z x "NicoCache_nl-$($ncVersion).7z" "-o$env:NICOCACHE_HOME" -y
$nestedDir = "$env:NICOCACHE_HOME\NicoCache_nl"
if (Test-Path $nestedDir) {
    Get-ChildItem -Path $nestedDir -Force | Move-Item -Destination $env:NICOCACHE_HOME -Force
    Remove-Item -Path $nestedDir -Recurse -Force
}
```
16. BouncyCastleから依存ライブラリをダウンロードし、証明書を生成、ユーザー証明書に証明書を追加 (Chromeは自動的にWindowsの証明書を参照する)  

!!! warning
    genCerts.batの実行フェーズでは`pause`が入るので`Enter`等のキーボード操作が必要。

    誤ってターミナルを閉じないように注意！

    `ImportCertificate`の実行フェーズでは確認画面が出るのでOKを押して承諾する。

```powershell
# バージョンを指定
$bcVersion = "1.83"
$jdkVersion = "18"

Set-Location "$env:NICOCACHE_HOME\lib"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk$($jdkVersion)on/$($bcVersion)/bcprov-jdk$($jdkVersion)on-$($bcVersion).jar" -OutFile "bcprov.jar"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcutil-jdk$($jdkVersion)on/$($bcVersion)/bcutil-jdk$($jdkVersion)on-$($bcVersion).jar" -OutFile "bcutil.jar"
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/org/bouncycastle/bcpkix-jdk$($jdkVersion)on/$($bcVersion)/bcpkix-jdk$($jdkVersion)on-$($bcVersion).jar" -OutFile "bcpkix.jar"
Set-Location $env:NICOCACHE_HOME
& .\genCerts.bat
Copy-Item -Path "$env:NICOCACHE_HOME\config.properties.default" -Destination "$env:NICOCACHE_HOME\config.properties"
Add-Content -Path "$env:NICOCACHE_HOME\config.properties" -Value "enableMitM=true"
Import-Certificate -FilePath "$env:NICOCACHE_HOME\certs\ca.cer" -CertStoreLocation "Cert:\CurrentUser\Root"
```
17. Firefoxを開く  
18. 設定 > プライバシーとセキュリティ > 証明書 > 証明書を表示 > 認証局証明書 > インポート 
![Firefoxの証明書インポート](./images/firefox-certs.png)
19. certs/ca.cerを選択  
20. 「この認証局によるウェブサイトの識別を信頼する」にチェックを入れる  
21. Firefoxを再起動する  
22. `proxy_sample.pac`から`proxy.pac`を作成  
```powershell
Set-Location $env:NICOCACHE_HOME
Copy-Item -Path "$env:NICOCACHE_HOME\proxy_sample.pac" -Destination "$env:NICOCACHE_HOME\proxy.pac"
```
23. `Set-WindowsAutoProxy.ps1`をネットワーク経由で実行してWindowsを自動プロキシスクリプトに対応させる  
```powershell
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/roflsunriz/setup-nicocache-nl/main/scripts/Set-WindowsAutoProxy.ps1') }"
```
24. その他、`config.properties`に変更したい設定があれば編集する。デフォルト設定は`defaults`ディレクトリに格納されている。  
25. ランチャースクリプトを作成  
```powershell
$script = @'
Set-Location -Path $env:NICOCACHE_HOME
Start-Process -FilePath "javaw" -ArgumentList "-jar", "NicoCache_nl.jar"
'@
$script | Out-File -FilePath "$env:NICOCACHE_HOME\RunNicoCache.ps1" -Encoding utf8
```
26. `NicoCacheGUI.property`の設定を書き換える  
```powershell
# NicoCacheGUI.property を作成し、設定を書き込む
$lines = @(
    "HideWindow=true",
    "LogWindowAlwaysOnTop=false"
)
Set-Content -Path "$env:NICOCACHE_HOME\NicoCacheGUI.property" -Value $lines -Encoding utf8
```
27. 「Windowsキー + Rキー」を同時押し -> 「ファイル名を指定して実行」ダイアログ -> 「wt」または「wt.exe」と入力 -> Ctrl + Shift + Enterキーを同時押ししてターミナルを管理者権限で起動し、以下を実行してスクリプトの実行を許可（ウィンドウにAdministratorと表示されていればOK）  
```powershell
Set-ExecutionPolicy RemoteSigned -Force
```
28. 続けて管理者権限で起動したターミナルでタスクスケジューラーにランチャースクリプトを登録  
```powershell
$taskName = "NicoCacheAutoStart"
$ps1Path = "$env:NICOCACHE_HOME\RunNicoCache.ps1"
$action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-WindowStyle Hidden -File `"$ps1Path`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Description "NicoCacheをログオン時に起動するタスク" -Force
```
29. NicoCache_nlを起動  
```powershell
Set-Location $env:NICOCACHE_HOME
Start-Process pwsh -ArgumentList "-WindowStyle Hidden -File `"$env:NICOCACHE_HOME\RunNicoCache.ps1`""
```
30. インストール完了。なお、アンイストール時はCドライブ直下の`NicoCache_nl`ディレクトリを削除し、タスクスケジューラーから`NicoCacheAutoStart`を削除すればOK  
```powershell
Remove-Item -Path $env:NICOCACHE_HOME -Recurse -Force
Unregister-ScheduledTask -TaskName "NicoCacheAutoStart" -Confirm:$false
```
