
Force support_A, support_B;

Beam beam;

void Bending_Moment_Screen_navigator() {
  terminal.clearUITextField();
  terminal.placeholder_text = "Drag and drop forces";
  switch (CURRENT_VIEW) {
    case "Loading View":
      Starting_screen_BMA();
    break;
  }
}

void Starting_screen_BMA() {
  background(255, 255, 255);
  beam.draw_beam();
  if (beam.pointInsideBeam(new Point(mouseX, mouseY)) && mousePressed && !mouseHolding) {
    beam.mouseTrackingMode = true;
    mouseHolding = true;
  }
}

void mouseReleased_Bending_Moment_Screen() {
  if (beam.mouseTrackingMode)
    beam.mouseTrackingMode = false;
  mouseHolding = false;
}