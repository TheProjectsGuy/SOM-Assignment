Beam beam;

void Bending_Moment_Screen_navigator() {
  if (!mouseHolding)
    terminal.placeholder_text = "Drag and drop forces";
  else
    terminal.text = "Object grabbed";
  switch (CURRENT_VIEW) {
  case "Loading View":
    Starting_screen_BMA();  //Loading the beam and information. Also, user adds the loads here
    break;
  case "Grapher View":
    Starting_screen_with_grapher();
    break;
  }
}

void load_drag_drop_arrows() {
  stroke(0, 0, 255);
  strokeWeight(2);
  //Arrow pointing down
  Point headAt = new Point(width - 40, height/3);
  line(headAt.X, headAt.Y, headAt.X, headAt.Y - 50);   //Head at width - 10, height/2 - 10
  line(headAt.X, headAt.Y, headAt.X - 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
  line(headAt.X, headAt.Y, headAt.X + 10 * sin(radians(30)), headAt.Y - 10 * cos(radians(30)));
  stroke(0);
  noFill();
  strokeWeight(1);
  rectMode(CORNERS);
  rect(headAt.X - 15, headAt.Y - 50 - 10, headAt.X + 15, headAt.Y + 10);
}

void Starting_screen_BMA() {
  background(255, 255, 255);
  beam.draw_beam();
  load_drag_drop_arrows();
}

void Starting_screen_with_grapher() {
  if (beam.pointInsideBeam(new Point(mouseX, mouseY)) && mousePressed && !mouseHolding) {  //If user clicks the beam, he can drag it using this
    beam.mouseTrackingMode = true;
    mouseHolding = true;
  }
}

void mouseReleased_Bending_Moment_Screen() {
  if (beam.mouseTrackingMode)
    beam.mouseTrackingMode = false;
  mouseHolding = false;
}