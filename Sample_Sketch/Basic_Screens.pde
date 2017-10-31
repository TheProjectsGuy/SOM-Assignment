/*
 *This module consists of the following UIScreens
 ****Introduction Screen
 ****User Error Handling Screen
 */
PFont Baisc_Screens_LoadingFont;

//Introduction Screen
void Introduction_screen_navigator() {  
  switch (CURRENT_VIEW) {
  case "Home":
    Startup_Screen();
    break;
    //Info and Help pending...
  case "Help":
    HelpScreen();
    break;
  case "Introduction":
    Intro_Screen();
    break;
  default:
    Error_screen_navigator();
    break;
  }
}

PImage dev_Icon;
void HelpScreen() {
  
  background(255);
  imageMode(CENTER);
  image(dev_Icon, width/2, height/2);
}

PImage HelpImage;
void Intro_Screen() {
  background(255);
  imageMode(CENTER);
  image(HelpImage, width/2, height/2);
}

//The first option to segue to BMA
PImage BMA_icon, Beam_Properties;

int i = 255, MODE = 1;  //For background colour to adjust
void Startup_Screen() {
  background(i, i, i);  //Background colour
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
  //Option : Bending Moment Analysis : Goes to the Introduction
  imageMode(CENTER);
  image(BMA_icon, width/2, height * 0.30);  //Unhovered
  if (mouseX <= BMA_icon.width / 2 + width/2 && mouseX >= width/2 - BMA_icon.width/2 && mouseY <= BMA_icon.height / 2 + height * 0.30 && mouseY >= height * 0.30 - BMA_icon.height/2) {
    if (!mousePressed)
      BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_hovered.png");
    if (mousePressed) {
      BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_clicked.png");
      doTerminalCommand("SCREEN.BMA");
    }
  } else {
    BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_unhovered.png");
  }
  //Beam Properties button
  if (mouseX <= width/2 + 208 * 1.5/2 && mouseX >= width/2 - 208 * 1.5/2 && mouseY <= height * 0.60 + 54 * 1.5/2 && mouseY >= height * 0.60 - 54 * 1.5/2) { 
    Beam_Properties = loadImage("data/Buttons/Beam Analysis/Beam Properties_hovered.png");
    if (mousePressed && !mouseHolding) {
      doTerminalCommand("SCREEN.BEAMPROPERTIES");
    }
  } else {
    Beam_Properties = loadImage("data/Buttons/Beam Analysis/Beam Properties_unhovered.png");
  }
  imageMode(CENTER);
  image(Beam_Properties, width/2, height * 0.60, 208 * 1.5, 54 * 1.5);
}


//Error Screen

PImage Error_icon_ESN;
PFont Error_MessageFont;

void Error_screen_navigator() {
  background(0);
  imageMode(CENTER);
  image(Error_icon_ESN, width/2, height/4, 400, 400);
  textFont(Error_MessageFont);
  textSize(50);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Error", width/2, height/2);
  text("Page not found", width/2, height * 3/4);
}