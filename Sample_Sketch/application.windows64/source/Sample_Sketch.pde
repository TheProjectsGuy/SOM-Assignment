void setup() {
  size(500, 500);
}

int i = 255, MODE = 1;

void draw() {
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