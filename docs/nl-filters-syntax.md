# nlFiltersの文法
<div style="text-align: right;">最終更新日：2026/03/15</div>

---

nlFilters は、NicoCache_nl が取得したレスポンスやリクエストを条件に応じて書き換えるための定義ファイルである。ここでは「まず 1 本書けるようになること」を入口にしつつ、各オプションやコマンドを参照しやすい形で整理する。

## はじめに

最初に、定義ファイルは **UTF-8（BOM なし）** で保存し、先頭行に次の文字列を置く。文字コード判定に使われるため、この行は削除しない。

```text
# nlフィルタ定義(文字コード判定用なのでこの行は削除しないこと)
```

!!! tip
    最初の 1 本は `[Replace]` から始めるのがいちばん分かりやすく、安全だ。

## 最小構成

次の例が、もっとも基本的な nlFilter である。URL と Content-Type が一致したページの中から `動画` または `静画` を探し、`動画画` / `静画画` に置き換える。

```ini
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

この例で使っている要素は、nlFilters の基本そのものである。

| 項目 | 役割 |
|---|---|
| `[Replace]` | 通常の文字列置換を行うフィルタ種別 |
| `Name` | ログウィンドウに表示されるフィルタ名 |
| `URL` | 適用先 URL を正規表現で指定 |
| `ContentType` | 適用対象の Content-Type を制限 |
| `Match< ... >` | 検索対象の正規表現 |
| `Replace< ... >` | 置換後のテキスト |

## フィルタの種類

用途に応じて、セクションの先頭行を切り替える。

| 種類 | 用途 |
|---|---|
| `[Replace]` | 通常の置換フィルタ |
| `[Script]` | JavaScript を追加・挿入するフィルタ |
| `[Style]` | CSS を追加・挿入するフィルタ |
| `[RequestHeader]` | リクエストヘッダや URL を書き換えるフィルタ |
| `[Config]` | 他の処理から参照する設定値をまとめる用途 |

`[Replace]` の先頭に `#` を付けて `#[Replace]` と書くと、そのフィルタは無効になる。無効化したいときは行コメントではなく、この形にしておくと管理しやすい。

### Script

```ini
[Script]
Name = サンプルフィルタ
URL = (?:www|seiga)\.nicovideo\.jp
ContentType = text/html
Append<
console.log("Hello!");
>
```

### Style

```ini
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

### RequestHeader

`[RequestHeader]` はリクエストヘッダの置換用である。現在は URL の置換を主目的として使われることが多く、`/local/` 以下へのリダイレクトにも向いている。

## 基本フィールド

よく使うフィールドは次のとおりである。まずはこの表だけ押さえておけば、単純な置換フィルタはほぼ書ける。

| フィールド | 説明 |
|---|---|
| `Name` | フィルタ名を定義する。ログウィンドウにも表示される |
| `URL` | `https://` 以降を前方一致で検索する URL 条件 |
| `FullURL` | プロトコルを含めた URL 条件 |
| `ContentType` | 適用対象の Content-Type 条件 |
| `Match` | 置換対象を表す正規表現 |
| `Replace` | 置換後の文字列 |
| `Require` | ページ本文に対する追加条件 |
| `RequireHeader` | リクエストヘッダに対する追加条件 |

### Name

```ini
Name = 文字列置き換えフィルタ
```

### URL

`URL` は、プロトコル `https://` より後ろの部分に対して前方一致で評価される。

```ini
URL = www\.nicovideo\.jp/watch/
```

値の先頭に `POST/` を付けると、通常のレスポンスではなく POST データ側にフィルタを適用できる。

```ini
URL = POST/www\.nicovideo\.jp/watch/
```

### FullURL

通信プロトコルも含めて判定したい場合は `FullURL` を使う。

```ini
FullURL = https?://www\.nicovideo\.jp/watch/
```

### ContentType

`ContentType` は部分一致する正規表現で指定する。指定した場合、Content-Type が付いていないレスポンスにはマッチしない。

```ini
ContentType = text/(?:html|xml)
```

