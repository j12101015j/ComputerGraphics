# ComputerGraphics
1. 直線 (Line)

使用方法：Bresenham’s Line Algorithm (布雷森漢演算法)

核心概念：

透過判斷誤差項 (error term)，在水平或垂直方向上逐步決定要畫哪一個 pixel。

只用整數加減與判斷，不需要浮點數除法，因此效率高。

優點：速度快、準確，而且避免使用昂貴的浮點運算。

2. 圓形 (Circle)

使用方法：Midpoint Circle Algorithm (中點圓演算法)

核心概念：

從圓的最上方開始，利用對稱性 (八分圓對稱) 同時繪製八個點。

判斷「下一步往右還是往右下」時，用圓方程式的中點判斷決定。

優點：僅需加減與比較運算，不用開根號或三角函數。

3. 橢圓 (Ellipse)

使用方法：Midpoint Ellipse Algorithm (中點橢圓演算法)

核心概念：

與圓形相似，但需考慮橢圓的兩個軸長 (rx, ry)。

演算法分為「區域 1」與「區域 2」兩段來跑，分別以 x 或 y 為主迭代。

同樣利用對稱性 (四分之一橢圓) 繪製。

優點：能有效繪製非等軸的橢圓，同樣避免浮點運算。

4. 曲線 (Bezier Curve)

使用方法：De Casteljau’s Algorithm (德卡斯特里奧演算法)

核心概念：

透過逐步線性插值 (linear interpolation) 計算貝茲曲線上的點。

四個控制點 (c0, c1, c2, c3) → 對應三階 (cubic) Bezier。

用公式：

𝐵
(
𝑡
)
=
(
1
−
𝑡
)
3
𝑃
0
+
3
𝑡
(
1
−
𝑡
)
2
𝑃
1
+
3
𝑡
2
(
1
−
𝑡
)
𝑃
2
+
𝑡
3
𝑃
3
(
0
≤
𝑡
≤
1
)
B(t)=(1−t)
3
P0+3t(1−t)
2
P1+3t
2
(1−t)P2+t
3
P3(0≤t≤1)

程式實作是用一個迴圈，t 由 0 到 1，每次取一小步，算出座標並畫點。

5. 其他功能
橡皮擦 (Eraser)

本質上就是「畫一個白色圓/矩形」蓋掉原本的內容。

大小可用滑鼠滾輪調整。

自由畫筆 (Pencil)

直接在 mouseDragged 時，不斷將當下的 (x,y) 畫上像素。

噴槍 (Spray)

在一個圓形半徑範圍內，隨機挑選點，產生類似噴漆的效果。

箭頭 (Arrow)

使用 PNG 圖檔，透過 image() 與 tint(penColor) 貼到畫布上，

也支援縮放、顏色變化與即時預覽。

總結

直線：Bresenham 演算法

圓形：Midpoint Circle 演算法

橢圓：Midpoint Ellipse 演算法

曲線：De Casteljau’s 演算法 (Bezier)

自由繪圖 / 噴槍 / 橡皮擦 / 箭頭：利用隨機點、顏色覆蓋或 PNG 貼圖完成
