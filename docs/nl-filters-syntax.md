# nlFiltersの文法
<div style="text-align: right;">最終更新日：2026/03/14</div>
---

## 定義行
- UTF-8(BOMなし)で保存して行頭に以下の文字列を追加する
```
# nlフィルタ定義(文字コード判定用なのでこの行は削除しないこと)
```

## 書式
- 簡単なフィルタの例 
```
[Replace]
Name = サンプルフィルタ
URL = (?:www|seiga)\.nicovideo\.jp
ContentType = text/html
Match<
(動|静)画
>
Replace<
$1$1画
>
```
- 解説
- フィルタの種類 (通常の置き換え)
```
[Replace]
```
- フィルタの名前を定義
```
Name = サンプルフィルタ
```
- フィルタの適用先 URL (正規表現、"http://" の部分を除いた前方一致)
```
URL = (?:www|seiga)\.nicovideo\.jp
```
- フィルタを適用するコンテンツタイプ (今回は HTML ドキュメントのみに適用)
```
ContentType = text/html
```
- 検索テキストを指定 (正規表現利用可能、"Match<" 〜 ">" まで)
```
Match<
(動|静)画
>
```
- 置き換えテキストを指定 ( $1 〜 $9 でグループの参照が可能、"$" のものを含めたい場合は "\$" とする)
```
Replace<
$1$1画
>
```

## Replace
- 置換タイプの通常フィルタ
- 先頭に # をつける、つまり "[Replace]" を "#[Replace]" にすると、そのフィルタは無効になる。

## Script
- Javascript用のフィルタ
```
[Script]
Name = サンプルフィルタ
URL = (?:www|seiga)\.nicovideo\.jp
ContentType = text/html
Append<
console.log("Hello!");
>
```

## Style
- CSS用のフィルタ
```
[Style]
Name = サンプルフィルタ
URL = (?:www|seiga)\.nicovideo\.jp
ContentType = text/html
Append<
body {
    background-color: red;
}
>
```

## RequestHeader
- リクエストヘッダーの置換用。現在はURLの置換のみが可能なようだ
- 主に /local 以下のファイルへのリダイレクトに使用

## Debug
- フィルタ定義の外に " [Debug] " とだけ書いた行を置いておくと、処理した URL・マッチしたフィルタ名・置換を行ったかどうかがログに表示される
- そのままだと、デフォルトのフィルタが多数表示されるので、調べたいフィルタだけにすると楽

## Config
- " [Config] " で設定したパラメータは、EasyRewriter 内の以下のメソッドで読み出せる
```java
public static JavaPattern[] getMatch(String name)
public static String[] getReplace(String name)
public static Pattern getURL(String name)
```
- name はフィルタ名、対応するフィルタが無い時は null を返す。使い方としては以下
```java
JavaPattern[] pattern = EasyRewriter.getMatch("movieCommentMatch");
if (pattern != null) {
	JavaMatcher matcher = pattern[0].matcher(content);
}
```
- EachLine; を使用した場合は、1 行目から順に pattern[0] 〜 に対応し、使用していない場合は pattern[0] となる
- Extension などで読むようにしておくと、フィルタに設定するだけで仕様変更に対応できるかも…? 

## Name
- フィルタの名前を定義する。ログウィンドウに表示される
```
Name = 文字列置き換えフィルタ
```

## URL
- フィルタを適用するURLはプロトコル"https://"以降から前方一致で検索する
```
URL = www\.nicovideo\.jp/watch/
```
- URL フィールドの値の先頭に POST/ を付けると、通常とは逆に POST するデータに対してフィルタを適用可能
```
URL = POST/www\.nicovideo\.jp/watch/
```

## FullURL
- 通信プロトコルも含めてマッチするURLを指定
```
FullURL = https?://www\.nicovideo\.jp/watch/
```

## Multi
- "Multi = TRUE;" とすると、ページ内で見つかった物すべてを置換 (グローバルマッチ) する
- "Multi = FALSE;" とするかまたは省略すると、最初に見つかった物だけを置換する
```
Multi = TRUE
```

