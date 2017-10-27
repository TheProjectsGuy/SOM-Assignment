void setup_Fonts() {
  Baisc_Screens_LoadingFont = loadFont("AgencyFB-Bold-100.vlw");
}

void attach_images() {
  close_icon = loadImage("data/close.png");
  info_icon = loadImage("data/info.png");
  //Buttons on startup screen
  BMA_icon = loadImage("data/Buttons/Bending Moment Analysis/Bending_moment_analysis_unhovered.png");
}

void Make_Essentials() {
  imageMode(CORNER);
  CloseButtonEssential();
  InfoButtonEssential();
  
  TerminalEssential();
}

void CloseButtonEssential() {
  image(close_icon, 0, 0, 32, 32);
  if (mouseX <= 24 && mouseY <= 24 && mousePressed && !mouseHolding) {
    exit();
  }
}

void InfoButtonEssential() {
  image(info_icon, width - 32, height * 0.3, 32, 32);
  if (mouseX >= width - 32 && mouseY >= height * 0.3 && mouseY <= height * 0.3 + 32 && mousePressed && !mouseHolding) {
    terminal.text = "Info Screen";
  }
}


void TerminalEssential() {
  terminal.drawItems();
}


float scale_1m_pixels = 100;

float m_to_pixel(float value_m) {
  float value_pixels = value_m * scale_1m_pixels;
  return value_pixels;
}

void initialize_variables() {
  beam = new Beam(new Point(width/2, height/2), 4, 0.2);
  
  terminal = new UITextField(width * 0.1,height - 40,width * 0.9,height);
  terminal.placeholder_text = "Terminal Console";
  terminal.singleLineTextField = true;
}