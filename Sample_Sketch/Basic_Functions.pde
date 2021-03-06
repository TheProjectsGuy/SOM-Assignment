PFont Grapher_text_font;
void setup_Fonts() {  //Font setup module
  Baisc_Screens_LoadingFont = loadFont("AgencyFB-Bold-100.vlw");
  //Forces_Font = loadFont("Arial-BoldMT-50.vlw");  
  Forces_Font = loadFont("Corbel-Bold-30.vlw");
  UITextField_TextFont = loadFont("CenturyGothic-30.vlw");
  Error_MessageFont = loadFont("Constantia-Bold-100.vlw");
  placerFont = loadFont("Consolas-20.vlw");
  //Grapher_text_font = loadFont("Garamond-20.vlw");
  Grapher_text_font = loadFont("Gadugi-Bold-20.vlw");
  //Info Screen font
  BMA_Info_Font = loadFont("ArialMT-32.vlw");
  //Beam Properties Heading font
  BP_Heading_Font = loadFont("BankGothicBT-Medium-48.vlw");
}

PImage close_icon, info_icon, help_icon, home_icon, terminal_clear_icon;

void attach_images() {  //Attach Images
  close_icon = loadImage("data/close.png");
  info_icon = loadImage("data/info.png");
  help_icon = loadImage("data/help.png");
  home_icon = loadImage("data/home.png");
  terminal_clear_icon = loadImage("data/clearTerminal.png");
  HelpImage = loadImage("data/Terminal_Commands.png");
  //Buttons on startup screen
  BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_unhovered.png");

  //Error Screen Navigator Error Icon
  Error_icon_ESN = loadImage("data/error.png");
  
  dev_Icon = loadImage("data/about_dev.jpg");

  //Bending Moment Analysis Screen
  BMA_done = loadImage("data/Buttons/Bending Moment Analysis/showGraph.png");
  
  //Analyze beam
  Analyze_beam_icon = loadImage("data/Buttons/Bending Moment Analysis/beamInfo.png");
  
  //Change Material Button
  ChangeMaterialButton = loadImage("data/Buttons/Beam Analysis/ChangeMaterial.png");
}

void Make_Essentials() {  //Essential Buttons
  imageMode(CORNER);
  CloseButtonEssential();  //CLOSE Button
  
  if (CURRENT_SCREEN == "Introduction Screen" && CURRENT_VIEW == "Home") {
    HelpButtongEssential();  //Help Button
    InfoButtonEssential();  //Info Button
  } else {
    HomeButtonEssential();  //Home Button
  }

  TerminalEssential();  //Terminal Button
}

void HomeButtonEssential() {  //Essential : Home button
  imageMode(CORNER);
  image(home_icon, 40, 0, 32, 32);
  if (mouseX <= 40 + 32 && mouseX >= 40 && mouseY <= 32 && mousePressed && !mouseHolding) {
    doTerminalCommand("home");
  }
}

void HelpButtongEssential() {  //Essential : Help Button
  imageMode(CENTER);
  image(help_icon, width/2, height * 8/9 + 10, 620/10.0, 553.0/10);
  if (mouseX >= width/2 - 620/20.0 && mouseX <= width/2 + 620/20.0 && mouseY <= height * 8/9 + 553.0/20 && mouseY >= height * 8/9 - 553.0/20 && mousePressed && !mouseHolding) {
    doTerminalCommand("help");
  }
}

void CloseButtonEssential() {  //Essential : Close Button
  imageMode(CORNER);
  image(close_icon, 0, 0, 32, 32);
  if (mouseX <= 24 && mouseY <= 24 && mousePressed && !mouseHolding) {
    doTerminalCommand("exit");
  }
}

void InfoButtonEssential() {  //Essential : Info Button
  imageMode(CORNER);
  image(info_icon, width - 32, height * 0.3, 32, 32);
  if (mouseX >= width - 32 && mouseY >= height * 0.3 && mouseY <= height * 0.3 + 32 && mousePressed && !mouseHolding) {
    doTerminalCommand("info");
  }
}


void TerminalEssential() {  //Essential : Main Terminal
  imageMode(CORNER);
  image(terminal_clear_icon, width * 0.9 + 10, height - 40, 35, 40);
  terminal.drawItems();
}


//Pixel ratios

float scale_1m_pixels = 200;  //N pixels make up 1 meter

float m_to_pixel(float value_m) {
  float value_pixels = value_m * scale_1m_pixels;
  return value_pixels;
}

float pixelX_to_mL_on_beam(float pixelX) {
  pixelX = constrain(pixelX, beam.center.X - beam.Length/2, beam.center.X + beam.Length/2);  //Anything outside this is useless
  pixelX -= beam.center.X - beam.Length/2;
  float dist_mL = pixelX / scale_1m_pixels;
  return dist_mL;
}

void initialize_variables() {
  //Initialize beam
  beam = new Beam(new Point(width/2, height/2), 4, 0.2);  //center, length_m, thickness_m

  //Array list of materials
  loadMaterials();
  
  //Forces : Dragging forces
  headAt = new Point(width - 40, height/3);

  //Initialize temrinal
  terminal = new UITextField(width * 0.1, height - 40, width * 0.9, height);
  terminal.placeholder_text = "Terminal Console";
  terminal.singleLineTextField = true;
  terminal.text = "";
  terminal.text_inTheField = false;
  
  //Beam property menu
  BeamLength = new UITextField(20,height * 0.2,20 + 700, height * 0.2 + 50);
  BeamLength.placeholder_text = "Enter Length of beam (in meters): ";
  
  BeamLength.singleLineTextField = true;
  BeamLength.text = "";
  BeamLength.text_inTheField = false;
  
  BeamThickness = new UITextField(20, height * 0.4, 20 + 700, height * 0.4 + 50);
  BeamThickness.placeholder_text = "Enter Thickness of beam (in meters): ";
  
  BeamThickness.singleLineTextField = true;
  BeamThickness.text = "";
  BeamThickness.text_inTheField = false;
  
  Material_Number = new UITextField(width * 0.75, height - 50 - 50, width * 0.75 + 100, height - 50);
  Material_Number.placeholder_text = "No : ";
  Material_Number.text = "";
  Material_Number.singleLineTextField = true;
  Material_Number.text_inTheField = false;
}