## EachLine
- "EachLine = TRUE;"とすると、"Match;" と "Replace;" の一行ずつを一組として、それぞれ置換を行う。ひとつのフィルタで複数種類の置換を行う時に使用する
- EachLine = FALSE;" とするかまたは省略すれば、"Match;" と "Replace;" が改行してあっても一組として動作する。そのとき "Replace" 内の改行は無視されず、そのまま改行として反映される。
```
EachLine = TRUE
Match<
ニコニコ動画
ニコニコ生放送
>
Replace<
NICONICO VIDEO
ニコ生
>
```
- 上記の例では「ニコニコ動画」は「NICONICO VIDEO」に、「ニコニコ生放送」は「ニコ生」に変化する


## Require
- Require = 正規表現 で指定した正規表現が含まれる場合に置換を行う
- Require = !正規表現で指定した正規表現が含まれない場合に置換を行う
- つまり、通常の正規表現を書けば、それがページ中でマッチした場合のみ置換される
- 先頭に "!" をつけると、 "!" を除いた部分にマッチしなかった時のみ置換される
- 複数の条件をORで指定する場合、Require = !hoge1|hoge2|hoge3|....になる。（hoge1,hoge2,hoge3は正規表現）
- ANDで指定する場合、先読みアサーションでRequire = ^(?=[\s\S]*hoge1)[\s\S]*hoge2のように指定する


## idGroup
- キャッシュが存在した時のみ置換するフィルタ
- ID取得用に、idGroupに動画ID(sm～)、サムネID(数字部分のみ)への参照番号を "," 区切りで指定
- "idGroup = 1,2" とすれば、 $1, $2が参照され、キャッシュがあれば置換される

- また、 "Replace" 中にセパレータとして "<$>" を入れる事で、キャッシュが通常/エコノミーで "Replace" のパターンを変えることが出来る
- "<$>" 以前が通常キャッシュ用、以後がエコノミーキャッシュ用となる
- 改行は入れなくても良いし、EachLineで使用することも出来る
- "<$>" が無いときは通常/エコノミーで同じ置換が行われる

- IDを2つ指定しているのは、チャンネルで数字のみ10桁の動画IDの時、サムネIDから検索して表示するため
- リンクの色変えなどでIDが1つしかない時は、1つだけ指定することも可能

- 以下のように文字列中に埋め込む事も可能
```
Replace<
$0<div style="position:relative;">
<img src="https://www.nicovideo.jp/local/cache<icon$economy>.gif" ～>
</div>
>
```
- $の左右に\w+が存在した場合は<>前後の文字列と連結する
- 片方が空白文字の場合も有効、\w以外の文字があると認識しない
- また、同一Replace中に複数の記述はできない
- 動画IDが無くてサムネIDだけしか使えない場合、idGroupの1つめのID（動画ID）用のダミーとしてMatchに"(\w{2}\d+)?"を入れる
- ダミーの"(\w{2}\d+)?"を入れる場合、Matchの最初の方へ入れると処理が遅くなるため、できるだけ最後の方へ入れると良い

## Match
- 置換したい場所を正規表現で書く
- `Match<` の次の行から、ページ内の置換元になる正規表現を書く
- `EachLine = FALSE` の時は、改行は無視されるので注意
- 改行にマッチさせるには `\s*` で吸収するか、`\r\n` を明示的に指定する必要がある
- 置換元の記述は、`>` とだけ書かれた行で終了する
```
Match<
(正規表現)
>
```

## Replace
- 置換後の文章を書く
- `Replace<` の次の行から、置換先の文章を書く
- `Match` 内で `( )` を使用していれば、`Replace` で `$1`、`$2` のように参照できる
- `$0` を指定すると、`Match` でマッチした部分すべてを参照できる
- `Match` と同じく、`>` とだけ書かれた行で終了する
```
Replace<
$1の置換後テキスト
>
```

## RequireHeader
- 特定のUser-Agentやuser_sessionに限定できる（`Require`のリクエストヘッダ版）
- 上手く記述すればログインユーザー毎にnlFilterを切り換えることができる
```
RequireHeader = user_session_12345678_\d+
```

## ContentType
- 特定のContent-Typeに限定できる（部分一致する正規表現を記述）
```
ContentType = text/(?:html|xml)
```
- 指定した場合、Content-Typeが無いレスポンスにはマッチしなくなるので注意
- 行頭に `!` をつけると否定条件になる
```
ContentType = !text/(?:html|xml)
```

