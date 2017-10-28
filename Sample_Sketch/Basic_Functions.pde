void setup_Fonts() {  //Font setup module
  Baisc_Screens_LoadingFont = loadFont("AgencyFB-Bold-100.vlw");
  Forces_Font = loadFont("Arial-BoldMT-50.vlw");
  UITextField_TextFont = loadFont("CenturyGothic-30.vlw");
  Error_MessageFont = loadFont("Constantia-Bold-100.vlw");
}

PImage close_icon, info_icon, help_icon, home_icon, terminal_clear_icon;

void attach_images() {  //Attach Images
  close_icon = loadImage("data/close.png");
  info_icon = loadImage("data/info.png");
  help_icon = loadImage("data/help.png");
  home_icon = loadImage("data/home.png");
  terminal_clear_icon = loadImage("data/clearTerminal.png");
  //Buttons on startup screen
  BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_unhovered.png");

  //Error Screen Navigator Error Icon
  Error_icon_ESN = loadImage("data/error.png");
}

void Make_Essentials() {  //Essential Buttons
  imageMode(CORNER);
  CloseButtonEssential();
  if (CURRENT_SCREEN == "Introduction Screen" && CURRENT_VIEW == "Home") {
    HelpButtongEssential();
    InfoButtonEssential();
  } else {
    HomeButtonEssential();
  }

  TerminalEssential();
}

void HomeButtonEssential() {  //Essential : Home button
  imageMode(CORNER);
  image(home_icon, 40, 0, 32, 32);
  if (mouseX <= 40 + 32 && mouseX >= 40 && mouseY <= 32 && mousePressed && !mouseHolding) {
    doTerminalCommand("HOME");
  }
}

void HelpButtongEssential() {  //Essential : Help Button
  imageMode(CENTER);
  image(help_icon, width/2, height * 8/9 + 10, 100, 50);
  if (mouseX >= width/2 - 50 && mouseX <= width/2 + 50 && mouseY <= height * 8/9 + 25 && mouseY >= height * 8/9 - 25 && mousePressed && !mouseHolding) {
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
  if (mouseX <= width * 0.9 + 10 + 35 && mouseX >= width * 0.9 + 25 && mouseY >= height - 40 && mousePressed && !mouseHolding) {
    terminal.text = "";
    terminal.placeholder_text = "Terminal Console";
  }
}


//Pixel ratios

float scale_1m_pixels = 200;  //N pixels make up 1 meter

float m_to_pixel(float value_m) {
  float value_pixels = value_m * scale_1m_pixels;
  return value_pixels;
}

void initialize_variables() {
  //Initialize beam
  beam = new Beam(new Point(width/2, height/2), 4, 0.2);  

  //Initialize temrinal
  terminal = new UITextField(width * 0.1, height - 40, width * 0.9, height);
  terminal.placeholder_text = "Terminal Console";
  terminal.singleLineTextField = true;
}