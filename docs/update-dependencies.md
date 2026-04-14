# 依存関係ソフトウェアのアップデート方法

管理者権限でターミナルを起動して以下を実行。(Windows + R -> 「wt」または「wt.exe」と入力 -> Ctrl + Shift + Enter -> UAC 「はい」)  

NicoCache_nl本体を停止してからアップデートを実行。   
```powershell
Stop-Process -Name javaw -Force
Stop-Process -Name java -Force
```

## JDKのアップデート
```powershell
winget upgrade EclipseAdoptium.Temurin.17.JDK --source winget
```
```powershell
winget upgrade EclipseAdoptium.Temurin.21.JDK --source winget
```

## FFmpegのアップデート
```powershell
winget upgrade Gyan.FFmpeg --source winget
```

## 7-zipのアップデート
```powershell
winget upgrade 7zip.7zip --source winget
```

## まとめてアップデート
```powershell
winget upgrade --all
```

## Bouncy CastleとApache Ant
[ダウンロード](./download.md)のスクリプトを参考に、バージョン番号を最新のものに入れ替えて実行する。  