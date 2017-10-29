Beam beam;

boolean dragging_forces = false;
Force force_drag = new Force();

PImage BMA_done;

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
  case "Grapher View":
    Starting_screen_with_grapher();
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
    line(beam.center.X - beam.Length/2, beam.center.Y, beam.center.X - beam.Length/2, beam.center.Y - beam.Thickness * 2);  //Left extreme
    line(beam.center.X - beam.Length/2, beam.center.Y - beam.Thickness * 5/4, constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness * 5/4);  //The -
    line(constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y, constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness*2);  //Middle line
    line(constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness * 5/4, beam.center.X + beam.Length/2, beam.center.Y - beam.Thickness * 5/4);   //The -
    line(beam.center.X + beam.Length/2, beam.center.Y, beam.center.X + beam.Length/2, beam.center.Y - beam.Thickness * 2);  //Right extreme
    rectMode(CENTER);
    stroke(0.1);
    strokeWeight(0.1);
    fill(255);
    rect(((beam.center.X - beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2,beam.center.Y - beam.Thickness * 5/4, textWidth(str(pixelX_to_mL_on_beam(mouseX))) + 40 ,(5/4-7/8) * beam.Thickness);
    rect(((beam.center.X + beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2,beam.center.Y - beam.Thickness * 5/4, textWidth(str(beam.Length_m - pixelX_to_mL_on_beam(mouseX))) + 40 ,(5/4-7/8) * beam.Thickness);
    textAlign(CENTER,CENTER);
    textFont(placerFont);
    textSize(18);
    fill(0);
    text(str(pixelX_to_mL_on_beam(mouseX)), ((beam.center.X - beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2, beam.center.Y - beam.Thickness * 5/4);
    text(str(beam.Length_m - pixelX_to_mL_on_beam(mouseX)), ((beam.center.X + beam.Length/2) + (constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2)))/2, beam.center.Y - beam.Thickness * 5/4);
    strokeWeight(2);
    stroke(#6EAAAD);
    ellipse(constrain(mouseX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2), beam.center.Y - beam.Thickness * 5/4, 2, 2);
    //Adjusters made
  }
}

void Starting_screen_with_grapher() {  
  Starting_screen_BMA();
  if (beam.pointInsideBeam(new Point(mouseX, mouseY)) && mousePressed && !mouseHolding) {  //If user clicks the beam, he can drag it using this : Drag and drop Beam
    beam.mouseTrackingMode = true;
    mouseHolding = true;
  }
  beam.makeGraph(); //Heavy graphing is done here
}

void Bending_Moment_Screen_essential_buttons() {
  imageMode(CENTER);
  image(BMA_done, width - 72, height * 3/4, 72, 72);
  if (mouseX <= width - 72 + 72/2 && mouseX >= width - 72 - 72/2 && mouseY <= height * 3/4 + 72/2 && mouseY >= height * 3/4 - 72/2 && mousePressed && !mouseHolding) {
    doTerminalCommand("BEAM.MAKEGRAPH");
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