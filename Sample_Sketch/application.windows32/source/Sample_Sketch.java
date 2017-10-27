import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Sample_Sketch extends PApplet {

public void setup() {
  
}

int i = 255, MODE = 1;

public void draw() {
  background(i, i, i);
  if (i >= 255) MODE = -1;
  if (i <= 0) MODE = 1;
  switch(MODE) {
  case 1:
    i++;
    break;
  case -1:
    i--;
    break;
  default:
    break;
  }
  delay(10);
}
  public void settings() {  size(500, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Sample_Sketch" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
