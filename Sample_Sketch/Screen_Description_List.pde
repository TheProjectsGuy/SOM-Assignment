/*
Problem statement
 Write a program to compute the maximum bending moment for a simply supported beam carrying multiple point loads at different points. Allow the operator to input the loads.
 Also,
 a) Calcuate max. bending moment and req. section modulous for the cross section of beam to limit the maximum bending stress to a given level (material table given)
 b) Recommend shapes
 c) Plot graph over length
 */

/*
Screen and View List is 
 1) Introduction Screen (in Basic_Screens) [Introduction_screen_navigator].
 *Consists the basic screens
 - Startup_Screen()
 2) Error Screen (in Basic_Screens) [Error_screen_navigator]
 *Consists the Error Handling screens
 - Error_page_not_found()
 
 
 */

PFont UITextField_TextFont;

void doTerminalCommand() {
  doTerminalCommand(terminal.text);
}

void doTerminalCommand(String command) {
  switch(command.toUpperCase()) {
  case "EXIT":
    exit();
    break;
  case "INFO":
    CURRENT_SCREEN = "Introduction Screen";
    CURRENT_VIEW = "Introduction";  //Introduction screen
    break;
  case "HELP":
    CURRENT_SCREEN = "Introduction Screen";
    CURRENT_VIEW = "Help";  //Help Screen
    break;
  case "HOME":
    CURRENT_SCREEN = "Introduction Screen";
    CURRENT_VIEW = "Home";  //Home Screen
    terminal.text = "";
    terminal.text_inTheField = false;
    terminal.placeholder_text = "Terminal Console";
    break;
  case "BEAM.RESET":
    beam = new Beam(new Point(width/2, height/2), 1, 0.01);
    break;
  case "SCREEN.BMA":
    CURRENT_SCREEN = "Bending Moment Screen";
    CURRENT_VIEW = "Loading View";
    break;
  default:
    terminal.text = "";
    break;
  }
}