# ComputerGraphics 計算機圖學 HW1 作業說明

## 專案說明 
### 實作五個計算機圖學演算法繪製基本幾何圖形，避免使用內建繪圖函數，並加上簡易調色盤、上下左右印章繪製。

本專案的直線、圓形、橢圓、曲線等繪製功能，**並未直接呼叫 Processing 內建的圖形函式**，而是依據經典演算法以逐像素方式實作。
## 專案實作
### 利用chatGPT，透過演算法實現直線、圓形等等繪圖功能，並禁止使用內建函式，且完成加分項(簡易調色盤、上下左右蓋章圖示)

## 1. 直線 (CGLine)
- **演算法**：Bresenham's Line Algorithm  
- **核心概念**：利用誤差項決定畫哪個像素，只需整數加減。
- **程式碼**
```java
    // Bresenham line (all octants)
    int x0 = round(x1), y0 = round(y1);
    int x1i = round(x2), y1i = round(y2);
    int dx = abs(x1i - x0), dy = abs(y1i - y0);
    int sx = (x0 < x1i) ? 1 : -1;
    int sy = (y0 < y1i) ? 1 : -1;
    int err = dx - dy;
    color col = penColor;

    while (true) {
        drawPoint(x0, y0, col);
        if (x0 == x1i && y0 == y1i) break;
        int e2 = err << 1;
        if (e2 > -dy) { err -= dy; x0 += sx; }
        if (e2 <  dx) { err += dx; y0 += sy; }
    }
```
<img width="1243" height="1023" alt="image" src="https://github.com/user-attachments/assets/3690e3ec-871e-43c5-a483-e7427f7edd7c" />

## 2. 圓形 (CGCircle)
- **演算法**：Midpoint Circle Algorithm  
- **核心概念**：八分圓對稱，判斷下一步往右或右下。

## 3. 橢圓 (CGEllipse)
- **演算法**：Midpoint Ellipse Algorithm  
- **核心概念**：分兩個區域，對稱畫四分之一橢圓。

## 4. 曲線 (CGBezier Curve)
- **演算法**：De Casteljau’s Algorithm  
- **核心概念**：控制點線性插值，逐步計算曲線上的點。

## 5. 其他功能
- 橡皮擦：白色覆蓋，支援滾輪調整大小  
- 自由筆：mouseDragged 畫點  
- 噴槍：隨機散點模擬  
- 箭頭：PNG 貼圖 + tint 上色，可縮放/換色/預覽

