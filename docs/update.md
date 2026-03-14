# NicoCache のアップデート方法
<div style="text-align: right;">最終更新日：2026/03/15</div>
---

1. [避難所](https://nicocache.jpn.org/)から本体をダウンロードして上書き更新する
2. 以上

??? example "`NicoCache_nl.jar` がビルドされずにソース差分だけが配布された場合"
    `ant` コマンドが使える場合：

    ```powershell
    Set-Location "C:\NicoCache_nl"
    ant version extract jar
    ```

    `javac` と `jar` で直接作る場合：

    `jar` 側では Ant の manifest を再現する必要があるため、先に次の内容を `C:\NicoCache_nl\manifest-nl.mf` として保存する。

    ```text
    Manifest-Version: 1.0
    Main-Class: dareka.NLMain
    Class-Path: sqlite-jdbc.jar igo.jar library.jar
    Add-Opens: java.base/sun.net java.base/sun.net.www.protocol.http java.base/java.net java.base/java.lang java.base/java.lang.reflect

    ```

    そのうえで、例えば `build-javac.ps1` として次を保存して実行する。

    ```powershell
    Set-Location "C:\NicoCache_nl"
    $sources = Get-ChildItem -Path ".\src\dareka" -Recurse -Filter "*.java" |
        Where-Object { $_.Name -ne "package-info.java" } |
        ForEach-Object { $_.FullName }
    javac --release 11 -encoding UTF-8 -Xlint:-options -d ".\src" $sources
    jar cfm "NicoCache_nl.jar" ".\manifest-nl.mf" -C ".\src" dareka -C ".\src" native
    ```
