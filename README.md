# 電腦圖學 HW1 作業說明

本專案的直線、圓形、橢圓、曲線等繪製功能，**並未直接呼叫 Processing 內建的圖形函式**，而是依據經典演算法以逐像素方式實作。

## 1. 直線 (Line)
- **演算法**：Bresenham's Line Algorithm  
- **核心概念**：利用誤差項決定畫哪個像素，只需整數加減。

## 2. 圓形 (Circle)
- **演算法**：Midpoint Circle Algorithm  
- **核心概念**：八分圓對稱，判斷下一步往右或右下。

## 3. 橢圓 (Ellipse)
- **演算法**：Midpoint Ellipse Algorithm  
- **核心概念**：分兩個區域，對稱畫四分之一橢圓。

## 4. 曲線 (Bezier Curve)
- **演算法**：De Casteljau’s Algorithm  
- **核心概念**：控制點線性插值，逐步計算曲線上的點。

## 5. 其他功能
- 橡皮擦：白色覆蓋，支援滾輪調整大小  
- 自由筆：mouseDragged 畫點  
- 噴槍：隨機散點模擬  
- 箭頭：PNG 貼圖 + tint 上色，可縮放/換色/預覽

