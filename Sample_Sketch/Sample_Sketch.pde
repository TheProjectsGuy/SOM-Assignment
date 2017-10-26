/*
  SOM Assignment 3
  
*/

String CURRENT_SCREEN = "Introduction Screen";
String CURRENT_VIEW = "Home";
void setup() {
  setup_Fonts();
  size(500, 500);
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
}