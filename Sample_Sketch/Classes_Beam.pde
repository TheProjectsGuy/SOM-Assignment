PFont Forces_Font;

class Point {
  float X, Y;
  Point(float x, float y) {
    this.X = x;
    this.Y = y;
  }
}

int removed_loads = 0;
class Force {
  Point head;  //Point
  float magnitude = 1000;
  String Name = ""; 
  Force() {
  }

  int indexOnBeam;  //0,1,2,3...

  Force(Point action_point, float Value) {
    this.head = action_point;
    this.magnitude = Value;
  }

  float distance_L;  //Distance from left in meters
  void distance_L(float dist) {
    this.distance_L = dist;
    if (CURRENT_SCREEN == "Bending Moment Screen") {  //Make those changes only here 
      this.head.X = beam.center.X - beam.Length/2 + m_to_pixel(constrain(dist, 0, beam.Length_m));
    }
  }

  color Line_Color = color(0);
  float Force_stroke_thickness = 1.5;
  boolean mouseTrackingMode = false;

  void make() {
    if (!mouseTrackingMode) {
      this.make(this.head);
    } else {  //Mouse Tracking mode for forces
      this.Line_Color = color(0, 0, 255);  //Draggable forces have blue colour
      this.make(new Point(mouseX, mouseY));
    }
  }