否定条件にしたいときは、先頭に `!` を付ける。

```ini
ContentType = !text/(?:html|xml)
```

### Match

`Match<` の次の行から、置換したい箇所を表す正規表現を書く。終了は `>` だけを書いた行である。

```ini
Match<
(正規表現)
>
```

`EachLine = FALSE` のときは、`Match` 内の改行は無視される。改行自体を対象にしたいなら `\s*` で吸収するか、`\r\n` を明示的に書く。

### Replace

`Replace<` の次の行から、置換後の文字列を書く。こちらも `>` だけの行で終了する。

```ini
Replace<
$1の置換後テキスト
>
```

`Match` 側で `( )` によるグループを使っていれば、`$1`、`$2` のように参照できる。マッチ全体は `$0` で参照できる。

### Require

`Require` は、ページ本文に追加条件を付けるためのフィールドである。通常の正規表現なら「それが本文に含まれているときだけ置換」、`!` 付きなら「それが含まれていないときだけ置換」になる。

OR 条件は `Require = !hoge1|hoge2|hoge3` のように書ける。AND 条件にしたい場合は、先読みアサーションを使って `Require = ^(?=[\s\S]*hoge1)[\s\S]*hoge2` のように表現する。

### RequireHeader

`RequireHeader` は `Require` のリクエストヘッダ版である。User-Agent や `user_session` を条件にできるため、ユーザーごとにフィルタを切り替えたいときに便利である。

```ini
RequireHeader = user_session_12345678_\d+
```

## 動作オプション

このあたりは「同じ置換を何回行うか」「1 行ごとに扱うか」といった挙動を決める設定である。

| オプション | 役割 |
|---|---|
| `Multi` | 最初の 1 件だけか、すべて置換するか |
| `EachLine` | `Match` と `Replace` を 1 行ずつ対応付けるか |
| `MatchLocal` | `/local/` 以下も URL 条件に含めるか |
| `AddList` | `Replace` の内容を LST ファイルへ追加する |
| `AddVariable` | `Replace` の内容を URL 固有変数として保存する |

### Multi

`TRUE` にすると、ページ内で見つかったすべてを置換する。`FALSE` または省略時は、最初に見つかった 1 件だけが対象である。

```ini
Multi = TRUE
```

### EachLine

`EachLine = TRUE` にすると、`Match` と `Replace` の各行が 1 組ずつ対応する。ひとつのフィルタで複数種類の置換をまとめたいときに有効である。

