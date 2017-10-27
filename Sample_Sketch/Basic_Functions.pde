void setup_Fonts() {
  Baisc_Screens_LoadingFont = loadFont("AgencyFB-Bold-100.vlw");
}

void attach_images() {
  close_icon = loadImage("data/close.png");
  info_icon = loadImage("data/info.png");
}

void Make_Essentials() {
  CloseButtonEssential();
  InfoButtonEssential();
}

void CloseButtonEssential() {
  image(close_icon, 0, 0, 32, 32);
  if (mouseX <= 24 && mouseY <= 24 && mousePressed) {
    exit();
  }
}

void InfoButtonEssential() {
  image(info_icon, width - 32, height * 0.3, 32, 32);
  if (mouseX >= width - 32 && mouseY >= height * 0.3 && mouseY <= height * 0.3 + 32 && mousePressed) {
    exit();
  }
}