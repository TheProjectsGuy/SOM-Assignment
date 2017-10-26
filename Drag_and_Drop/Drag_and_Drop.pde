PFont LoadingFont;
class Point {
  float X,Y;
  
  Point(float x,float y) {
    this.X = x;
    this.Y = y;
  }
};

int Size = 20;
void setup() {
  size(500,500);
  LoadingFont = loadFont("Bauhaus93-100.vlw");
  textFont(LoadingFont,Size);
  textAlign(CENTER,CENTER);
}

float Width = 1,Angle_Degrees = 30,Length = 25;

void draw() {
  background(0,0,0);
  strokeWeight(2);
  stroke(255);
  //line(width/3,height/2,width*2/3,height/2);
  line(width/2,height/2,width/2 - Length * 2/5 * sin(radians(Angle_Degrees)), height/2 + Length * 2/5 * cos(radians(Angle_Degrees)));
  line(width/2,height/2,width/2 + Length * 2/5 * sin(radians(Angle_Degrees)), height/2 + Length * 2/5 * cos(radians(Angle_Degrees)));
  line(width/2,height/2,width/2,height/2 + Length);
  textAlign(CENTER,BOTTOM);
  text(Angle_Degrees,width/2,height);
}


void keyPressed() {
  if (keyCode == UP) Angle_Degrees++;
  else if (keyCode == DOWN) Angle_Degrees--;
}