public interface Shape { public void drawShape(); }

public class Point implements Shape {
    ArrayList<Vector3> points = new ArrayList<Vector3>();
    color col;
    public Point(ArrayList<Vector3> p, color c) { points = p; col = c; }
    @Override public void drawShape() {
        if (points.size() <= 1) return;
        color old = penColor; penColor = col;
        for (int i = 0; i < points.size() - 1; i++) {
            Vector3 p1 = points.get(i), p2 = points.get(i + 1);
            CGLine(p1.x, p1.y, p2.x, p2.y);
        }
        penColor = old;
    }
}

public class Line implements Shape {
    Vector3 point1, point2; color col;
    public Line() {}
    public Line(Vector3 v1, Vector3 v2, color c){ point1=v1; point2=v2; col=c; }
    @Override public void drawShape() {
        color old = penColor; penColor = col;
        CGLine(point1.x, point1.y, point2.x, point2.y);
        penColor = old;
    }
}

public class Circle implements Shape {
    Vector3 center; float radius; color col;
    public Circle() {}
    public Circle(Vector3 v1, float r, color c){ center=v1; radius=r; col=c; }
    @Override public void drawShape() {
        color old = penColor; penColor = col;
        CGCircle(center.x, center.y, radius);
        penColor = old;
    }
}

public class Polygon implements Shape {
    ArrayList<Vector3> verties = new ArrayList<Vector3>(); color col;
    public Polygon(ArrayList<Vector3> v, color c){ verties = v; col = c; }
    @Override public void drawShape() {
        if (verties.size() <= 0) return;
        color old = penColor; penColor = col;
        for (int i = 0; i <= verties.size(); i++) {
            Vector3 p1 = verties.get(i % verties.size());
            Vector3 p2 = verties.get((i + 1) % verties.size());
            CGLine(p1.x, p1.y, p2.x, p2.y);
        }
        penColor = old;
    }
}

public class Ellipse implements Shape {
    Vector3 center; float radius1, radius2; color col;
    public Ellipse() {}
    public Ellipse(Vector3 cen, float r1, float r2, color c){ center=cen; radius1=r1; radius2=r2; col=c; }
    @Override public void drawShape() {
        color old = penColor; penColor = col;
        CGEllipse(center.x, center.y, radius1, radius2);
        penColor = old;
    }
}

public class Curve implements Shape {
    Vector3 cpoint1, cpoint2, cpoint3, cpoint4; color col;
    public Curve() {}
    public Curve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4, color c){
        cpoint1=p1; cpoint2=p2; cpoint3=p3; cpoint4=p4; col=c;
    }
    @Override public void drawShape() {
        color old = penColor; penColor = col;
        CGCurve(cpoint1, cpoint2, cpoint3, cpoint4);
        penColor = old;
    }
}

public class EraseArea implements Shape {
    Vector3 point1, point2;
    public EraseArea() {}
    public EraseArea(Vector3 p1, Vector3 p2){ point1 = p1; point2 = p2; }
    @Override public void drawShape() { CGEraser(point1, point2); }
}

/* 新增：噴槍與箭頭這兩種 Shape */
public class Spray implements Shape {
    ArrayList<Vector3> points; color col;
    public Spray(ArrayList<Vector3> pts, color c){ points=pts; col=c; }
    @Override public void drawShape(){
        for (Vector3 p : points) drawPoint(p.x, p.y, col);
    }
}
public class Arrow implements Shape {
    Vector3 center; float size; String dir; color col;
    public Arrow(Vector3 c, float s, String d, color col_){ center=c; size=s; dir=d; col=col_; }
    @Override public void drawShape(){
        color old = penColor; penColor = col;
        CGArrow(center.x, center.y, size, dir);
        penColor = old;
    }
}
