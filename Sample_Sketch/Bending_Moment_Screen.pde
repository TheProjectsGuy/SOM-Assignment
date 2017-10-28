Beam beam;

boolean dragging_forces = false;
Force force_drag = new Force();

void Bending_Moment_Screen_navigator() {
  if (!dragging_forces && beam.loads.size() == 0)
    terminal.placeholder_text = "Drag and drop forces";
  else if (beam.loads.size() == 0) {
    terminal.text = "Force grabbed";
  }
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

void Starting_screen_BMA() {
  background(255, 255, 255);
  beam.draw_beam();
  load_drag_drop_arrows();
  if (mouseX <= headAt.X + 15 && mouseX >= headAt.X - 15 && mouseY <= headAt.Y + 10 && mouseY >= headAt.Y - 50 - 10 && mousePressed && !mouseHolding) {  //If user click inside the rect
    dragging_forces = true;
    mouseHolding = true;
  }
  if (dragging_forces) {
    force_drag.mouseTrackingMode = true;
    force_drag.make();
  }
}

void Starting_screen_with_grapher() {  
  if (beam.pointInsideBeam(new Point(mouseX, mouseY)) && mousePressed && !mouseHolding) {  //If user clicks the beam, he can drag it using this : Drag and drop Beam
    beam.mouseTrackingMode = true;
    mouseHolding = true;
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
    doTerminalCommand("NewLoad(10kN," + str(distForce_L) + "L)");
    terminal.text = "";
    terminal.placeholder_text = "Enter distance from left (default) or right (Eg : 1L or 2R)";
    //Development needed here
  }
}