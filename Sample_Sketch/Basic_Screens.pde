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
  fill(0,0,255);
  textAlign(CENTER,CENTER);
  textFont(Baisc_Screens_LoadingFont,90);
  text("Bending Moment Software",width/2,height/10);
  delay(10);
  
}

void Error_screen_navigator() {
  
}