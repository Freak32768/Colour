
# Table of Contents

1.  [Introduction](#org382bb53)
2.  [System](#orgdb8eedd)
3.  [TODO-LIST](#orgc407d1e)
4.  [DONE-LIST](#org2eed224)
5.  [License](#org4fd49f8)



<a id="org382bb53"></a>

# Introduction

-   Colour(コロールと読む)はその名の通り"色"をテーマにした
    3DパズルTPSゲームです。(パズルかどうかは微妙です。)
-   ColourはGauche(Scheme処理系), Gauche-gl(GaucheのOpenGL拡張)を必要とします。


<a id="orgdb8eedd"></a>

# System

-   ADで左右に方向回転、WSで移動です。
-   Vで弾を選択し、Bで弾を発射します。


<a id="orgc407d1e"></a>

# TODO-LIST

これから実装予定の機能です。

-   ライトの調整(今はとても暗い)
-   敵の追加
-   シューティング機能の追加
-   ダメージの追加
-   構造物の追加
-   テクスチャの追加
-   ゲームシステムの追加


<a id="org2eed224"></a>

# DONE-LIST

すでに実装された機能です。

-   WASDによる移動の追加 -2021/6/5
-   移動システムの改良(A, Dで角度を変えW, Sで前後進) -2021/6/7
-   TPS視点の追加 -2021/6/8
-   三角関数テーブルの追加(高速化のため) -2021/6/13
-   3Dモデルロードシステムの追加 -2021/6/16
-   自機モデルの追加 -2021/6/18


<a id="org4fd49f8"></a>

# License

-   Colour is licensed under GPL v3 or later.
    See the COPYING file or [GNU-website](https://www.gnu.org/licenses).
-   README.md and 3D model files in ./objects
    (\*.blend, \*.obj) are licensed under CC0,
    so you can do anything what you want to do.
    See [CC0-website](https://creativecommons.org/choose/zero/).

