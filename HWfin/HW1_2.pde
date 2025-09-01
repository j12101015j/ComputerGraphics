import processing.event.MouseEvent;

ShapeButton lineButton;
ShapeButton circleButton;
ShapeButton polygonButton;
ShapeButton ellipseButton;
ShapeButton curveButton;
ShapeButton pencilButton;
ShapeButton eraserButton;

Button clearButton;
PImage arrowUpImg, arrowDownImg, arrowLeftImg, arrowRightImg;
PImage sprayImg;


ShapeRenderer shapeRenderer;
ArrayList<ShapeButton> shapeButton;
float eraserSize = 20;

// 調色盤
ArrayList<Button> palette;
color penColor = color(0);   // 目前筆色

// 噴槍參數（可用滑鼠滾輪調整）
int sprayRadius = 16;
int sprayDensity = 100;

// 箭頭大小（可用滑鼠滾輪調整）
int arrowSize = 40;

public void setup() {
  size(1000, 800);
  background(255);

  // 先載入四張箭頭圖（檔案放在 sketch 的 data/ 資料夾）
  arrowUpImg    = loadImage("up.png");
  arrowDownImg  = loadImage("down.png");
  arrowLeftImg  = loadImage("left.png");
  arrowRightImg = loadImage("right.png");
  sprayImg = loadImage("spray.png");   // 檔案放在 data/ 目錄


  shapeRenderer = new ShapeRenderer();

  // 這裡才建按鈕，裡面的 setImage(...) 才能拿到剛載好的圖
  initButton();
}

public void draw() {
  background(255);

  // 工具按鈕
  for (ShapeButton sb : shapeButton) {
    sb.run(() -> {
      sb.beSelect();
      shapeRenderer.setRenderer(sb.getRendererType());
    });
  }

  // 調色盤：點擊切換筆色
  for (Button b : palette) {
    b.run(() -> { penColor = b.box_color; });
  }

  // 清除
  clearButton.run(() -> { shapeRenderer.clear(); });

  // 畫出畫布區的框（GUI）
  shapeRenderer.box.show();

  // 重繪所有圖形 + 目前工具的預覽
  shapeRenderer.run();
}

void resetButton() {
  for (ShapeButton sb : shapeButton) {
    sb.setSelected(false);
  }
}

