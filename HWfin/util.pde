public void CGLine(float x1, float y1, float x2, float y2) {
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

    /*
     // 驗證用（交作業前請註解）
     // stroke(0); noFill(); line(x1,y1,x2,y2);
    */
}

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

    /*
    // 驗證用（交作業前請註解）
    // stroke(0); noFill(); circle(x,y,r*2);
    */
}

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

    /*
    // 驗證用（交作業前請註解）
    // stroke(0); noFill(); ellipse(x,y, r1*2, r2*2);
    */
}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    // Cubic Bezier by uniform sampling; steps ~ control polyline length
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

    /*
    // 驗證用（交作業前請註解）
    // stroke(0); noFill();
    // bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    */
}

public void CGEraser(Vector3 p1, Vector3 p2) {
    // 塗成與畫布區域一致的背景色（你的盒子背景是 color(250)）
    int x0 = min(round(p1.x), round(p2.x));
    int y0 = min(round(p1.y), round(p2.y));
    int x1 = max(round(p1.x), round(p2.x));
    int y1 = max(round(p1.y), round(p2.y));

    x0 = max(0, x0); y0 = max(0, y0);
    x1 = min(width - 1, x1); y1 = min(height - 1, y1);

    color bg = color(250);
    for (int y = y0; y <= y1; y++) {
        for (int x = x0; x <= x1; x++) {
            drawPoint(x, y, bg);
        }
    }
}

// ================= 低階工具 =================

// 逐像素寫入，避免 point() 的抗鋸齒殘影
public void drawPoint(float xf, float yf, color c) {
    int x = (int)floor(xf + 0.5f);
    int y = (int)floor(yf + 0.5f);
    if (x < 0 || x >= width || y < 0 || y >= height) return;
    set(x, y, c);
}

// overload：避免有些呼叫以 int 型別傳進來
public void drawPoint(int x, int y, color c) {
    if (x < 0 || x >= width || y < 0 || y >= height) return;
    set(x, y, c);
}

// 兩點距離（給 Bezier 步數估計用）
public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

// 噴槍
public void CGSpray(float x, float y, float radius, int density) {
  for (int i = 0; i < density; i++) {
    float a = random(TWO_PI);
    float r = radius * sqrt(random(1));
    int px = round(x + r * cos(a));
    int py = round(y + r * sin(a));
    for (int ox=-1; ox<=1; ox++)
      for (int oy=-1; oy<=1; oy++)
        if (random(1) < 0.6) drawPoint(px+ox, py+oy, penColor);
  }
}

public void CGArrow(float x, float y, float size, String dir) {
  CGArrow(x, y, size, dir, 255);              // 固化：不透明
}

public void CGArrow(float x, float y, float size, String dir, int alpha) {
  // 1) 挑選對應的 PNG
  PImage base = null;
  if ("up".equals(dir))        base = arrowUpImg;
  else if ("down".equals(dir)) base = arrowDownImg;
  else if ("left".equals(dir)) base = arrowLeftImg;
  else if ("right".equals(dir))base = arrowRightImg;
  if (base == null) return;

  // 2) 用 alpha 重新上色成 penColor
  PImage colored = colorizeByAlpha(base, penColor);

  // 3) 繪製（預覽給半透明，固化給 255）
  pushStyle();
  imageMode(CENTER);
  tint(255, alpha);
  image(colored, x, y, size, size);
  noTint();
  popStyle();
}


// 依 src 的 alpha 產生「整張都是指定顏色」的新圖（線條仍保留原透明度）
PImage colorizeByAlpha(PImage src, color col) {
  PImage out = createImage(src.width, src.height, ARGB);
  src.loadPixels(); out.loadPixels();
  int rgb = col & 0x00FFFFFF;            // 只取 RGB，等一下把 alpha 換成 src 的 alpha
  for (int i = 0; i < src.pixels.length; i++) {
    int a = (src.pixels[i] >>> 24) & 0xFF;
    out.pixels[i] = (a << 24) | rgb;
  }
  out.updatePixels();
  return out;
}
