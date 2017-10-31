/*
  SOM Assignment 3
 
 */

UITextField terminal;

String CURRENT_SCREEN = "Introduction Screen";
String CURRENT_VIEW = "Home";  //Starting screen

boolean mouseHolding = false;  //Stores if mouse is holding anything or not

void setup() {
  //Setting up the fonts package
  setup_Fonts();
  attach_images();

  initialize_variables();
  fullScreen();
}



void draw() {
  switch (CURRENT_SCREEN) {
  case "Introduction Screen":
    Introduction_screen_navigator();
    break;
  case "Bending Moment Screen":
    Bending_Moment_Screen_navigator();
    break;
  case "Beam Properties":
    Beam_Property_navigator();
    
    break;
  default:
    CURRENT_VIEW = "Broken Link";
    Error_screen_navigator();
    break;
  }
  Make_Essentials();
}

void mouseReleased() {
  switch(CURRENT_SCREEN) {
  case "Bending Moment Screen":
    mouseReleased_Bending_Moment_Screen();
    break;
  }
}

void keyPressed() {
  if (CURRENT_SCREEN == "Beam Properties") {
    Beam_Properties_KeyboardHandler();
  }
  if (terminal.selected) {
    if (key != ENTER)
      terminal.keyboardManager();
    else {
      try {
        doTerminalCommand(terminal.text);
      } 
      catch (Exception e) {
        println("ERROR");
      }
      finally {
        terminal.text = "";
        terminal.placeholder_text = "Terminal Console";
      }
    }
  } else if (key == 'T' || key == 't') {
    terminal.selected = true;
    terminal.text_inTheField = true;
  }
  //}  else if (key == 's') {
  //  doTerminalCommand("NewLoad(25,2L)");
  //} else if (key == 'a') {
  //  beam.AttachForce(-12.5, 1);
  //}
}