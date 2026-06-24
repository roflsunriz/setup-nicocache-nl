# NicoCache_nl のインストール(Solaris)
!!! note "対象バージョン"
    **Oracle Solaris 11.4** を対象としています。  
    パッケージ管理は IPS (`pkg`) をシステム系に、サードパーティパッケージは **OpenCSW** (`pkgutil`) を使用します。  
    デフォルトシェルは **bash** を前提としています。

1. ターミナルを開く（GNOME ターミナル または `dtterm`）  
2. OpenCSW をセットアップし、FFmpeg・p7zip をインストールする  
```bash
# OpenCSW ブートストラップ（初回のみ）
sudo pkgadd -d http://get.opencsw.org/now

# パッケージ一覧を更新してインストール
sudo /opt/csw/bin/pkgutil -U
sudo /opt/csw/bin/pkgutil -y -i ffmpeg p7zip wget
```
3. OpenJDK 17 をインストールする  
```bash
# Solaris 11.4 の IPS リポジトリからインストール
sudo pkg install runtime/java/openjdk-17
```

!!! note
    IPS リポジトリに `openjdk-17` がない場合は [Oracle JDK ダウンロードページ](https://www.oracle.com/java/technologies/downloads/) から Solaris 版 JDK 17 を取得してください。

4. ホームディレクトリに `NicoCache_nl` ディレクトリを作成し、環境変数 `NICOCACHE_HOME` を設定する  
```bash
NC_DIR="$HOME/NicoCache_nl"
mkdir -p "$NC_DIR"
echo "export NICOCACHE_HOME=\"$NC_DIR\"" >> ~/.profile
. ~/.profile
```
5. Apache Ant をダウンロードし展開して `~/ant` に配置する  
```bash
# バージョンを指定
ANT_VERSION="1.10.17"
ANT_DIR="$HOME/ant"

cd /tmp
/opt/csw/bin/wget "https://dlcdn.apache.org//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz"
gtar -xzf "apache-ant-${ANT_VERSION}-bin.tar.gz"
mv "apache-ant-${ANT_VERSION}" "$ANT_DIR"
```

!!! note
    Solaris 標準の `tar` は GNU tar オプション (`-z`) に非対応の場合があります。`gtar` が使えない場合は先に `sudo pkg install archiver/gnu-tar` でインストールしてください。

6. 環境変数 `ANT_HOME` と `PATH` に Ant を登録する  
```bash
echo "export ANT_HOME=\"$HOME/ant\"" >> ~/.profile
echo 'export PATH="$ANT_HOME/bin:/opt/csw/bin:$PATH"' >> ~/.profile
. ~/.profile
```
7. `NicoCache_nl-2026-01-15.7z` を避難所アップローダからダウンロードして展開  
```bash
# バージョンを指定 (YYYY-MM-DD形式)
NC_VERSION="2026-06-13"
TARGET_URL="https://nicocache.jpn.org/api/files/21/download"

cd "$NICOCACHE_HOME"
/opt/csw/bin/wget -O "NicoCache_nl-${NC_VERSION}.7z" "$TARGET_URL"
7z x "NicoCache_nl-${NC_VERSION}.7z" -o"$NICOCACHE_HOME" -y
NESTED_DIR="$NICOCACHE_HOME/NicoCache_nl"
if [ -d "$NESTED_DIR" ]; then
    mv "$NESTED_DIR"/* "$NICOCACHE_HOME/"
    rmdir "$NESTED_DIR"
fi
```
8. BouncyCastle から依存ライブラリをダウンロードし、証明書を生成する  

!!! warning
    genCerts.sh の実行フェーズで Enter キー操作が必要な場合があります。

    誤ってターミナルを閉じないように注意！

!!! note
    `genCerts.sh` が存在しない場合は `ant genCerts` コマンドで代替できます。

```bash
# バージョンを指定
BC_VERSION="1.84"
JDK_VERSION="18"

cd "$NICOCACHE_HOME/lib"
/opt/csw/bin/wget "https://repo1.maven.org/maven2/org/bouncycastle/bcprov-jdk${JDK_VERSION}on/${BC_VERSION}/bcprov-jdk${JDK_VERSION}on-${BC_VERSION}.jar" -O bcprov.jar
/opt/csw/bin/wget "https://repo1.maven.org/maven2/org/bouncycastle/bcutil-jdk${JDK_VERSION}on/${BC_VERSION}/bcutil-jdk${JDK_VERSION}on-${BC_VERSION}.jar" -O bcutil.jar
/opt/csw/bin/wget "https://repo1.maven.org/maven2/org/bouncycastle/bcpkix-jdk${JDK_VERSION}on/${BC_VERSION}/bcpkix-jdk${JDK_VERSION}on-${BC_VERSION}.jar" -O bcpkix.jar
cd "$NICOCACHE_HOME"
chmod +x genCerts.sh
./genCerts.sh
cp "$NICOCACHE_HOME/config.properties.default" "$NICOCACHE_HOME/config.properties"
echo "enableMitM=true" >> "$NICOCACHE_HOME/config.properties"
```
9. 生成された CA 証明書をシステムの証明書ストアに追加する  
```bash
sudo cp "$NICOCACHE_HOME/certs/ca.cer" /etc/certs/CA/nicocache-nl.pem
sudo svcadm restart /system/ca-certificates
```
10. `proxy_sample.pac` から `proxy.pac` を作成  
```bash
cp "$NICOCACHE_HOME/proxy_sample.pac" "$NICOCACHE_HOME/proxy.pac"
```
11. システムのプロキシ設定で自動プロキシスクリプトを `http://localhost:8080/proxy.pac` に設定する  
**GNOME デスクトップ:**  
```bash
gsettings set org.gnome.system.proxy mode 'auto'
gsettings set org.gnome.system.proxy autoconfig-url 'http://localhost:8080/proxy.pac'
```
**システム全体 (`/etc/default/proxy`):**  
```bash
sudo sh -c 'echo "AUTOMOUNT_PROXY=http://localhost:8080/proxy.pac" >> /etc/default/proxy'
```
12. その他、`config.properties` に変更したい設定があれば編集する。デフォルト設定は `defaults` ディレクトリに格納されている。  
13. ランチャースクリプトを作成する  
```bash
cat > "$NICOCACHE_HOME/run-nicocache.sh" << EOF
#!/bin/bash
cd "$NICOCACHE_HOME"
java -jar NicoCache_nl.jar &
EOF
chmod +x "$NICOCACHE_HOME/run-nicocache.sh"
```
14. `NicoCacheGUI.property` の設定を書き込む  
```bash
cat > "$NICOCACHE_HOME/NicoCacheGUI.property" << 'EOF'
HideWindow=true
LogWindowAlwaysOnTop=false
EOF
```
15. SMF (Service Management Facility) サービスとして登録してログイン時に自動起動させる  
```bash
# SMF マニフェストを作成
cat > /tmp/nicocache.xml << EOF
<?xml version="1.0"?>
<!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">
<service_bundle type='manifest' name='nicocache'>
  <service name='application/nicocache' type='service' version='1'>
    <instance name='default' enabled='false'/>
    <exec_method type='method' name='start'
      exec='/bin/bash $NICOCACHE_HOME/run-nicocache.sh'
      timeout_seconds='60'>
      <method_context>
        <method_credential user='$USER'/>
      </method_context>
    </exec_method>
    <exec_method type='method' name='stop'
      exec=':kill'
      timeout_seconds='60'/>
    <property_group name='startd' type='framework'>
      <propval name='duration' type='astring' value='transient'/>
    </property_group>
    <stability value='Unstable'/>
    <template>
      <common_name>
        <loctext xml:lang='C'>NicoCache_nl Proxy</loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
EOF

sudo svccfg import /tmp/nicocache.xml
sudo svcadm enable application/nicocache:default
```
16. NicoCache_nl が起動していることを確認する  
```bash
svcs application/nicocache
```
17. インストール完了。アンインストール時は以下を実行する  
```bash
sudo svcadm disable application/nicocache:default
sudo svccfg delete application/nicocache
rm -rf "$NICOCACHE_HOME"
sudo rm -f /etc/certs/CA/nicocache-nl.pem
sudo svcadm restart /system/ca-certificates
```
