Force support_A, support_B;
boolean mouseHolding = false;

void setup() {
  fullScreen();
  beam = new Beam(new Point(width/2, height/2), 4, 0.2);
}

void draw() {
  background(255, 255, 255);
  beam.draw_beam();
  if (beam.pointInsideBeam(new Point(mouseX, mouseY)) && mousePressed && !mouseHolding) {
    beam.mouseTrackingMode = true;
    mouseHolding = true;
  }
}

void mouseReleased() {
  if (beam.mouseTrackingMode)
    beam.mouseTrackingMode = false;
  mouseHolding = false;
}