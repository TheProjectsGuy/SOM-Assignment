/*
 *This module consists of the following UIScreens
 ****Introduction Screen
 ****User Error Handling Screen
 */
PFont Baisc_Screens_LoadingFont;

void Introduction_screen_navigator() {
  switch (CURRENT_VIEW) {
  case "Home":
    Startup_Screen();
    break;
  }
}

PImage BMA_icon;

void Startup_Screen() {
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
  fill(0, 0, 255);
  textAlign(CENTER, CENTER);
  textFont(Baisc_Screens_LoadingFont, 90);
  text("Bending Moment Software", width/2, height/10);
  delay(10);
  //Startup code loaded
  imageMode(CENTER);
  image(BMA_icon, width/2, height * 0.30);  //Unhovered
  if (mouseX <= BMA_icon.width / 2 + width/2 && mouseX >= width/2 - BMA_icon.width/2 && mouseY <= BMA_icon.height / 2 + height * 0.30 && mouseY >= height * 0.30 - BMA_icon.height/2) {
    if (!mousePressed)
      BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_hovered.png");
    if (mousePressed) {
      BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_clicked.png");
      CURRENT_SCREEN = "Bending Moment Screen";
      CURRENT_VIEW = "Loading View";
    }
  } else {
    BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_unhovered.png");
  }
}

void Error_screen_navigator() {
}