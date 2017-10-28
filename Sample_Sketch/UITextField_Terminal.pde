class UITextField {
  float p1_x, p1_y, p2_x, p2_y;
  float textField_width, textField_height;
  float text_Size = 20;
  UITextField(float x1, float y1, float x2, float y2) {  //Corners of the text field
    this.p1_x = x1;
    this.p1_y = y1;
    this.p2_x = x2;
    this.p2_y = y2;
    textField_width = x2 - x1 - 20;
    textField_height = y2 - y1 - 20;
  }
  void set_TextSize(float newSize) {
    if (newSize <= textField_height) {
      text_Size = newSize;
    } else {
      println("Cannot set the size to '" + str(newSize) + "' because it won't fit.\nSetting the text_Size to maximum value possible (" + str(textField_height) + ").");
      text_Size = textField_height;
    }
  }

  color label_BackgroundColor = color(0, 0, 0);
  void set_BackgroundColor(color c) {
    label_BackgroundColor = c;
  }
  color label_selectedColor = color(255, 255, 255);
  void set_SelectedColor(color c) {
    label_selectedColor = c;
  }
  color label_notSelectedColor = #A28A8A;
  void set_NotSelectedColor(color c) {
    label_notSelectedColor = c;
  }
  color label_textColor = color(255, 255, 255);
  void set_TextColor(color c) {
    label_textColor = c;
  }
  color label_placeholderTextColor = color(120, 120, 120);
  void set_PlaceholderTextColor(color c) {
    label_placeholderTextColor = c;
  }
  color label_textFollower = color(255, 255, 255);
  void set_TextfollowerColor(color c) {
    label_textFollower = c;
  }

  boolean singleLineTextField = false;
  String text = "";
  String placeholder_text = "Enter text here";
  boolean selected = false;
  boolean text_inTheField = false;
  
  void clearUITextField() {
    text = "";
    text_inTheField = false;
  }

  void drawItems() {
    makeRectangleTextBox();
    if (text == "") text_inTheField = false;
    else text_inTheField = true;  //crucial statements
    fillTextIntoRectangle();
  }


  void fillTextIntoRectangle() {
    textSize(text_Size);
    textFont(UITextField_TextFont);
    fill((text_inTheField == true) ? label_textColor : label_placeholderTextColor);  //Color of text to write
    textAlign(LEFT, TOP);
    String textToDisplay = (text_inTheField == true) ? text : placeholder_text;
    textToDisplay = displayFormat(textToDisplay);  //Change only textToDisplay, not text or placeholder_text
    float text_SizeToDisplay = text_Size;
    while ( ((count(textToDisplay, '\n') + 1) * (text_SizeToDisplay*3/2)) > textField_height && !singleLineTextField) {
      text_SizeToDisplay--;
      textSize(text_SizeToDisplay);
      textLeading(text_SizeToDisplay*3/2);
      textToDisplay = (text_inTheField == true) ? text : placeholder_text;
      textToDisplay = displayFormat(textToDisplay);
    }
    textSize(text_SizeToDisplay);
    textLeading(text_SizeToDisplay*3/2);
    text(textToDisplay, p1_x + 10, p1_y + 10);  //Text to write in the text field, note that the real text didn't change

    //Tell how many lines are there
    if (!singleLineTextField) {
      textAlign(RIGHT, TOP);
      text(str(count(textToDisplay, '\n') + 1) + " " + "Lines", p2_x, p2_y);
    }

    String[] lines = split((text_inTheField == true) ? textToDisplay:"", '\n');  //Pretend that there's no text in the field to be written if no text_inTheField
    int i = 0;
    for (String line : lines) {
      i++;
    }
    //There are i number of lines in the field...
    String lastLine = lines[i-1];

    if (selected == true) {  //The follower is visible only if we have to type in text
      strokeWeight(1);
      stroke(label_textFollower);
      String text_lastLine = (singleLineTextField == true) ? text : lastLine;
      i--;
      line(p1_x + 10 + textWidth(text_lastLine) + 1, p1_y + 10 + text_SizeToDisplay * 3/2 * i, 
        p1_x + 10 + textWidth(text_lastLine) + 1, p1_y + 10 + text_SizeToDisplay * 3/2 * i + text_SizeToDisplay);
    }
  }

  void makeRectangleTextBox() {
    fill(label_BackgroundColor);
    stroke((selected == false) ? label_notSelectedColor : label_selectedColor);
    strokeWeight(4);
    rectMode(CORNERS);
    rect(p1_x, p1_y, p2_x, p2_y);
    if ((mouseX <= p2_x && mouseX >= p1_x) && (mouseY <= p2_y && mouseY >= p1_y)) {
      if (text_inTheField == true && selected == true) {
        noCursor();
      } else {
        cursor(TEXT);
      }
      if (mousePressed == true) {
        selected = true;
      }
    } else {
      cursor(ARROW);
      if (mousePressed == true) {
        selected = false;
      }
    }  //Mouse cursor
  }

  int count(String s, char c) {  //How many times character 'c' has appeared in 's'
    int t = 0;
    for (int i = 0; i < s.length(); i++) {
      if (s.charAt(i) == c) t++;
    }
    return t;
  }

  String displayFormat(String s) {  //FORMATTING THE TEXT INSIDE THE BOX
    return displayFormat_wordAdjust(s);
  }

  String displayFormat_wordAdjust(String s) { //Display formatting algorithm
    String givenString = s;
    String st = "";
    for (int i = 0, latestSpace = -1, del_numberOfExceptions = 0; i < givenString.length(); i++) {  //ALGORITHM : Fit text inside textField
      if (textWidth(st + givenString.charAt(i)) < textField_width) {  //Add the new character to the display string (st)
        st += givenString.charAt(i);
        if (givenString.charAt(i) == ' ') {
          latestSpace = i;
        }
      } else {  //do something
        if (latestSpace != -1 && givenString.charAt(i) != ' ') {  //We have a word that could be brought on a new line
          String p1 = st.substring(0, latestSpace + del_numberOfExceptions);
          String p2 = st.substring(latestSpace + del_numberOfExceptions + 1, st.length());
          st = p1 + "\n" + p2 + givenString.charAt(i);  //Add a newline just before the word (replace the space by newline character)
          latestSpace = -1;  //Since we're on the newer line, set this back to -1, we'll again hunt for a newer latestSpace
        } else if (latestSpace == -1 || givenString.charAt(i) == ' ') {  //If no space is found OR the character that raised an exception is a ' '
          //At i the givenString[i] became >=...
          //case when the single word is longer than textField_width
          if (givenString.charAt(i) != ' ') {  //if this is just a really long word, then we'll have to add a \n, then the character. then increase offset
            st += "\n" + givenString.charAt(i);
            del_numberOfExceptions += 1;  //This keeps track of how many variables we have added to the main string, so that we can offset the latestSpace by the same amount.
          } else {
            st += "\n";  //same as replacing the space with a newline
          }
        }
      }
    }
    return st;
  }

  void keyboardManager() {
    if (selected == true) {
      if (key >= 32 && key <= 126) {  //In the typable range (range of characters accepted into the text field)

        text += key;
      } else if (key == 8) {  //Backspace
        //Remove one last character, set text to "" if can't
        if (text.length() == 1) {
          text = "";
        } else if (text.length() > 1) {
          text = text.substring(0, text.length() - 1);
        }
      } else if ((key == 13 || key == '\n') && this.singleLineTextField == false) {
        //check if a new line can be added and then insert a \n
        text += "\n";
        println("Enter key pressed");
      }
      println("Text now = \"" + text + "\"");
    }
  }
}