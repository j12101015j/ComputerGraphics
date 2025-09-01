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
- **程式碼**
```java
public void CGCircle(float x, float y, float r) {
    // Midpoint circle (8-way symmetry)
    int xc = round(x), yc = round(y);
    int R  = max(0, round(r));
    int d  = 1 - R;
    int xi = 0, yi = R;
    color col = penColor;

    while (xi <= yi) {
        drawPoint(xc + xi, yc + yi, col);
        drawPoint(xc - xi, yc + yi, col);
        drawPoint(xc + xi, yc - yi, col);
        drawPoint(xc - xi, yc - yi, col);
        drawPoint(xc + yi, yc + xi, col);
        drawPoint(xc - yi, yc + xi, col);
        drawPoint(xc + yi, yc - xi, col);
        drawPoint(xc - yi, yc - xi, col);

        xi++;
        if (d < 0) {
            d += (xi << 1) + 1;
        } else {
            yi--;
            d += (xi << 1) - (yi << 1) + 1;
        }
    }
```
<img width="1246" height="740" alt="image" src="https://github.com/user-attachments/assets/a014aadb-1470-464d-a167-e999da4374b8" />

## 3. 橢圓 (CGEllipse)
- **演算法**：Midpoint Ellipse Algorithm  
- **核心概念**：分兩個區域，對稱畫四分之一橢圓。
- **程式碼**
```java
public void CGEllipse(float x, float y, float r1, float r2) {
    // Midpoint ellipse (4-way symmetry)
    int xc = round(x), yc = round(y);
    int rx = max(0, round(r1));
    int ry = max(0, round(r2));
    color col = penColor;

    long rx2 = 1L * rx * rx;
    long ry2 = 1L * ry * ry;

    long xk = 0, yk = ry;
    long px = 0;
    long py = 2 * rx2 * yk;

    // Region 1
    long d1 = ry2 - rx2 * ry + rx2 / 4;
    while (px < py) {
        drawPoint(xc + (int)xk, yc + (int)yk, col);
        drawPoint(xc - (int)xk, yc + (int)yk, col);
        drawPoint(xc + (int)xk, yc - (int)yk, col);
        drawPoint(xc - (int)xk, yc - (int)yk, col);

        xk++;
        px += 2 * ry2;
        if (d1 < 0) {
            d1 += ry2 + px;
        } else {
            yk--;
            py -= 2 * rx2;
            d1 += ry2 + px - py;
        }
    }

    // Region 2 (use double for 0.5 terms)
    double xd = xk, yd = yk;
    double d2 = ry2 * (xd + 0.5) * (xd + 0.5) + rx2 * (yd - 1) * (yd - 1) - rx2 * ry2;
    while (yk >= 0) {
        drawPoint(xc + (int)xk, yc + (int)yk, col);
        drawPoint(xc - (int)xk, yc + (int)yk, col);
        drawPoint(xc + (int)xk, yc - (int)yk, col);
        drawPoint(xc - (int)xk, yc - (int)yk, col);

        yk--;
        py -= 2 * rx2;
        if (d2 > 0) {
            d2 += rx2 * (1 - 2 * yk);
        } else {
            xk++;
            d2 += rx2 * (1 - 2 * yk) + 2 * ry2 * xk;
        }
    }
}
```
<img width="1240" height="717" alt="image" src="https://github.com/user-attachments/assets/e8e12fc9-78e1-4942-a77f-0cf04f2a2587" />

## 4. 曲線 (CGBezier Curve)
- **演算法**：De Casteljau’s Algorithm  
- **核心概念**：控制點線性插值，逐步計算曲線上的點。
- **程式碼**
```java
 float L = distance(p1, p2) + distance(p2, p3) + distance(p3, p4);
    int steps = max(24, min(1024, round(L)));
    float dt = 1.0f / steps;
    color col = penColor;

    for (int i = 0; i <= steps; i++) {
        float t = i * dt, u = 1 - t;
        float bx = u*u*u*p1.x + 3*u*u*t*p2.x + 3*u*t*t*p3.x + t*t*t*p4.x;
        float by = u*u*u*p1.y + 3*u*u*t*p2.y + 3*u*t*t*p3.y + t*t*t*p4.y;
        drawPoint(round(bx), round(by), col);
    }
```
- <img width="1239" height="658" alt="image" src="https://github.com/user-attachments/assets/751e2c88-c4b7-4eec-a5f1-1fa1720e5aa7" />


## 5. 其他功能
- 橡皮擦：白色覆蓋，支援滾輪調整大小  
- 自由筆：mouseDragged 畫點  
- 噴槍：隨機散點模擬  
- 箭頭：PNG 貼圖 + tint 上色，可縮放/換色/預覽
<img width="1243" height="1013" alt="image" src="https://github.com/user-attachments/assets/8fc03d6b-8f26-480a-bb55-380b231efcb2" />

### 工具
- ChatGPT 5.0

