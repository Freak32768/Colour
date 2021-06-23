
# Table of Contents

1.  [Introduction](#orga22a510)
2.  [System](#org4ec9202)
3.  [TODO-LIST](#orgb3801e7)
4.  [DONE-LIST](#org29e0cae)
5.  [REMOVED-LIST](#orgea6569a)
6.  [License](#org34d92c3)



<a id="orga22a510"></a>

# Introduction

-   Colour(コロールと読む)はその名の通り"色"をテーマにした
    3DパズルTPSゲームです。(パズルかどうかは微妙です。)
-   ColourはGauche(Scheme処理系), Gauche-gl(GaucheのOpenGL拡張)を必要とします。
-   コンピュータによっては挙動がおかしくなることがあります。ご了承ください。


<a id="org4ec9202"></a>

# System

-   ADで左右に方向回転、WSで前後移動です。
-   Vで弾の色を選択し、Bで弾を発射します。


<a id="orgb3801e7"></a>

# TODO-LIST

これから実装予定の機能です

-   リファクタリング(今はコードがごちゃごちゃしている)
-   ダメージ
-   構造物
-   テクスチャ
-   ゲームシステム


<a id="org29e0cae"></a>

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


<a id="orgea6569a"></a>

# REMOVED-LIST

削除された、または実装を諦めた機能です。

-   WASDによる移動 -移動システムの改良により削除
-   ライトの調整(今はとても暗い) -どうしてもわからなかった


<a id="org34d92c3"></a>

# License

-   Colour is licensed under GPL v3 or later.
    See the COPYING file or [GNU-website](https://www.gnu.org/licenses).
-   README.md and 3D model files in ./objects/
    (\*.blend, \*.obj) are licensed under CC0,
    so you can do anything what you want to do.
    See [CC0-website](https://creativecommons.org/choose/zero/).