public void initButton() {
  shapeButton = new ArrayList<ShapeButton>();

  // ===== 原本的工具按鈕（含圖示） =====
  lineButton = new ShapeButton(10, 10, 30, 30) {
    @Override public void show() {
      super.show();
      stroke(0);
      line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
    }
    @Override public Renderer getRendererType() { return new LineRenderer(); }
  };
  lineButton.setBoxAndClickColor(color(250), color(150));
  shapeButton.add(lineButton);

  circleButton = new ShapeButton(45, 10, 30, 30) {
    @Override public void show() {
      super.show();
      stroke(0);
      circle(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2);
    }
    @Override public Renderer getRendererType() { return new CircleRenderer(); }
  };
  circleButton.setBoxAndClickColor(color(250), color(150));
  shapeButton.add(circleButton);

  polygonButton = new ShapeButton(80, 10, 30, 30) {
    @Override public void show() {
      super.show();
      stroke(0);
      line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + 2);
      line(pos.x + 2, pos.y + size.y - 2, pos.x + size.x - 2, pos.y + size.y - 2);
      line(pos.x + size.x - 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
      line(pos.x + 2, pos.y + 2, pos.x + 2, pos.y + size.y - 2);
    }
    @Override public Renderer getRendererType() { return new PolygonRenderer(); }
  };
  polygonButton.setBoxAndClickColor(color(250), color(150));
  shapeButton.add(polygonButton);

  ellipseButton = new ShapeButton(115, 10, 30, 30) {
    @Override public void show() {
      super.show();
      stroke(0);
      ellipse(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2, size.y * 2 / 3);
    }
    @Override public Renderer getRendererType() { return new EllipseRenderer(); }
  };
  ellipseButton.setBoxAndClickColor(color(250), color(150));
  shapeButton.add(ellipseButton);

  curveButton = new ShapeButton(150, 10, 30, 30) {
    @Override public void show() {
      super.show();
      stroke(0);
      bezier(pos.x, pos.y, pos.x, pos.y + size.y, pos.x + size.x, pos.y, pos.x + size.x, pos.y + size.y);
    }
    @Override public Renderer getRendererType() { return new CurveRenderer(); }
  };
  curveButton.setBoxAndClickColor(color(250), color(150));
  shapeButton.add(curveButton);

  clearButton = new Button(width - 50, 10, 30, 30);
  clearButton.setBoxAndClickColor(color(250), color(150));
  clearButton.setImage(loadImage("clear.png"));

  pencilButton = new ShapeButton(185, 10, 30, 30) {
    @Override public Renderer getRendererType() { return new PencilRenderer(); }
  };
  pencilButton.setImage(loadImage("pencil.png"));
  pencilButton.setBoxAndClickColor(color(250), color(150));
  shapeButton.add(pencilButton);

  eraserButton = new ShapeButton(220, 10, 30, 30) {
    @Override public Renderer getRendererType() { return new EraserRenderer(); }
  };
  eraserButton.setImage(loadImage("eraser.png"));
  eraserButton.setBoxAndClickColor(color(250), color(150));
  shapeButton.add(eraserButton);

  // ===== 10 色調色盤（兩列） =====
  palette = new ArrayList<Button>();
  int px = 260, py = 10, sz = 18, gap = 6, cols = 5;
  color[] colors = {
    color(0), color(255),
    color(244,67,54), color(255,152,0), color(255,235,59),
    color(76,175,80), color(33,150,243), color(156,39,176),
    color(121,85,72), color(158,158,158)
  };
  for (int i = 0; i < colors.length; i++) {
    int cx = px + (i % cols) * (sz + gap);
    int cy = py + (i / cols) * (sz + gap);
    Button b = new Button(cx, cy, sz, sz).setBoxAndClickColor(colors[i], colors[i]);
    palette.add(b);
  }

// 噴槍（左欄按鈕）
ShapeButton sprayButton = new ShapeButton(2, 50, 28, 28) {
  @Override public Renderer getRendererType() { return new SprayRenderer(); }
};
sprayButton.setImage(sprayImg);
sprayButton.setBoxAndClickColor(color(250), color(150));
shapeButton.add(sprayButton);


  // 箭頭按鈕 (上)
ShapeButton arrowUpBtn = new ShapeButton(2, 84, 28, 28) {
  @Override public Renderer getRendererType() { return new ArrowRenderer("up"); }
};
arrowUpBtn.setImage(arrowUpImg);
arrowUpBtn.setBoxAndClickColor(color(250), color(150));
shapeButton.add(arrowUpBtn);

// 箭頭按鈕 (下)
ShapeButton arrowDownBtn = new ShapeButton(2, 118, 28, 28) {
  @Override public Renderer getRendererType() { return new ArrowRenderer("down"); }
};
arrowDownBtn.setImage(arrowDownImg);
arrowDownBtn.setBoxAndClickColor(color(250), color(150));
shapeButton.add(arrowDownBtn);

// 箭頭按鈕 (左)
ShapeButton arrowLeftBtn = new ShapeButton(2, 152, 28, 28) {
  @Override public Renderer getRendererType() { return new ArrowRenderer("left"); }
};
arrowLeftBtn.setImage(arrowLeftImg);
arrowLeftBtn.setBoxAndClickColor(color(250), color(150));
shapeButton.add(arrowLeftBtn);

// 箭頭按鈕 (右)
ShapeButton arrowRightBtn = new ShapeButton(2, 186, 28, 28) {   //(x,y,w,h)
  @Override public Renderer getRendererType() { return new ArrowRenderer("right"); }
};
arrowRightBtn.setImage(arrowRightImg);
arrowRightBtn.setBoxAndClickColor(color(250), color(150));
shapeButton.add(arrowRightBtn);
}

void mouseWheel(MouseEvent e)  {
  float v = e.getCount();           // 往前(+)、往後(-)

  // 橡皮擦大小
  if (shapeRenderer.renderer instanceof EraserRenderer) {
    if (v < 0) eraserSize = min(30, eraserSize + 1);
    else       eraserSize = max(4,  eraserSize - 1);
  }
  // 噴槍大小
  if (shapeRenderer.renderer instanceof SprayRenderer) {
    if (v < 0) sprayRadius = min(60, sprayRadius + 1);
    else       sprayRadius = max(3,  sprayRadius - 1);
  }
  // 箭頭大小
  if (shapeRenderer.renderer instanceof ArrowRenderer) {
    if (v < 0) arrowSize = min(120, arrowSize + 2);
    else       arrowSize = max(10,  arrowSize - 2);
  }
}