  void make(Point headAt) {   //Make the arrows
    stroke(Line_Color);
    strokeWeight(Force_stroke_thickness);
    if (magnitude >= 0 && this.mouseTrackingMode == false) {  //Pointing upwards
      textFont(Forces_Font);
      textSize(18);
      fill(this.Line_Color);
      textAlign(CENTER, BOTTOM);
      text(this.Name, headAt.X, headAt.Y - beam.Thickness_Left_View / 2 - 5);
      line(headAt.X, headAt.Y, headAt.X - 10 * sin(radians(30)), headAt.Y + 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X + 10 * sin(radians(30)), headAt.Y + 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X, headAt.Y + 50);  
      textFont(Forces_Font);
      textAlign(CENTER, TOP);
      textSize(12);
      text(this.displayForceMagnitude(), headAt.X, headAt.Y + 55);
    } else if ((magnitude < 0) || this.mouseTrackingMode == true) {  //Pointing downwards
      textFont(Forces_Font);
      textSize(18);
      fill(this.Line_Color);
      textAlign(CENTER, TOP);
      text(this.Name, headAt.X, headAt.Y + beam.Thickness_Left_View / 2 + 5);
      line(headAt.X, headAt.Y, headAt.X - 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X + 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
      line(headAt.X, headAt.Y, headAt.X, headAt.Y - 50); 
      textFont(Forces_Font);
      textAlign(CENTER, BOTTOM);
      textSize(12);
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
  float Thickness_Left_View_m = 0.10;
  Point center;

  boolean pointInsideBeam(Point point) {
    if (point.X <= center.X + Length/2 && point.X >= center.X - Length/2 && point.Y <= center.Y + Thickness_Left_View/2 && point.Y >= center.Y - Thickness_Left_View/2)
      return true;
    return false;
  }

  void setLength_m(float length_m) {
    Length_m = length_m;
    Length = m_to_pixel(length_m);
    this.centerAt(this.center, true);  //To reset the end supports to calibrate with the beam, but don't change their values
  }

  float Length, Thickness_Left_View;

  //Forces on beam
  Force support_A, support_B;  //A -> Left support, B -> Right support
  ArrayList<Force> loads = new ArrayList<Force>();  //Loads on the beam : In order

  void AttachForce(float Value, float Distance_L_m) {
    Force load = new Force(new Point(this.center.X - this.Length/2 + m_to_pixel(Distance_L_m), this.center.Y), Value);
    load.distance_L = Distance_L_m;
    load.Line_Color = color(0, 0, 255);
    load.Name = "F" + str(loads.size() + removed_loads);
    loads.add(load);
    println("Attaching a force of magnitude " + str(load.magnitude) + " at " + str(load.head.X) + " index : " + str(load.indexOnBeam));
    this.calculateReactionForces();
    this.adjustIndexes();
    this.makeGraph_getPoints();
  }

  void adjustIndexes() {
    support_A.indexOnBeam = 0;
    support_B.indexOnBeam = this.loads.size() + 1;  //end forces

    Force[] array_Forces = new Force[this.loads.size()];
    for (int i = 0; i < this.loads.size(); i++) {
      array_Forces[i] = this.loads.get(i);
    }
    //Now, sort with index
    for (int i = 0; i < array_Forces.length - 1; i++) {
      for (int j = 0; j < array_Forces.length - i - 1; j++) {
        if (array_Forces[j].distance_L > array_Forces[j+1].distance_L) {
          Force f = array_Forces[j];
          array_Forces[j] = array_Forces[j+1];
          array_Forces[j+1] = f;
        }
      }
    }
    //Array sorted
    for (int i = 0; i < this.loads.size(); i++) {
      this.loads.remove(i);
      array_Forces[i].indexOnBeam = i + 1;
      this.loads.add(i, array_Forces[i]);
    }
    for (Force f : this.loads) {
      println(str(f.magnitude) + " at " + str(f.indexOnBeam));
    }
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
    this.Thickness_Left_View_m = Thickness_m;
    Length = m_to_pixel(Length_m);
    Thickness_Left_View = m_to_pixel(Thickness_m);
    this.centerAt(center);
  }
  //center the beam
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
      support_A.indexOnBeam = 0;
      support_B.indexOnBeam = 1;
      println("The center is " + str(this.center.X));
    }
  }

  boolean mouseTrackingMode = false;

  color fill_color = color(0);
  color stroke_color = color(0);
  float stroke_thickness = 2;

  //draw the beam
  void draw_beam() {
    if (this.mouseTrackingMode) {  //Mouse holding the beam
      this.centerAt(new Point(mouseX, mouseY), true);  //Previous data exists
    }
    stroke(stroke_color);
    strokeWeight(stroke_thickness);
    fill(fill_color);
    rectMode(CENTER);
    rect(center.X, center.Y, Length, Thickness_Left_View);  //The beam thickness
    for (Force load : loads) {
      load.make(this.center, this.Length_m, load.distance_L);  //Make the loads
    }
    support_A.make();
    support_B.make();
  }

  //Bending moments and graph
  ArrayList<Float> Bending_Moments = new ArrayList<Float>();
  float MaximumBendingMomentInBeam = Float.MIN_VALUE;
  float MinimumBendingMomentInBeam = Float.MAX_VALUE;
  //Get bending moments
  float makeGraph_getPoints() {
    float MaxBendingMoment = Float.MIN_VALUE;
    Bending_Moments = new ArrayList<Float>();
    this.Bending_Moments.add(0.0);
    for (int i = 0; i < this.loads.size(); i++) {
      Force F = this.loads.get(i);  //The force we're on
      float moment = this.support_A.magnitude * F.distance_L;
      for (int j = 0; j < i; j++) {
        moment = moment + (this.loads.get(j).magnitude * (F.distance_L - this.loads.get(j).distance_L));
      }
      println("At " + str(i + 1) + ", the moment is " + moment);
      if (MaxBendingMoment <= moment) {
        MaxBendingMoment = moment;
      }
      if (MinimumBendingMomentInBeam >= moment) {
        MinimumBendingMomentInBeam = moment;
      }
      this.Bending_Moments.add(moment);
    }
    this.Bending_Moments.add(0.0);
    MaximumBendingMomentInBeam = MaxBendingMoment;
    println("Maximum BM : " + str(MaximumBendingMomentInBeam) + " Minimum BM : " + str(MinimumBendingMomentInBeam));
    return MaxBendingMoment;
  }
  //Make the graph
  void makeGraph() {  //To make a graph about the bending moment
    makeGraph(new Point(width/2, height/2));
  }  
  void makeGraph(Point graphCenter) {
    makeGraph(graphCenter, this.Length + 60, 350);
  }
  void makeGraph(Point graphCenter, float graphLength, float graphHeight) {
    stroke(#00641D);
    strokeWeight(4);
    line(this.support_A.head.X - 2, graphCenter.Y - graphHeight/2, this.support_A.head.X - 2, graphCenter.Y + graphHeight/2);  //The dark green line  
    stroke(#62FF8F);
    strokeWeight(1);
    for (float X = this.center.X - this.Length/2; X <= graphCenter.X + graphLength/2; X += this.Length/20) {
      line(X, graphCenter.Y - graphHeight/2, X, graphCenter.Y + graphHeight/2);  //The light green ones - Horizontal lines
    }
    stroke(127, 127, 127);
    strokeWeight(0.5);
    textFont(Grapher_text_font);
    textSize(15);
    textAlign(LEFT, BOTTOM);
    line(this.support_A.head.X, this.support_B.head.Y, this.support_A.head.X, graphCenter.Y + graphHeight/2);  //Support lines
    text(this.support_A.Name, this.support_A.head.X, graphCenter.Y);
    line(this.support_B.head.X, this.support_B.head.Y, this.support_B.head.X, graphCenter.Y + graphHeight/2);  //Support lines
    text(this.support_B.Name, this.support_B.head.X, graphCenter.Y);
    for (Force f : this.loads) {
      line(f.head.X, this.center.Y, f.head.X, graphCenter.Y + graphHeight/2);  //Force lines
      textAlign(LEFT, BOTTOM);
      text(f.Name, f.head.X, graphCenter.Y);
      textAlign(CENTER, TOP);
      text(str(Math.round(f.distance_L * 100)/100.0) + "L\n" + str(Math.round((this.Length_m - f.distance_L) * 100)/100.0) + "R", f.head.X, graphCenter.Y + 5);  //Info about the load
    }//Forces and vertical lines
    rectMode(CENTER);
    stroke(0);
    strokeWeight(1.5);
    line(graphCenter.X - graphLength/2, graphCenter.Y, graphCenter.X + graphLength/2, graphCenter.Y);
    noFill();
    strokeWeight(2);
    rect(graphCenter.X, graphCenter.Y, graphLength, graphHeight);  //Frame rectangle
    if (this.loads.size() >= 1) {
      float Scale_Yaxis = 0;  //These many pixels = 1 Nm bending moment
      if (-MinimumBendingMomentInBeam < MaximumBendingMomentInBeam) {
        Scale_Yaxis = graphHeight/2 * 0.9/MaximumBendingMomentInBeam;
      } else {
        Scale_Yaxis = -graphHeight/2 * 0.9/MinimumBendingMomentInBeam;  //- because MinimumBendingMomentInBeam is negative
      }
      strokeWeight(0.2);
      stroke(123, 123, 123);
      for (float y = graphCenter.Y - 0.9*graphHeight/2; y <= graphCenter.Y + 0.9*graphHeight/2; y += MaximumBendingMomentInBeam / 10 * Scale_Yaxis) {
        line(graphCenter.X - graphLength/2, y, graphCenter.X + graphLength/2, y);
      }  //Horizontal lines
      textSize(10);
      textFont(Grapher_text_font);
      textAlign(LEFT,TOP);
      String str = "SCALE :-\nX axis - 1 unit = " + str(this.Length_m/20) + " meters\nY axis - 1 unit = " + getStringFormat_BendingMoment(Math.max(MaximumBendingMomentInBeam,-MinimumBendingMomentInBeam) / 10.0);
      text(str, graphCenter.X + graphLength/2 - textWidth(str), graphCenter.Y + graphHeight/2 + 10);
      stroke(0);
      strokeWeight(1.5);
      textAlign(RIGHT, BOTTOM);
      textSize(15);
      fill(#FF0000);
      //Making the lines
      for (Force F : this.loads) {
        if (F.indexOnBeam == 1) {  //Starting
          line(this.center.X - this.Length/2, graphCenter.Y, this.center.X - this.Length/2 + m_to_pixel(F.distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam) * Scale_Yaxis);
          if (this.loads.size() == 1) {  //Only 1 load
            line(this.center.X - this.Length/2 + m_to_pixel(F.distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam) * Scale_Yaxis, this.center.X + this.Length/2, graphCenter.Y);
          }
        } else if (F.indexOnBeam == this.loads.size()) {  //ending
          if (this.loads.size() > 1) {
            line(this.center.X - this.Length/2 + m_to_pixel(F.distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam) * Scale_Yaxis, 
              this.center.X - this.Length/2 + m_to_pixel(loads.get(F.indexOnBeam-1-1).distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam - 1) * Scale_Yaxis);  //this to previous
          }
          line(this.center.X - this.Length/2 + m_to_pixel(F.distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam) * Scale_Yaxis, this.center.X + this.Length/2, graphCenter.Y);
        } else {  //middle
          line(this.center.X - this.Length/2 + m_to_pixel(F.distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam) * Scale_Yaxis, 
            this.center.X - this.Length/2 + m_to_pixel(loads.get(F.indexOnBeam-1-1).distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam - 1) * Scale_Yaxis);
        }
        ellipse(this.center.X - this.Length/2 + m_to_pixel(F.distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam) * Scale_Yaxis, 2, 2);
        //Write the bending moments on the graph
        text(getStringFormat_BendingMoment(Bending_Moments.get(F.indexOnBeam)), this.center.X - this.Length/2 + m_to_pixel(F.distance_L), graphCenter.Y - Bending_Moments.get(F.indexOnBeam) * Scale_Yaxis);
      }
      
    }
  }

  //Material of the beam
  Material material;
  float SectionModulus;  
  //Factor of safety in the beam
  float Factor_of_Safety = 1;
  void setFOS(float value) {
    Factor_of_Safety = value;
  }
  void calculateSectionModulous() {
    this.SectionModulus = (this.MaximumBendingMomentInBeam * this.Factor_of_Safety / this.material.Max_Stress);
  }


  //Description of a beam
  String description() {
    String des = "";
    this.calculateSectionModulous();
    des = "Beam Length : " + this.Length_m + " m\n" + 
      "Beam Thickness (in left view) : " + this.Thickness_Left_View_m + " m\n" +
      "Beam Material : \"" + this.material.Name + "\" (Maximum stress = " + String.format("%.3E", material.Max_Stress) + " N/m^2)\n" +
      "The maximum bending moment in beam is : " + getStringFormat_BendingMoment(this.MaximumBendingMomentInBeam) + " \n" + 

      "The Section Modulus required is : " + String.format("%.2E", this.SectionModulus) + " m^3" + 
      "In order to obtain this section modulus," + "\n " + 
      "The width of the beam must be " + 6.0 * this.SectionModulus / (Math.pow(this.Thickness_Left_View_m,2)) + " m (rectangular cross section).\n" +
      "\n";
    return des;
  }
}

String getStringFormat_BendingMoment(float number) {
  String return_string = "";
  if (number >= 100) {
    number /= 1000;
    return_string += str(Math.round(number * 100)/100.0) + "kNm";
  } else {
    return_string += str(Math.round(number * 10)/10.0) + "Nm";
  }

  return return_string;
}

//Takes care of all the maths and fuzz about the beam
class BeamSpecifications {
  Material material;
  float SectionModulus = 0;
}

class Material {
  String Name;
  float Max_Stress;
  Material(String name, float Max_stress) {
    this.Name = name;
    this.Max_Stress = Max_stress;
  }
  String description_String() {
    return "Name : " + this.Name + " Max Stress : " +   String.format("%.3E", this.Max_Stress) + " N/m^2";
  }
}

ArrayList<Material> Materials_list;

//Material List needed
void loadMaterials() {
  Table material_table;
  Materials_list = new ArrayList<Material>();
  material_table = loadTable("Materials/Material Data.csv", "header");  //CSV file here
  println("File has " + str(material_table.lastRowIndex()) + " indexes");

  for (int i = 0; i <= material_table.lastRowIndex(); i++) {
    TableRow row = material_table.getRow(i);
    Material m = new Material(row.getString(0), row.getFloat(1));
    Materials_list.add(m);
  }
  for (Material m : Materials_list) {
    println(m.Name + ": " + str(m.Max_Stress));
  }
  beam.material = Materials_list.get(0);  //The first row is the default material
}