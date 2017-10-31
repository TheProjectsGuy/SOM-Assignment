/*
*   CURRENT_SCREEN = "Bending Moment Screen"
 * Views : Loading View; Grapher View
 */
Beam beam;

boolean dragging_forces = false;
Force force_drag = new Force();

PImage BMA_done;
PImage Analyze_beam_icon;

void Bending_Moment_Screen_navigator() {
  background(255, 255, 255);
  if (!dragging_forces && beam.loads.size() == 0)
    terminal.placeholder_text = "Drag and drop forces";
  else if (beam.loads.size() == 0) {
    terminal.placeholder_text = "Force grabbed";
  }
  Bending_Moment_Screen_essential_buttons();
  switch (CURRENT_VIEW) {
  case "Loading View":
    Starting_screen_BMA();  //Loading the beam and information. Also, user adds the loads here
    break;
  case "Grapher View":  //The graph is shown here
    Starting_screen_with_grapher();
    break;
  case "Beam Information":  //Beam information shown here
    Beam_Information_Screen();
    break;
  }
}
Point headAt;

void load_drag_drop_arrows() {
  stroke(0, 0, 255);
  strokeWeight(2);
  //Arrow pointing down  
  line(headAt.X, headAt.Y, headAt.X, headAt.Y - 50);   //Head at width - 10, height/2 - 10
  line(headAt.X, headAt.Y, headAt.X - 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
  line(headAt.X, headAt.Y, headAt.X + 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
  stroke(0);
  noFill();
  strokeWeight(1);
  rectMode(CORNERS);  //width - 40, height/3 --- headAt by default, I don't want anything to move
  rect(headAt.X - 15, headAt.Y - 50 - 10, headAt.X + 15, headAt.Y + 10);
}

PFont placerFont;

void Starting_screen_BMA() {
  
  textFont(Grapher_text_font,15);
  fill(255,0,0);
  textAlign(CENTER,TOP);
  text(beam.material.description_String(),width/2,0);
  beam.draw_beam();
  load_drag_drop_arrows();
  if (mouseX <= headAt.X + 15 && mouseX >= headAt.X - 15 && mouseY <= headAt.Y + 10 && mouseY >= headAt.Y - 50 - 10 && mousePressed && !mouseHolding) {  //If user click inside the rect
    dragging_forces = true;
    mouseHolding = true;
  }
  if (dragging_forces) {  //Make adjusters
    force_drag.mouseTrackingMode = true;
    force_drag.make();  //Dragging the force
    //making the adjusters
    stroke(0);
    strokeWeight(0.5);
    line(beam.center.X - beam.Length/2, beam.center.Y, beam.center.X - beam.Length/2, beam.center.Y - beam.Thickness_Left_View * 2);  //Left extreme
    line(beam.center.X - beam.Length/2, beam.center.Y - beam.Thickness_Left_View * 5/4, constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness_Left_View * 5/4);  //The -
    line(constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y, constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness_Left_View*2);  //Middle line
    line(constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness_Left_View * 5/4, beam.center.X + beam.Length/2, beam.center.Y - beam.Thickness_Left_View * 5/4);   //The -
    line(beam.center.X + beam.Length/2, beam.center.Y, beam.center.X + beam.Length/2, beam.center.Y - beam.Thickness_Left_View * 2);  //Right extreme
    rectMode(CENTER);
    stroke(0.1);
    strokeWeight(0.1);
    fill(255);
    rect(((beam.center.X - beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2, beam.center.Y - beam.Thickness_Left_View * 5/4, textWidth(str(pixelX_to_mL_on_beam(mouseX))) + 40, (5/4-7/8) * beam.Thickness_Left_View);
    rect(((beam.center.X + beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2, beam.center.Y - beam.Thickness_Left_View * 5/4, textWidth(str(beam.Length_m - pixelX_to_mL_on_beam(mouseX))) + 40, (5/4-7/8) * beam.Thickness_Left_View);
    textAlign(CENTER, CENTER);
    textFont(placerFont);
    textSize(18);
    fill(0);
    text(str(pixelX_to_mL_on_beam(mouseX)), ((beam.center.X - beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2, beam.center.Y - beam.Thickness_Left_View * 5/4);
    text(str(beam.Length_m - pixelX_to_mL_on_beam(mouseX)), ((beam.center.X + beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2, beam.center.Y - beam.Thickness_Left_View * 5/4);
    strokeWeight(2);
    stroke(#6EAAAD);
    ellipse(constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness_Left_View * 5/4, 2, 2);
    //Adjusters made
  }
}

void Starting_screen_with_grapher() {  
  Starting_screen_BMA();
  //if (beam.pointInsideBeam(new Point(mouseX, mouseY)) && mousePressed && !mouseHolding) {  //If user clicks the beam, he can drag it using this : Drag and drop Beam
  //  beam.mouseTrackingMode = true;
  //  mouseHolding = true;
  //}
  beam.makeGraph(); //Heavy graphing is done here
}

PFont BMA_Info_Font;

void Beam_Information_Screen() {
  beam.draw_beam();
  stroke(127);
  strokeWeight(5);
  ellipse(beam.center.X - beam.Length/2, height/6 + 70, 3, 3);
  ellipse(beam.center.X + beam.Length/2, height/6 + 70, 3, 3);
  strokeWeight(0.25);
  stroke(100);
  line(beam.center.X - beam.Length/2, height/6 + 70, beam.center.X + beam.Length/2, height/6 + 70);
  fill(0);
  textAlign(CENTER,CENTER);
  textFont(BMA_Info_Font);
  textSize(13);
  text(str(beam.Length_m) + " m", beam.center.X, height/6 + 70);
  textSize(20);
  textLeading(25);
  text(beam.description(),width/2,height/2);
  stroke(0);
  strokeWeight(3);
  noFill();
  rectMode(CENTER);
  rect(width/2, height/2 + 55, width * 4/5, height * 2/3);
}

//Buttons essential to this screen only
void Bending_Moment_Screen_essential_buttons() {  
  if (CURRENT_VIEW != "Beam Information") {
    imageMode(CENTER);
    image(BMA_done, width - 72, height * 3/4, 72, 72);   //Make graph
    if (mouseX <= width - 72 + 72/2 && mouseX >= width - 72 - 72/2 && mouseY <= height * 3/4 + 72/2 && mouseY >= height * 3/4 - 72/2 && mousePressed && !mouseHolding) {
      doTerminalCommand("BEAM.MAKEGRAPH");
    }
  }
  //Info about beam
  imageMode(CORNER);
  image(Analyze_beam_icon, 0, beam.center.Y + beam.Thickness_Left_View / 2 + 20, 60, 60);
  if (mouseX < 60 && mouseY >= beam.center.Y + beam.Thickness_Left_View / 2 + 20 && mouseY <= beam.center.Y + beam.Thickness_Left_View / 2 + 20 + 60 && mousePressed && !mouseHolding) {
    doTerminalCommand("beam.info");
  }
}

void mouseReleased_Bending_Moment_Screen() {
  if (beam.mouseTrackingMode)
    beam.mouseTrackingMode = false;
  mouseHolding = false;
  if (force_drag.mouseTrackingMode) {  //If you were holding a force and dragging it with the cursor
    force_drag.mouseTrackingMode = false;
    dragging_forces = false;
    float distForce_L = pixelX_to_mL_on_beam(mouseX);
    doTerminalCommand("NewLoad("+ str(force_drag.magnitude) + "," + str(distForce_L) + "L)");
    terminal.text = "";
    terminal.placeholder_text = "Enter specifics about the load F" + str(beam.loads.size() - 1) + ": Load.F" + str(beam.loads.size() - 1) + ".setTo(<Value>,<Distance>)";
    //Development needed here
  }
}