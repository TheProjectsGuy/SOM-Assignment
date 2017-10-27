class Point {
  float X, Y;
  Point(float x, float y) {
    this.X = x;
    this.Y = y;
  }
}


class Force {
  Point head;
  float magnitude = 0;
  int direction = 0;  //1 for UP, -1 for DOWN
  Force(Point action_point, int Direction) {
    this.head = action_point;
    this.direction = Direction;
  }
  
  
  color Line_Color = color(0);
  float Force_stroke_thickness = 1.5;
  boolean mouseTrackingMode = false;

  void make() {
    stroke(Line_Color);
    strokeWeight(Force_stroke_thickness);
    if (direction == 1) {
      line(head.X, head.Y, head.X - 10 * sin(radians(30)), head.Y + 10 * cos(radians(30)));
      line(head.X, head.Y, head.X + 10 * sin(radians(30)), head.Y + 10 * cos(radians(30)));
      line(head.X, head.Y, head.X, head.Y + 50);
    } else if (direction == -1) {
      line(head.X, head.Y, head.X - 10 * sin(radians(30)), head.Y - 10 * cos(radians(30)));
      line(head.X, head.Y, head.X + 10 * sin(radians(30)), head.Y - 10 * cos(radians(30)));
      line(head.X, head.Y, head.X, head.Y - 50);
    }
  }
}

//Simple basic beam
class Beam {
  float Length_m = 4;
  float Thickness_m = 0.10;
  Point center;

  boolean pointInsideBeam(Point point) {
    if (point.X <= center.X + Length/2 && point.X >= center.X - Length/2 && point.Y <= center.Y + Thickness/2 && point.Y >= center.Y - Thickness/2)
      return true;
    return false;
  }

  float Length, Thickness;

  Force support_A, support_B;

  Beam(Point center, float Length_m, float Thickness_m) {

    this.Length_m = Length_m;
    this.Thickness_m = Thickness_m;

    Length = m_to_pixel(Length_m);
    Thickness = m_to_pixel(Thickness_m);
    this.centerAt(center);
  }

  void centerAt(Point center) {
    this.center = center;
    support_A = new Force(new Point(this.center.X - this.Length/2, this.center.Y), 1);
    support_A.Line_Color = color(255, 0, 0);
    support_A.Force_stroke_thickness = 2;
    support_B = new Force(new Point(this.center.X + this.Length/2, this.center.Y), 1);
    support_B.Line_Color = color(255, 0, 0);
    support_B.Force_stroke_thickness = 2;
  }

  boolean mouseTrackingMode = false;

  color fill_color = color(0);
  color stroke_color = color(0);
  float stroke_thickness = 2;

  void draw_beam() {
    if (mouseTrackingMode) {
      this.centerAt(new Point(mouseX, mouseY));
    }
    stroke(stroke_color);
    strokeWeight(stroke_thickness);
    fill(fill_color);
    rectMode(CENTER);
    rect(center.X, center.Y, Length, Thickness);
    support_A.make();
    support_B.make();
  }
}

//Takes care of all the maths and fuzz about the beam
class BeamSpecifications {
  float Max_Distance_From_Neutral_Axis = 0;
  Material material;
  float Moment_Of_Inertia = 0;
}

class Material {
  String name;
  float Max_Stress;
  float Youngs_Modulous;
  Material(String name, float Max_Tensile_Stress, float Youngs_Modulous) {
    this.name = name;
    this.Max_Stress = Max_Tensile_Stress;
    this.Youngs_Modulous = Youngs_Modulous;
  }
}

//Material List needed