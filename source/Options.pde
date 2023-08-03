public class Options{
  int red;
  int green;
  int blue;
  int buttonScale = 20;
  int buttonOffsetX = int(width/20 + 30);
  int pressing;
  Boolean boo = false;
  int openTime = 0;
  int setHeight = height/3;
  float menuHeight = height/3;
  int yShift;
  int xShift;
  String openMenu;
  String optionsMenuHead = "options";
  int colourToChange = 0;
  
  public Options(){ 
    red = int(red(colVars[0]));
    green = int(green(colVars[0]));
    blue = int(blue(colVars[0]));
  }
  
  void button(Boolean mouseReleased){
    textSize(buttonScale);
    fill(colVars[3]);
    if(boo){
      menuOpen = true;
      stroke(colVars[1]);
      fill(colVars[6], 220);
      menuHeight = height - (millis()-openTime)*4;
      if(menuHeight <= setHeight){
        menuHeight = setHeight;
      }
      rect(width/20, menuHeight, width-2*width/20, height*2/3, 20, 20, 20, 20);
      
      doArchive = menuButtons("Archive .txt files on .lrc generation", buttonOffsetX, int(menuHeight+50), mouseReleased, doArchive, buttonScale);
      int colSel = colourVariables(buttonOffsetX+300, int(menuHeight+100), mouseReleased);
      red = menuSlider(buttonOffsetX, int(menuHeight+120), red, "Red", 0);
      green = menuSlider(buttonOffsetX, int(menuHeight+150), green, "Green", 1);
      blue = menuSlider(buttonOffsetX, int(menuHeight+180), blue, "Blue", 2);
      colVars[colSel] = color(red, green, blue);
      
      textSize(buttonScale+15);
      fill(255);
      float centerTitleHeight = menuHeight + 40;
      float centerTitle = (width-2*width/20)/2 + width/20 - textWidth(optionsMenuHead)/2;
      //Thanks to TFGuy44 on processing forums for this little code snippet!
      for(int x = -1; x < 2; x++){
        for(int y = -1; y < 2; y++){
          text(optionsMenuHead, centerTitle+x, centerTitleHeight+y);
        }
        text(optionsMenuHead, centerTitle+x, centerTitleHeight);
        text(optionsMenuHead, centerTitle, centerTitleHeight+x);
      }
      
      fill(red, green, blue);
      rect(buttonOffsetX-20, int(menuHeight+120), 7, 68, 4, 4, 4, 4);
      text(optionsMenuHead, centerTitle, centerTitleHeight);
      
      textSize(buttonScale);
      
      fill(colVars[2]);
      stroke(colVars[3]);
      openMenu = "v";
      yShift = 4;
      xShift = int(width-textWidth(openMenu)-11);
    } else {
      menuOpen = false;
      fill(colVars[5]);
      stroke(colVars[2]);
      openMenu = "^";
      yShift = 0;
      xShift = int(width-textWidth(openMenu)-5);
    }
    //println(int(width-textWidth(">")-5));
    textSize(buttonScale);
    menuDisplay(openMenu, xShift, height-buttonScale-45, yShift, mouseReleased);
  }
  
  //Create colour var selection buttons
  int colourVariables(int x, int y, Boolean mouseReleased){
    //{selectionColour, selectionColourSecondary, textColour, textColourSecondary, buttonColour, menuColour, backgroundColour}
    for(int i = 0; i < colVars.length; i++){
      Boolean isCurrentlySelected = i == colourToChange;
      if(i != 0 && i < 4 && menuButtons(colVarNames[i], x, y + 28*(i-1), mouseReleased, isCurrentlySelected, 15)){
        colourToChange = i;
      } else if (i > 3 && i < 7 && menuButtons(colVarNames[i], int(x+textWidth(colVarNames[i-3])+20), y + 28*(i-4), mouseReleased, isCurrentlySelected, 15)) {
        colourToChange = i;
      } else if (i > 6 && menuButtons(colVarNames[i], int(x+104), y + 28*(2), mouseReleased, isCurrentlySelected, 15)){
        colourToChange = i;
      }
    }
    red = int(red(colVars[colourToChange]));
    green = int(green(colVars[colourToChange]));
    blue = int(blue(colVars[colourToChange]));
    return colourToChange;
  }
  
  //display the options menu button & handle if it's active or not
  void menuDisplay(String name, int x, int y, int yShift, Boolean mouseReleased){
    if(optionSelected(name, x, y)){
      fill(colVars[1]);
      if(mouseReleased){
        boo = !boo;
        openTime = millis();
      }
    }
    textSize(buttonScale);
    rect(x-10, y+10, textWidth(name)+13, textWidth(name)+13, 10, 10, 10, 10);
    fill(colVars[3]);
    text(name, x-3, y+buttonScale+12-yShift);
    stroke(colVars[7]);
  }
  
  //Handle the options in the menu
  Boolean menuButtons(String name, int x, int y, Boolean mouseReleased, Boolean valueChange, int butScale){
    fill(colVars[5]);
    stroke(colVars[2]);
    Boolean testSelected = optionSelected(name, x, y);
    if(testSelected || valueChange){
      fill(colVars[1]);
      if(mouseReleased && testSelected){
        return !valueChange;
      }
    }
    if(valueChange){
      stroke(colVars[3]);
    }
    textSize(butScale);
    rect(x-10, y+10, textWidth(name)+13, butScale+8, 10, 10, 10, 10);
    fill(colVars[3]);
    text(name, x-3, y+butScale+12);
    stroke(colVars[7]);
    fill(colVars[5]);
    return valueChange;
  }
  
  int menuSlider(int x, int y, int shade, String colourName, int rgb){
    color selectedShade;
    color absoluteShade;
    if(rgb == 0){
      selectedShade = color(shade, 0, 0);
      absoluteShade = color(255, 40, 80);
    } else if(rgb == 1){
      selectedShade = color(0, shade, 0);
      absoluteShade = color(40, 255, 80);
    } else {
      selectedShade = color(0, 0, shade);
      absoluteShade = color(60, 110, 255);
    }
    
    fill(colVars[4]);
    int sliderX = x;
    float colWidth = shade;
    Boolean onThisSlider = (mouseX >= sliderX && mouseX <= sliderX + 256) && (mouseY < y+7 && mouseY > y-7 && mousePressed);
    if((pressing < 0 && onThisSlider) || (pressing == rgb && mousePressed)){
      pressing = rgb;
      colWidth = mouseX - sliderX;
      if(colWidth > 255){
        colWidth = 255;
      } else if (colWidth < 0) {
        colWidth = 0;
      }
      shade = int(colWidth);
      textSize(13);
      String percentVolume = str(shade) + "/255";
      float perVolX = sliderX + colWidth-textWidth(percentVolume)-5;
      if(perVolX <= sliderX+5){
        perVolX = sliderX+5;
      }
      text(percentVolume, perVolX, y-6);
    } else {
      if(pressing == rgb){
        pressing = -1;
      }
      textSize(14);
      fill(absoluteShade);
      text(colourName, sliderX + 256/2 - textWidth(colourName)/2 , y-5);
    }
    //draw slider
    fill(colVars[4]);
    rect(sliderX, y, 256, 7, 4, 4, 4, 4);
    //Colour aesthetics
    stroke(255);
    fill(selectedShade);
    rect(sliderX, y, colWidth, 6, 4, 4, 4, 4);
    fill(selectedShade);
    circle(sliderX + colWidth, y+3, 12);
    noStroke();
    rect(sliderX+1, y+1, colWidth-1, 5, 4, 4, 4, 4);
    stroke(colVars[7]);
    return shade;
  }
  
  //returns if mouse is hovering over an element
  boolean optionSelected(String name, int x, int y){
    if(mouseX > x-10 && mouseX < x+textWidth(name) && mouseY > y+10 && mouseY < y+10+buttonScale+10){
      return true;
    }
    return false;
  }
}