## MatchLocal
- `URL = www\.nicovideo\.jp/` と記述した場合に、`MatchLocal = TRUE` にすると `/local/` 以下にもマッチするようになる（`FALSE` ならマッチしない）
- `MatchLocalオプション` の記述が無い既存フィルタはマッチしない
- `URL = www\.nicovideo\.jp/local/` のように `/local/` 以下まで直接記述した場合は、`MatchLocal` の値に関わらず常にマッチする
```
MatchLocal = TRUE
```

## AddList
- nlFilterからLSTファイルにReplaceの内容を追加できる（動作仕様はAPIと同じ）
- このオプションを指定した場合、コンテンツの内容は書き換えない
```
AddList = list/NGUserId.txt
```

## AddVariable
- URL固有の変数にReplaceの内容を保存して、他のフィルタから参照できる
- 同じ変数に対して複数追加する場合は文字列が連結される
- 他のフィルタから参照するには `Replace` に `<nlVar:foo>` と書く
- このオプションを指定した場合、コンテンツの内容は書き換えない
```
AddVariable = foo
```

## コマンド

### $NEST
- ネストしたタグにマッチするコマンド
- 開始タグ、終了タグは前方参照 `( )` を含まない正規表現を使う
- コンテンツマッチ条件は開始タグと終了タグを除く部分に「部分マッチ」する正規表現を使う
- オミトロンと違い、マッチする最も「内側の」タグが範囲となる
- `$NEST` は単体でしか書けない
- `(9).10` から、コンテンツマッチ条件内のグループへの前方参照ができるようになった
```
$NEST(開始タグ,コンテンツマッチ条件,終了タグ)
```
```
例：$NEST(<script ,web_pc_top_bottom,</script>)
```

### $LST
- `""` に囲まれたファイルを読み込んで、中身を行単位で `|` でつないだ物を `()` でグループ化して返す
- `""` は必須。`()` でグループ化するので、自動的に前方参照が一つ追加される
- デフォルトでファイルの内容はエスケープされる。`$LST("!ファイル名")` のように `!` をつけることで、エスケープせずに正規表現として渡せる（`!` で始まる名前のファイルは使用不可）
- `#start` とのみ書かれた行以降がリストとして読み込まれ、それ以前の部分・改行のみの行は無視される
- リストの先頭行が `# nlフィルタ定義` で始まっていれば自動的に文字コードを判定する
- リストは動的更新が可能で、更新されたときは自動的に読み込まれる
- 一つでも空の `$LST` が含まれる場合は置換処理をスキップする（空の時は `(?!)` に置換される）
- `Match` 以外の正規表現が記述できる場所（`Require` など）でも使用可能
```
$LST("!local/ngword.txt")
```
```
local/ngword.txt:
# nlフィルタ定義(文字コード判定用なのでこの行は削除しないこと)
#start
(?:ニ[コフ]){2}動画
fz\d+
so\d+
```

### $INC
- nlFilterでマッチした回数を参照できる
- `Match` 内に `$INC(NGCount)` と書くと `Replace` で `<nlVar:NGCount>` として参照できる
- `$INC` はマッチした場合に指定した変数の値をインクリメントする
- 変数が存在しない場合は0で初期化してからインクリメントする
- 変数が既に存在してかつ数値として評価できない場合はエラーになる
- `$INC` 自体は除去してからマッチングを行うので `Match` 内の任意の位置に記述できる

### $SET
- nlFilterでマッチした時に変数を設定できる
- `Match` 内に `$SET(name=value)` と書くとマッチした時に変数に値を設定できる
- 現状、オミトロンと異なり `value` 部分は固定値しか書くことができない

### $TS
- `[Replace]` フィルタのみ有効
- 引数にローカルファイル（NicoCacheフォルダからの相対パス）を指定すると、引数にファイル更新時刻文字列（`'?'+UNIXTIME`）を付加して置換する
```
$TS(local/popThumb.js) → local/popThumb.js?1298081651
$TS(local/nicoplayer.swf?ts=) → local/nicoplayer.swf?ts=1239336522
```
- 引数のローカルファイルが存在しない場合、引数そのものに置換する
```
$TS(local/nonexistent.json) → local/nonexistent.json
```
- 引数を指定しない場合、現在時刻文字列（UNIXTIME）に置換する
```
var replacedTime = "$TS()"; → var replacedTime = "1306132319";
```