```ini
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

この例では、「ニコニコ動画」は「NICONICO VIDEO」に、「ニコニコ生放送」は「ニコ生」に変化する。

`FALSE` または省略時は、改行されていても `Match` と `Replace` 全体をひとまとまりとして扱う。その場合、`Replace` 内の改行はそのまま反映される。

### MatchLocal

`URL = www\.nicovideo\.jp/` のように書いたとき、`MatchLocal = TRUE` を指定すると `/local/` 以下にもマッチするようになる。省略または `FALSE` の既存フィルタは `/local/` にマッチしない。

```ini
MatchLocal = TRUE
```

なお、`URL = www\.nicovideo\.jp/local/` のように `/local/` まで直接書いた場合は、`MatchLocal` の値に関わらず常にマッチする。

### AddList

`Replace` の内容を LST ファイルに追加する。このオプションを使った場合、コンテンツ本体は書き換えない。

```ini
AddList = list/NGUserId.txt
```

### AddVariable

`Replace` の内容を URL 固有の変数に保存し、他のフィルタから `<nlVar:foo>` のように参照できる。同じ変数名に対して複数回追加すると、文字列は連結される。

```ini
AddVariable = foo
```

## idGroup

`idGroup` は、キャッシュが存在したときだけ置換するフィルタで使う。動画 ID (`sm...`) やサムネイル ID の参照番号をカンマ区切りで指定し、キャッシュがあれば置換が実行される。

```ini
idGroup = 1,2
```

`Replace` の中にセパレータとして `<$>` を入れると、通常キャッシュ用とエコノミーキャッシュ用で置換パターンを分けられる。`<$>` より前が通常キャッシュ、後ろがエコノミーキャッシュである。改行の有無は問わず、`EachLine` と組み合わせることもできる。`<$>` が無ければ、通常とエコノミーで同じ置換になる。

ID を 2 つ指定する書き方は、チャンネル動画のように数字のみ 10 桁の動画 ID をサムネイル ID から検索して表示するためによく使われる。リンクの色替えなど、ID が 1 つで足りる場面では 1 つだけ指定してもかまわない。

文字列の途中に埋め込むこともできる。

```ini
Replace<
$0<div style="position:relative;">
<img src="https://www.nicovideo.jp/local/cache<icon$economy>.gif" ～>
</div>
>
```

`$` の左右に `\w+` が存在した場合は、`<>` の前後と連結される。片方が空白文字でも有効だが、`\w` 以外の文字があると認識されない。また、同一の `Replace` 中に複数の記述はできない。

動画 ID が無く、サムネイル ID だけを使いたい場合は、`idGroup` の 1 つ目を埋めるダミーとして `Match` に `(\w{2}\d+)?` を入れる方法がある。ただし、このダミーは前方に置くほど処理が遅くなりやすいため、できるだけ後ろに置くのが無難である。

## Config

`[Config]` で設定したパラメータは、EasyRewriter 内の次のメソッドから読み出せる。

```java
public static JavaPattern[] getMatch(String name)
public static String[] getReplace(String name)
public static Pattern getURL(String name)
```

`name` はフィルタ名で、対応するフィルタが無いときは `null` を返す。

```java
JavaPattern[] pattern = EasyRewriter.getMatch("movieCommentMatch");
if (pattern != null) {
    JavaMatcher matcher = pattern[0].matcher(content);
}
```

`EachLine;` を使用した場合は、1 行目から順に `pattern[0]` 以降に対応する。使用していない場合は `pattern[0]` のみである。Extension 側で読む形にしておけば、フィルタを差し替えるだけで仕様変更に追従しやすくなる。

## Debug

フィルタ定義の外に `[Debug]` とだけ書いた行を置くと、処理した URL、マッチしたフィルタ名、実際に置換したかどうかがログに表示される。デフォルトのフィルタまで大量に表示されるため、調べたいフィルタだけを残して確認すると追いやすくなる。

## コマンド

`Match` や関連フィールドの中では、いくつかの専用コマンドを利用できる。

### `$NEST`

ネストしたタグにマッチするコマンドである。開始タグと終了タグには、前方参照 `( )` を含まない正規表現を使う。コンテンツマッチ条件には、開始タグと終了タグを除いた部分に対する「部分一致」の正規表現を使う。

オミトロンと異なり、範囲として採用されるのは最も内側のタグである。`$NEST` は単体でしか書けない。また、`(9).10` からはコンテンツマッチ条件内のグループへの前方参照も可能になっている。

```ini
$NEST(開始タグ,コンテンツマッチ条件,終了タグ)
```

```ini
例：$NEST(<script ,web_pc_top_bottom,</script>)
```

### `$LST`

`""` で囲んだファイルを読み込み、中身を行単位で `|` で連結したうえで `()` にグループ化して返す。`""` は必須である。グループ化されるので、前方参照は自動的に 1 つ増える。

通常はファイル内容が自動でエスケープされるが、`$LST("!ファイル名")` のように `!` を付けると、エスケープせず正規表現として扱われる。`!` で始まるファイル名は使えない。

`#start` とだけ書かれた行以降がリストとして読み込まれ、それ以前の部分と空行は無視される。先頭行が `# nlフィルタ定義` で始まっていれば、文字コードは自動判定される。リストは動的更新に対応しており、更新されると自動的に再読み込みされる。

空の `$LST` がひとつでも含まれている場合、置換処理はスキップされる。このとき内部的には `(?!)` に置換される。`Match` だけでなく、`Require` のような正規表現が書ける場所でも使用可能である。

```ini
$LST("!local/ngword.txt")
```

