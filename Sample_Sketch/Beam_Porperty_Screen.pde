void Beam_Property_navigator() {
  background(255);
  switch(CURRENT_VIEW) {
    case "Beam Dimensions":
      Beam_Properties_View();
      break;
      
  }
}

PFont BP_Heading_Font;
UITextField BeamLength, BeamThickness;

void Beam_Properties_View() {
  fill(0);
  textAlign(CENTER, TOP);
  textFont(BP_Heading_Font, 35);
  text("Enter beam properties", width/2, 20);

  BeamLength.drawItems();
  BeamThickness.drawItems();
  
  beam.centerAt(new Point(width/2,height * 0.8), true);
  beam.draw_beam();
}

void Beam_Properties_KeyboardHandler() {
  if (BeamLength.selected) {
    if (key != ENTER)
    BeamLength.keyboardManager();
    else {
      doTerminalCommand("BEAM.SETLENGTH(" + BeamLength.text + ")");
      BeamLength.placeholder_text = "Beam length set to " + str(beam.Length_m) + " m";
      BeamLength.text = "";
      BeamLength.text_inTheField = false;
    }
  } 
  else if (BeamThickness.selected) {
    if (key != ENTER)
    BeamThickness.keyboardManager();
    else {
      doTerminalCommand("BEAM.SETTHICKNESS(" + BeamThickness.text + ")");
      BeamThickness.placeholder_text = "Beam thickness set to " + str(beam.Thickness_Left_View_m) + " m";
      BeamThickness.text = "";
      BeamThickness.text_inTheField = false;
    }
  }
}