/*
  SOM Assignment 3
 
 */

UITextField terminal;

PImage close_icon, info_icon;

String CURRENT_SCREEN = "Introduction Screen";
String CURRENT_VIEW = "Home";
void setup() {
  //Setting up the fonts package
  setup_Fonts();
  attach_images();
  fullScreen();
}

int i = 255, MODE = 1;

void draw() {
  switch (CURRENT_SCREEN) {
  case "Introduction Screen":
    Introduction_screen_navigator();
    break;
  default:
    CURRENT_VIEW = "Broken Link";
    Error_screen_navigator();
    break;
  }
  Make_Essentials();
}