```text
local/ngword.txt:
# nlフィルタ定義(文字コード判定用なのでこの行は削除しないこと)
#start
(?:ニ[コフ]){2}動画
fz\d+
so\d+
```

### `$INC`

nlFilter でマッチした回数を参照できるコマンドである。`Match` 内に `$INC(NGCount)` と書くと、`Replace` 側では `<nlVar:NGCount>` として参照できる。

変数は、マッチするたびにインクリメントされる。変数が存在しない場合は 0 で初期化されたあとに増加し、すでに存在していて数値として評価できない場合はエラーになる。`$INC` 自体は取り除かれてからマッチングされるため、`Match` 内の任意の位置に置ける。

### `$SET`

マッチしたタイミングで変数を設定する。

```ini
$SET(name=value)
```

現状は、オミトロンと違って `value` 部分に固定値しか書けない。

### `$TS`

`[Replace]` フィルタでのみ有効である。引数に NicoCache フォルダからの相対パスを渡すと、ファイル更新時刻文字列（`?` + UNIXTIME）を付加して置換する。

```text
$TS(local/popThumb.js) → local/popThumb.js?1298081651
$TS(local/nicoplayer.swf?ts=) → local/nicoplayer.swf?ts=1239336522
```

指定したローカルファイルが存在しない場合は、引数そのものに置換される。

```text
$TS(local/nonexistent.json) → local/nonexistent.json
```

引数なしなら、現在時刻の UNIXTIME に置換される。

```text
var replacedTime = "$TS()"; → var replacedTime = "1306132319";
```

### `$URL`

`URL` 側で使った `()` グループを `Replace` から参照するための仕組みである。たとえば `URL = www\.nicovideo\.jp/mylist/(\d+)` となっていれば、`Replace` 内で `$URL1` を使って `(\d+)` の部分を参照できる。URL 全体は `$URL0` で参照できる。

## 変数

以下の変数は、`Replace` 内で使うと置換時に実値へ展開される。

| 変数 | 説明 |
|---|---|
| `<id>` | watch ページで使える。`sm～` や `nm～` の数字部分に置換 |
| `<smid>` | watch ページで使える。`sm～` や `nm～` 全体に置換 |
| `<memoryId>` | watch ページで使える。マイメモリーでは ID、通常再生では動画 ID に置換 |
| `<freeSpace>` | `https://www.nicovideo.jp` 内で使える。キャッシュドライブ空き容量に置換 |
| `<eachSmid>` | `idGroup` 指定時のみ有効。`sm～` 形式の ID に置換 |
| `<CRLF>` | 改行コードに置換。`EachLine = TRUE` 時の改行にも使える |
| `<nlVar:config!name>` | `config.properties` の値を参照 |
| `<nlVar:VERSION>` | バージョン文字列に置換 |

`<freeSpace>` は `NicoCache_nl+101219mod` 以降、常に使用可能である。

### `<nlVar:config!name>`

`nlFilter` から `config.properties` の値を参照できる。`Replace` に `<nlVar:config!name>` と書くと、config の `name` に対応する値が展開される。

`$SET` と組み合わせれば、nlFilter にデフォルト値を書いておき、`config.properties` 側に値があればそちらを優先する、という構成も可能である。ただし `$SET` を書かないと、config に値が存在しない場合は置換処理そのものが行われない。

```ini
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

## コメント

`#` が先頭にある行はコメントとして扱われ、その行はフィルタに反映されない。

---

## フィルタサンプル

長めの例は折りたたみでまとめている。必要なものだけ開いて確認するとよい。

??? example "普通のフィルタ"
    プレミアム未登録などの記述を消す例。

    ```ini
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

??? example "EachLine 付きのフィルタ"
    「最近見た動画」を「最近見た気がする動画」に、「ニコニコ」を「にこニコ」に置換する例。

    ```ini
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

??? example "$NEST の使用例"
    watch の「ニコニコ市場とは・・・」の説明文を消す例。

    ```ini
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

??? example "[RequestHeader] の使用例"
    旧プレイヤーへのアクセスを `/local/oldplayer/` 以下にリダイレクトさせる例。

    ```ini
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
