# NicoCache_nl のインストール(macOS)
<div style="text-align: right;">最終更新日：2026/03/17</div>
---

!!! note "対象バージョン"
    macOS 13 Ventura 以降を対象としています。デフォルトシェルは **zsh** を前提としています。

1. ターミナルを開く（Spotlight: `Cmd + Space` → 「ターミナル」で検索）  
2. Homebrew をインストールする（未インストールの場合）  
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
3. Eclipse Temurin OpenJDK 17・FFmpeg・p7zip をインストールする  
```bash
brew install --cask temurin@17
brew install ffmpeg p7zip
```
4. ホームディレクトリに `NicoCache_nl` ディレクトリを作成し、環境変数 `NICOCACHE_HOME` を設定する  
```bash
NC_DIR="$HOME/NicoCache_nl"
mkdir -p "$NC_DIR"
echo "export NICOCACHE_HOME=\"$NC_DIR\"" >> ~/.zshrc
source ~/.zshrc
```
5. Apache Ant を Homebrew でインストールする  
```bash
brew install ant
```
6. `NicoCache_nl-2026-01-15.7z` を避難所アップローダからダウンロードして展開  
```bash
# バージョンを指定 (YYYY-MM-DD形式)
NC_VERSION="2026-01-15"
TARGET_URL="https://nicocache.jpn.org/download.php?id=19&key=514e8a406c60c969adc4ff934d5e65427cdc09c74cab334e543f7c96f80b4d81"

cd "$NICOCACHE_HOME"
curl -L -o "NicoCache_nl-${NC_VERSION}.7z" "$TARGET_URL"
7z x "NicoCache_nl-${NC_VERSION}.7z" -o"$NICOCACHE_HOME" -y
NESTED_DIR="$NICOCACHE_HOME/NicoCache_nl"
if [ -d "$NESTED_DIR" ]; then
    mv "$NESTED_DIR"/* "$NICOCACHE_HOME/"
    rmdir "$NESTED_DIR"
fi
```
7. BouncyCastle から依存ライブラリをダウンロードし、証明書を生成する  

!!! warning
    genCerts.sh の実行フェーズで Enter キー操作が必要な場合があります。

    誤ってターミナルを閉じないように注意！

!!! note
    `genCerts.sh` が存在しない場合は `ant genCerts` コマンドで代替できます。

```bash
# バージョンを指定
BC_VERSION="1.83"
JDK_VERSION="18"

cd "$NICOCACHE_HOME/lib"
curl -o bcprov.jar "https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk${JDK_VERSION}on/${BC_VERSION}/bcprov-jdk${JDK_VERSION}on-${BC_VERSION}.jar"
curl -o bcutil.jar "https://repo1.maven.org/maven2/org/bouncycastle/bcutil-jdk${JDK_VERSION}on/${BC_VERSION}/bcutil-jdk${JDK_VERSION}on-${BC_VERSION}.jar"
curl -o bcpkix.jar "https://repo1.maven.org/maven2/org/bouncycastle/bcpkix-jdk${JDK_VERSION}on/${BC_VERSION}/bcpkix-jdk${JDK_VERSION}on-${BC_VERSION}.jar"
cd "$NICOCACHE_HOME"
chmod +x genCerts.sh
./genCerts.sh
cp "$NICOCACHE_HOME/config.properties.default" "$NICOCACHE_HOME/config.properties"
echo "enableMitM=true" >> "$NICOCACHE_HOME/config.properties"
```
8. 生成された CA 証明書を macOS のシステムキーチェーンに追加する  
```bash
sudo security add-trusted-cert -d -r trustRoot \
    -k /Library/Keychains/System.keychain \
    "$NICOCACHE_HOME/certs/ca.cer"
```
9. Firefox を開く  
10. 設定 > プライバシーとセキュリティ > 証明書 > 証明書を表示 > 認証局証明書 > インポート  
![Firefoxの証明書インポート](./images/firefox-certs.png)
11. `~/NicoCache_nl/certs/ca.cer` を選択  
12. 「この認証局によるウェブサイトの識別を信頼する」にチェックを入れる  
13. Firefox を再起動する  
14. `proxy_sample.pac` から `proxy.pac` を作成  
```bash
cp "$NICOCACHE_HOME/proxy_sample.pac" "$NICOCACHE_HOME/proxy.pac"
```
15. システムのネットワーク設定で自動プロキシスクリプトを設定する  
**GUI 操作:**  
システム設定 → ネットワーク → 使用中のネットワーク → 詳細 → プロキシ →  
「自動プロキシ設定」にチェックを入れ、URL に `http://localhost:8080/proxy.pac` を入力 → OK → 適用  
**コマンドラインで設定する場合（Wi-Fi の場合）:**  
```bash
NETWORK_SERVICE="Wi-Fi"
sudo networksetup -setautoproxyurl "$NETWORK_SERVICE" "http://localhost:8080/proxy.pac"
sudo networksetup -setautoproxystate "$NETWORK_SERVICE" on
```
16. その他、`config.properties` に変更したい設定があれば編集する。デフォルト設定は `defaults` ディレクトリに格納されている。  
17. ランチャースクリプトを作成する  
```bash
cat > "$NICOCACHE_HOME/run-nicocache.sh" << EOF
#!/bin/bash
cd "$NICOCACHE_HOME"
java -jar NicoCache_nl.jar &
EOF
chmod +x "$NICOCACHE_HOME/run-nicocache.sh"
```
18. `NicoCacheGUI.property` の設定を書き込む  
```bash
cat > "$NICOCACHE_HOME/NicoCacheGUI.property" << 'EOF'
HideWindow=true
LogWindowAlwaysOnTop=false
EOF
```
19. launchd エージェントとして登録してログイン時に自動起動させる  
```bash
mkdir -p ~/Library/LaunchAgents
cat > ~/Library/LaunchAgents/com.nicocache.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.nicocache</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$NICOCACHE_HOME/run-nicocache.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF
launchctl load ~/Library/LaunchAgents/com.nicocache.plist
launchctl start com.nicocache
```
20. NicoCache_nl が起動していることを確認する  
```bash
launchctl list | grep nicocache
```
21. インストール完了。アンインストール時は以下を実行する  
```bash
launchctl stop com.nicocache
launchctl unload ~/Library/LaunchAgents/com.nicocache.plist
rm -f ~/Library/LaunchAgents/com.nicocache.plist
rm -rf "$NICOCACHE_HOME"
sudo security delete-certificate -c "NicoCache_nl CA" /Library/Keychains/System.keychain
```
