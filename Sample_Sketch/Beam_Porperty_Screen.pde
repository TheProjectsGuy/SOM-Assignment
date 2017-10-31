void Beam_Property_navigator() {
  background(255);
  switch(CURRENT_VIEW) {
  case "Beam Dimensions":
    Beam_Properties_View();
    break;
  case "Beam Material":
    Beam_Material_View();
    break;
  }
}

PFont BP_Heading_Font;
UITextField BeamLength, BeamThickness, Material_Number;

PImage ChangeMaterialButton;

void Beam_Properties_View() {
  fill(0);
  textAlign(CENTER, TOP);
  textFont(BP_Heading_Font, 35);
  text("Enter beam properties", width/2, 20);

  imageMode(CORNER);
  image(ChangeMaterialButton, width - 200, height * 0.3, 191, 55);
  if (mouseX <= width - 200 + 191 && mouseX >=  width - 200 && mouseY >= height * 0.3 && mouseY <= height * 0.3 + 55 && mousePressed && !mouseHolding) {
    doTerminalCommand("screen.BEAMMATERIAL");
  }

  //Entry fields
  BeamLength.drawItems();
  BeamThickness.drawItems();



  //Draw beam
  beam.centerAt(new Point(width/2, height * 0.8), true);
  beam.draw_beam();
}



void Beam_Material_View() {
  textFont(Grapher_text_font, 20);
  textAlign(CENTER, TOP);
  text("Current material description : " + beam.material.description_String(), width/2, 10); 

  for (int i = 0; i < Materials_list.size(); i++) {  //Item list
    strokeWeight(1);
    stroke(127);
    noFill();
    rectMode(CORNER);
    rect(width * 0.12, 70 + i * 40, 1000, 30); //textWidth

    fill(0);
    textFont(UITextField_TextFont, 17);
    textAlign(LEFT, TOP);
    //text(str(i + 1) + ") " + Materials_list.get(i).Name , width * 0.12 + 6, 70 + i * 40 + 4);
    text(str(i + 1) + ")", width * 0.12 + 6, 70 + i * 40 + 9);
    text(Materials_list.get(i).Name, width * 0.12 + 6 + textWidth("NNN"), 70 + i * 40 + 9);
    textAlign(RIGHT, TOP);
    text(String.format("%.3E", Materials_list.get(i).Max_Stress) + " N/m^2", width * 0.12 + 1000 - 5, 70 + i * 40 + 9);
  }

  Material_Number.drawItems();
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
  } else if (BeamThickness.selected) {
    if (key != ENTER)
      BeamThickness.keyboardManager();
    else {
      doTerminalCommand("BEAM.SETTHICKNESS(" + BeamThickness.text + ")");
      BeamThickness.placeholder_text = "Beam thickness set to " + str(beam.Thickness_Left_View_m) + " m";
      BeamThickness.text = "";
      BeamThickness.text_inTheField = false;
    }
  } else if (Material_Number.selected) {
    if (key != ENTER) {
      Material_Number.keyboardManager();
    } else {
      beam.material = Materials_list.get(int(Material_Number.text) - 1);
      Material_Number.text = "";
      Material_Number.placeholder_text = "Done";
      Material_Number.text_inTheField = false;
    }
  }
}