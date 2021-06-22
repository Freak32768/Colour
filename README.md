
# Table of Contents

1.  [Introduction](#org3b750c0)
2.  [System](#org793a503)
3.  [TODO-LIST](#org314e612)
4.  [DONE-LIST](#orgaa4ad4f)
5.  [REMOVED-LIST](#org13e69b2)
6.  [License](#org7633bf2)



<a id="org3b750c0"></a>

# Introduction

-   Colour(コロールと読む)はその名の通り"色"をテーマにした
    3DパズルTPSゲームです。(パズルかどうかは微妙です。)
-   ColourはGauche(Scheme処理系), Gauche-gl(GaucheのOpenGL拡張)を必要とします。


<a id="org793a503"></a>

# System

-   ADで左右に方向回転、WSで移動です。
-   Vで弾を選択し、Bで弾を発射します。


<a id="org314e612"></a>

# TODO-LIST

これから実装予定の機能です。

-   ライトの調整(今はとても暗い)
-   効率的な敵の管理システム
-   シューティング機能
-   ダメージ
-   構造物
-   テクスチャ
-   ゲームシステム


<a id="orgaa4ad4f"></a>

# DONE-LIST

すでに実装された機能です。

-   移動システムの改良(A, Dで角度を変えW, Sで前後進) -2021/6/7
-   TPS視点 -2021/6/8
-   三角関数テーブル(高速化のため) -2021/6/13
-   3Dモデルロードシステム -2021/6/16
-   自機モデル -2021/6/18
-   敵のモデル、移動システム -2021/6/22


<a id="org13e69b2"></a>

# REMOVED-LIST

削除された機能です。

-   WASDによる移動 -移動システムの改良により削除


<a id="org7633bf2"></a>

# License

-   Colour is licensed under GPL v3 or later.
    See the COPYING file or [GNU-website](https://www.gnu.org/licenses).
-   README.md and 3D model files in ./objects
    (\*.blend, \*.obj) are licensed under CC0,
    so you can do anything what you want to do.
    See [CC0-website](https://creativecommons.org/choose/zero/).

