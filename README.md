
# Table of Contents

1.  [Prologue](#orgb638b91)
2.  [Introduction](#org089fa5d)
3.  [System](#org1228ded)
4.  [Control](#orge58cb5c)
5.  [TODO-LIST](#org1fb147d)
6.  [DONE-LIST](#org44a7c4b)
7.  [REMOVED-LIST](#org29d94bf)
8.  [License](#org809042e)



<a id="orgb638b91"></a>

# Prologue

時は西暦2XXX年、世界は謎の生命体 "T-zero" に支配されていた。
長きに渡るT-zeroの支配によって世界の秩序は崩壊した。
あらゆる物理法則が通用しなくなり、あらゆるものが出来の悪い3Dモデルのような形に変化した。
そして、あれほど多彩だった色が、赤、青、緑、黄の4色だけになってしまった。
あなたは、この世界をT-zeroの支配から開放しようとするレジスタンスだ。
あなたの使命は"色"を駆使してT-zeroを殲滅し、世界に再び秩序をもたらすことだ。


<a id="org089fa5d"></a>

# Introduction

-   Colour(コロールと読む)はその名の通り"色"をテーマにした
    3DTPSゲームです。(パズルではなくなりました)
-   ColourはGauche(Scheme処理系), Gauche-gl(GaucheのOpenGL拡張)を必要とします。
-   コンピュータによっては挙動がおかしくなることがあります。config.scmの設定を適宜変更してください。
    それでも挙動が治らない場合はごめんなさい。


<a id="org1228ded"></a>

# System

-   以下の要素は製作者の妄想で、まだ実装されていない要素があります。ご了承ください。

---

-   ゲームクリアの条件はスポナーをすべて破壊すること、ゲームオーバーの条件は自身のライフが0になることです。
-   敵は一定時間ごとに、スポナーからスポーンします。スポナーは銃で破壊することができます。
-   数字ボタンで自機の色が変わります。自機の色はすなわち発射する弾の色です。
-   この世界には"補色"という概念が存在します。赤<=>緑、青<=>黄が対になっており(実際の補色とは異なります)、
    対の色同士が触れると大ダメージが発生します。
    敵を倒すときに敵と対の色の弾を発射すると、より効率的に敵を倒せるでしょう。
-   しかし、自機と対の色の敵に触れると大ダメージを負います。気をつけましょう。
-   反対に、同じ色同士が触れてもダメージは発生しません。
-   光の当たり方によっては、敵の色が見えないことがあります。そんなときは少し動き回って光の当たり方を調節しましょう。


<a id="orge58cb5c"></a>

# Control

-   A : 左回転
-   D : 右回転
-   W : 前進
-   S : 後退
-   1 : 赤色を選択
-   2 : 青色を選択
-   3 : 緑色を選択
-   4 : 黄色を選択
-   B : 選択した色の弾を発射
-   R : ゲームをリスタートする(ゲームクリアまたはゲームオーバー時限定)
-   ESC : ゲームを終了する


<a id="org1fb147d"></a>

# TODO-LIST

これから実装予定の機能です。


<a id="org44a7c4b"></a>

# DONE-LIST

すでに実装された機能です。

-   移動システムの改良(A, Dで角度を変えW, Sで前後進) -2021/6/7
-   TPS視点 -2021/6/8
-   三角関数テーブル(高速化のため) -2021/6/13
-   3Dモデルロードシステム -2021/6/16
-   自機モデル -2021/6/18
-   敵のモデル、移動システム -2021/6/22
-   効率的な敵の管理システム -2021/6/23
-   シューティング機能 -2021/6/23
-   リファクタリング(今はコードがごちゃごちゃしている) -2021/6/27
-   ダメージ -2021/6/27
-   スポナー -2021/7/14
-   構造物(壁) -2021/7/30
-   ゲームシステム(タイトル画面等) -2021/8/29


<a id="org29d94bf"></a>

# REMOVED-LIST

削除された、または実装を諦めた機能です。不甲斐ない作者をどうぞお許しください。

-   WASDによる移動 -移動システムの改良により削除
-   ライトの調整(今はとても暗い) -どうしてもわからなかった
-   テクスチャ -どうしてもわからなかった
-   ゲームサウンド - gauche-openalのドキュメントが見つからず断念


<a id="org809042e"></a>

# License

-   Colour is licensed under GPL v3 or later.
    See the COPYING file or [GNU-website](https://www.gnu.org/licenses).
-   README.md and artworks (\*.blend, \*.obj) are licensed under CC0,
    so you can do anything what you want to do.
    See [CC0-website](https://creativecommons.org/choose/zero/).

