PFont Forces_Font;

class Point {
  float X, Y;
  Point(float x, float y) {
    this.X = x;
    this.Y = y;
  }
}


class Force {
  Point head;  //Point
  float magnitude = 0;
  String Name; 

  Force(Point action_point, float Value) {
    this.head = action_point;
    this.magnitude = Value;
  }

  float distance_L;  //Distance from left in meters
  void distance_L(float dist) {
    this.distance_L = dist;
  }



  color Line_Color = color(0);
  float Force_stroke_thickness = 1.5;
  boolean mouseTrackingMode = false;

  void make() {
    this.make(this.head);
  }

  void make(Point headAt) {   //
    stroke(Line_Color);
    strokeWeight(Force_stroke_thickness);
    if (magnitude >= 0) {  //Pointing upwards
      textFont(Forces_Font);
      textSize(20);
      fill(this.Line_Color);
      textAlign(CENTER, BOTTOM);
      text(this.Name, headAt.X, headAt.Y - beam.Thickness / 2 - 5);
      line(headAt.X, headAt.Y, headAt.X - 10 * sin(radians(30)), headAt.Y + 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X + 10 * sin(radians(30)), headAt.Y + 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X, headAt.Y + 50);  
      textFont(Forces_Font);
      textAlign(CENTER, TOP);
      textSize(25);
      text(this.displayForceMagnitude(), headAt.X, headAt.Y + 55);
    } else if (magnitude < 0) {  //Pointing downwards
      textFont(Forces_Font);
      textSize(20);
      fill(this.Line_Color);
      textAlign(CENTER, TOP);
      text(this.Name, headAt.X, headAt.Y + beam.Thickness / 2 + 5);
      line(headAt.X, headAt.Y, headAt.X - 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X + 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X, headAt.Y - 50); 
      textFont(Forces_Font);
      textAlign(CENTER, BOTTOM);
      textSize(25);
      text(this.displayForceMagnitude(), headAt.X, headAt.Y - 55);
    }
  }

  void make(Point centerAt, float Length_m, float distance_L_m) {  //For the beam adjustment -> TO ADJUST ALL LOADS (adjust loads)
    this.make(new Point(centerAt.X - m_to_pixel(Length_m/2) + m_to_pixel(distance_L_m), centerAt.Y));
  }

  String displayForceMagnitude() {
    if (abs(magnitude) <= 100)
      return str(abs(magnitude)) + "N";
    else {
      return str(abs(magnitude)/1000) + "kN";
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

  void setLength_m(float length_m) {
    Length_m = length_m;
    Length = m_to_pixel(length_m);
    this.centerAt(this.center, true);  //To reset the end supports to calibrate with the beam, but don't change their values
  }

  float Length, Thickness;

  Force support_A, support_B;  //A -> Left support, B -> Right support
  ArrayList<Force> loads = new ArrayList<Force>();  //Loads on the beam


  void AttachForce(float Value, float Distance_L_m) {
    Force load = new Force(new Point(this.center.X - this.Length/2 + m_to_pixel(Distance_L_m), this.center.Y), Value);
    load.distance_L = Distance_L_m;
    load.Line_Color = color(0, 0, 255);
    load.Name = "F" + str(loads.size() + 0);
    loads.add(load);
    println("Attaching a force of magnitude " + str(load.magnitude) + " at " + str(load.head.X));
    calculateReactionForces();
  }


  void calculateReactionForces() {
    support_B.magnitude = 0;
    support_A.magnitude = 0;  
    for (Force load : loads) {
      support_B.magnitude += -load.magnitude * load.distance_L;
      support_A.magnitude += -load.magnitude * (this.Length_m - load.distance_L);
      //println(str(this.Length_m) + "," + load.distance_L);
    }
    support_B.magnitude /= this.Length_m;
    support_A.magnitude /= this.Length_m;
  }

  Beam(Point center, float Length_m, float Thickness_m) {

    this.Length_m = Length_m;
    this.Thickness_m = Thickness_m;
    Length = m_to_pixel(Length_m);
    Thickness = m_to_pixel(Thickness_m);
    this.centerAt(center);
  }

  void centerAt(Point center) {
    centerAt(center, false);
  }

  void centerAt(Point center, boolean previousDataExists) {
    if (previousDataExists) {
      this.center = center;
      support_A.head = new Point(this.center.X - this.Length/2, this.center.Y);
      support_B.head = new Point(this.center.X + this.Length/2, this.center.Y);
    } else {
      this.center = center;
      support_A = new Force(new Point(this.center.X - this.Length/2, this.center.Y), 0);
      support_A.Line_Color = color(255, 0, 0);
      support_A.Force_stroke_thickness = 2;
      support_B = new Force(new Point(this.center.X + this.Length/2, this.center.Y), 0);
      support_B.Line_Color = color(255, 0, 0);
      support_B.Force_stroke_thickness = 2;
      support_A.distance_L(0);
      support_B.distance_L(this.Length);
      support_A.Name = "A";
      support_B.Name = "B";
      support_A.Force_stroke_thickness = 2;
      support_B.Force_stroke_thickness = 2;
      println("The center is " + str(this.center.X));
    }
  }

  boolean mouseTrackingMode = false;

  color fill_color = color(0);
  color stroke_color = color(0);
  float stroke_thickness = 2;

  void draw_beam() {
    if (this.mouseTrackingMode) {  //Mouse holding the beam
      this.centerAt(new Point(mouseX, mouseY), true);
    }
    stroke(stroke_color);
    strokeWeight(stroke_thickness);
    fill(fill_color);
    rectMode(CENTER);
    rect(center.X, center.Y, Length, Thickness);
    for (Force load : loads) {
      load.make(this.center, this.Length_m, load.distance_L);
    }
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
  String Name;
  float Max_Stress;
  float Youngs_Modulous;
  Material(String name, float Max_Tensile_Stress, float Youngs_Modulous) {
    this.Name = name;
    this.Max_Stress = Max_Tensile_Stress;
    this.Youngs_Modulous = Youngs_Modulous;
  }
}

//Material List needed