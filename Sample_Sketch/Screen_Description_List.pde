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
  if (command.startsWith("BEAM.")) {  
    //Beam associated command
    command = command.substring("BEAM.".length());  //Beam function obtained
    println("\"" + command + "\"");
    if (command.equals("RESET")) {  //reset :-> Beam.reset
      beam = new Beam(new Point(width/2, height/2), 4, 0.1);
      beam.material = Materials_list.get(0);
      doTerminalCommand("SCREEN.BMA");
    } else if (command.equals("INFO")) {  // :-> Beam.info
      CURRENT_SCREEN = "Bending Moment Screen";
      CURRENT_VIEW = "Beam Information";
      beam.centerAt(new Point(width/2, height/9), true);
    } else if (command.startsWith("SETLENGTH(")) {  //Setlength :-> Beam.SetLength(%NUMBER%)
      beam.setLength_m(float(command.substring("setLength(".length(), command.length() - 1)));
    } else if (command.startsWith("CLEAR")) {  //:-> Beam.clear
      beam.loads.clear();
      beam.calculateReactionForces();
      doTerminalCommand("SCREEN.BMA");
    } else if (command.startsWith("MAKEGRAPH")) {  //Make the graph :-> Beam.MakeGraph
      CURRENT_SCREEN = "Bending Moment Screen";
      CURRENT_VIEW = "Grapher View";
      beam.centerAt(new Point(width/2, height/6), true);  //Previous data exists
      println(beam.makeGraph_getPoints());
      beam.makeGraph();
    } else if (command.startsWith("SETTHICKNESS(")) {  //:-> BEAM.SETTHICKNESS(%NUMBER%)
      beam.Thickness_Left_View_m = float(command.substring("setThickness(".length(), command.length() - 1));
      beam.Thickness_Left_View = m_to_pixel(beam.Thickness_Left_View_m);
    }
  } else if (command.startsWith("NewLoad(".toUpperCase())) {  //:-> NewLoad(%NUMBER% <N*/kN>, %Distance_m% <L*/R>)  
    //New load added
    command = command.substring("NewLoad(".length(), command.length() - 1);
    //Now, we have %NUMBER% <N*/kN>, %Distance_m% <L*/R>
    String[] arguments = split(command, ',');
    //println(arguments);  
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
    if (magnitude > 0) {
      return;
    }
    beam.AttachForce(magnitude, dist_L);
    beam.adjustIndexes();
    beam.makeGraph_getPoints();
  } else if (command.startsWith("load".toUpperCase())) {   
    //Adjust loads
    //:-> LOAD.<NAME>.setTo(%NUMBER% <N*/kN>, %Distance_m% <L*/R>)
    if (command.startsWith("loads".toUpperCase())) {  //Write LOADS. or LOAD. It's the same
      command.replaceFirst("LOADS", "LOAD");
    }
    command = command.substring("LOAD.".length());
    String forceName = command.substring(0, command.indexOf("."));
    int replacing_index = 0;
    Force F_compare;
    for (int index = 0; index < beam.loads.size(); index++) {
      F_compare = beam.loads.get(index);
      if (forceName.equals(F_compare.Name)) {
        replacing_index = index;  //Found the name
        break;
      }
    }
    command = command.substring(forceName.length() + 1);  //<Function>(<Parameters>)
    if (command.startsWith("setTo(".toUpperCase())) {    //:-> loads.<Name>.setTo(Parameters)
      command = command.substring("setTo(".length(), command.length() - 1);
      //We have %NUMBER% <N*/kN>, %Distance_m% <L*/R>
      F_compare = beam.loads.get(replacing_index);  //We have the force whose properties are to be replaced here
      String[] arguments = split(command, ',');
      float magnitude, dist_L;
      if (arguments.length == 2) {
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
      } else {
        if (arguments[0].endsWith("kN".toUpperCase())) {  
          magnitude = -float(arguments[0].substring(0, arguments[0].length() - 2)) * 1e3;  //Entry in kN
        } else {
          if (arguments[0].endsWith("N")) 
            arguments[0] = arguments[0].substring(0, arguments[0].length() - 1);
          magnitude = -float(arguments[0].substring(0));
        }
        dist_L = F_compare.distance_L;
      }
      F_compare.magnitude = magnitude;
      F_compare.distance_L(dist_L);
      beam.loads.remove(replacing_index);
      beam.loads.add(replacing_index, F_compare);
      beam.calculateReactionForces();
      beam.makeGraph_getPoints();
      beam.adjustIndexes();
    } else if (command.startsWith("remove".toUpperCase())) {  //:-> load.<NAME>.remove
      beam.loads.remove(replacing_index);
      beam.adjustIndexes();
      beam.calculateReactionForces();
      beam.makeGraph_getPoints();
      removed_loads++;
      println("Removed " + forceName);
    }
  } else if (command.startsWith("SCREEN.")) {  //:-> SCREEN.%SCREEN%
    //Screen segue
    command = command.substring("SCREEN.".length());  
    switch(command) {
    case "BMA":        //:-> SCREEN.BMA
      CURRENT_SCREEN = "Bending Moment Screen";
      CURRENT_VIEW = "Loading View";  //Show the Bengind Moment screen : Introduction 
      beam.centerAt(new Point(width/2, height/2), true);
      break;
    case "BEAMPROPERTIES":
      CURRENT_SCREEN = "Beam Properties";
      CURRENT_VIEW = "Beam Dimensions";
      break;
      case "BEAMMATERIAL":
      CURRENT_SCREEN = "Beam Properties";
      CURRENT_VIEW = "Beam Material";
      break;
    default:
      terminal.text = "";
      CURRENT_SCREEN = "Introduction Screen";
      CURRENT_VIEW = "Broken Link";
    }
  } else {
    switch(command) {
    case "EXIT":  //:-> EXIT
      //Do resetting things here
      exit();
      break;
    case "INFO":  //:-> INFO
      CURRENT_SCREEN = "Introduction Screen";
      CURRENT_VIEW = "Introduction";  //Introduction screen
      break;
    case "HELP":  //:-> HELP
      CURRENT_SCREEN = "Introduction Screen";
      CURRENT_VIEW = "Help";  //Help Screen
      break;
    case "HOME":  //:-> HOME
      CURRENT_SCREEN = "Introduction Screen";
      CURRENT_VIEW = "Home";  //Home Screen  
      terminal.text = "";
      terminal.text_inTheField = false;
      terminal.placeholder_text = "Terminal Console";
      break;
    default:
      terminal.text = "";
      terminal.text_inTheField = false;
      terminal.placeholder_text = "Terminal Console";
      break;
    }
  }
}