### $URL
- `Match` 内で使用する `()` グループ化のURL版
- `URL = www\.nicovideo\.jp/mylist/(\d+)` となっていると、`Replace` 内で `$URL1` を使うことで `(\d+)` の部分を参照できる
- `$URL0` でURLにマッチした全体を参照できる

## 変数

`Replace` 内で使用すると、置換時に各変数の値に置き換えられる。

### `<id>`
- watchページで使用可
- `sm～`、`nm～` などの `～`（数字部分）に置換される

### `<smid>`
- watchページで使用可
- `sm～`、`nm～` などに置換される

### `<memoryId>`
- watchページで使用可
- マイメモリーでは `0123456789` のようなマイメモリーIDに、通常再生では `sm～` などの動画IDに置換される

### `<freeSpace>`
- `https://www.nicovideo.jp` 内で使用可
- `12.34`（GB単位）のようなキャッシュドライブの空き容量に置換される
- `NicoCache_nl+101219mod` 以降はいつでも使用可能

### `<eachSmid>`
- `idGroup` を指定したときのみ有効
- `sm～` 形式のIDに置換される

### `<CRLF>`
- `Replace` で使うと改行コードに置換する
- `EachLine = TRUE` の時でも改行できるようになる

### `<nlVar:config!name>`
- `nlFilter` で `config.properties` の値を参照できる
- `Replace` に `<nlVar:config!name>` と書くと config の `name` という値を参照できる
- `$SET` と組み合わせることで、nlFilter にあらかじめデフォルト値を書いておき、`config.properties` に値がある場合はそちらを優先するという使い方ができる
- `$SET` を書かないと config に値が存在しない場合は置換処理されないので注意
```
Match<
$SET(config!nlFilterA.useFunction=false)
</head>
>
Replace<
<script type="text/javascript"><!--
var nlFilterA = { useFunction: <nlVar:config!nlFilterA.useFunction> };
//--></script>
</head>
>
```

### `<nlVar:VERSION>`
- `Replace` で使うとバージョン文字列に置換する

## コメント

### `#`
- `#` が先頭に使われている行はコメント行となり、その行はフィルタに反映されない

---

## フィルタサンプル

### 普通のフィルタ
プレミアム未登録などの記述を消す例。
```
[Replace]
Name = Test Filter (Remove Payment Status)
URL = www.nicovideo.jp
Multi = FALSE
Match<
：<strong>\s*<a[^>]+>プレミアム(?:未登録|\(月額\))</a>\s*</strong>\s*です
>
Replace<
>
```

### EachLine付きのフィルタ
「最近見た動画」を「最近見た気がする動画」に、「ニコニコ」を「にこニコ」に置換する例。
```
[Replace]
Name = Test Filter (EachLineつき)
URL = www.nicovideo.jp/mylist
EachLine = TRUE
Multi = TRUE
Match<
(最近見た)(動画)
ニコ(ニコ)
>
Replace<
$1気がする$2
にこ$1
>
```

### $NEST使用
watchの「ニコニコ市場とは・・・」の説明文を消す例。
```
[Replace]
Name = Delete Ichiba Description
URL = www.nicovideo.jp/watch/
Multi = FALSE
Match<
$NEST(<table ,ニコニコ市場とは,</table>)
>
Replace<
>
```

### [RequestHeader]の使用例
旧プレイヤーへのアクセスを `/local/oldplayer/` 以下にリダイレクトさせる例。
```
[RequestHeader]
Name = Redirect Old Player
URL = www\.dummy\.com
EachLine = True
Match<
http://([^/]+)/swf/nicoplayer\.swf(\?.*)?
http://([^/]+)/swf/marqueeplayer\.swf(\?.*)?
http://([^/]+)/swf/flv_bgmplayer\.swf(\?.*)?
http://([^/]+)/swf/swf_bgmplayer\.swf(\?.*)?
http://([^/]+)/swf/hirobaplayer\.swf(\?.*)?
http://([^/]+)/swf/hirobamovie\.swf(\?.*)?
>
Replace<
http://$1/local/oldplayer/nicoplayer.swf
http://$1/local/oldplayer/marqueeplayer.swf
http://$1/local/oldplayer/flv_bgmplayer.swf
http://$1/local/oldplayer/swf_bgmplayer.swf
http://$1/local/oldplayer/hirobaplayer.swf
http://$1/local/oldplayer/hirobamovie.swf
>
```