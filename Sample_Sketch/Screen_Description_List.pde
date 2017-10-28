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
  command.replaceAll(" ", "");  //No SPACES in Terminal
  command = command.toUpperCase();
  if (command.startsWith("BEAM.")) {  //Beam associated command
    command = command.substring("BEAM.".length());  //Beam function obtained
    println("\"" + command + "\"");
    if (command.equals("RESET")) {
      beam = new Beam(new Point(width/2, height/2), 1, 0.01);
    } else if (command.startsWith("SETLENGTH(")) {
      beam.setLength_m(float(command.substring("setLength(".length(), command.length() - 1)));
      
    }
  } else if (command.startsWith("NewLoad(".toUpperCase())) {  //New load added
    command = command.substring("NewLoad(".length(), command.length() - 1);
    String[] arguments = split(command, ',');
    println(arguments);
    float magnitude, dist_L;
    if (arguments[0].endsWith("kN".toUpperCase())) {
      magnitude = -float(arguments[0].substring(0, arguments[0].length() - 2)) * 1e3;  //Entry in kN
    } else {
      if (arguments[0].endsWith("N")) 
        arguments[0] = arguments[0].substring(0, arguments[0].length() - 1);
      magnitude = -float(arguments[0].substring(0));
    }
    if (arguments[1].endsWith("R")) {
      dist_L = beam.Length_m - float(arguments[1].substring(0, arguments[1].length() - 1));
    } else {
      if (arguments[1].endsWith("L"))
        arguments[1] = arguments[1].substring(0, arguments[1].length() - 1);
      dist_L = float(arguments[1]);
    }
    println(str(magnitude) + " at L : " + dist_L);
    beam.AttachForce(magnitude, dist_L);
  } else {
    switch(command) {
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
      CURRENT_VIEW = "Loading View";  //Show the Bengind Moment screen : Introduction 
      break;
    default:
      terminal.text = "";
      break;
    }
  }
}