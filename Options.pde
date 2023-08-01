public class Options{
  int buttonScale = 20;
  Boolean boo = false;
  int openTime = 0;
  int setHeight = height/3;
  float menuHeight = height/3;
  
  public Options(){ 
  }
  
  void button(Boolean mouseReleased){
    textSize(buttonScale);
    fill(buttonColour);
    if(boo){
      menuOpen = true;
      stroke(selectionColour);
      fill(buttonColour, 155);
      menuHeight = height - (millis()-openTime)*4;
      if(menuHeight <= setHeight){
        menuHeight = setHeight;
      }
      rect(width/20, menuHeight, width-2*width/20, height*2/3, 20, 20, 20, 20);
      
      doArchive = menuButtons("Archive .txt files on .lrc generation", int(width/20+30), int(menuHeight+30), mouseReleased, doArchive);
      
      fill(selectionColourSecondary);
      stroke(textColour);
    } else {
      menuOpen = false;
    }
    menuDisplay(">", int(width-textWidth(">")-5), height-buttonScale-45, mouseReleased);
  }
  
  //display the options menu button & handle if it's active or not
  void menuDisplay(String name, int x, int y, Boolean mouseReleased){
    stroke(selectionColourSecondary);
    if(optionSelected(name, x, y)){
      fill(selectionColour);
      if(mouseReleased){
        boo = !boo;
        openTime = millis();
      }
    }
    textSize(buttonScale);
    rect(x-10, y+10, textWidth(name)+13, textWidth(name)+13, 10, 10, 10, 10);
    fill(textColour);
    text(name, x-3, y+buttonScale+9);
    stroke(backgroundColour);
  }
  
  //Handle the options in the menu
  Boolean menuButtons(String name, int x, int y, Boolean mouseReleased, Boolean valueChange){
    stroke(selectionColourSecondary);
    Boolean testSelected = optionSelected(name, x, y);
    if(testSelected || valueChange){
      fill(selectionColour);
      if(mouseReleased && testSelected){
        return !valueChange;
      }
    }
    textSize(buttonScale);
    rect(x-10, y+10, textWidth(name)+13, buttonScale+10, 10, 10, 10, 10);
    fill(textColour);
    text(name, x-3, y+buttonScale+12);
    stroke(backgroundColour);
    return valueChange;
  }
  
  //returns if mouse is hovering over an element
  boolean optionSelected(String name, int x, int y){
    if(mouseX > x-10 && mouseX < x+textWidth(name) && mouseY > y+10 && mouseY < y+10+buttonScale+10){
      return true;
    }
    return false;
  }
}
