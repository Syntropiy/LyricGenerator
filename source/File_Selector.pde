public class MusicFile{
  int x, y, tempx;
  float widthLimit = .9*width;
  int currentMils = 0;
  File song;
  String name, tempName;
  int textScale = 20;
  public MusicFile(int xa, int ya, File music){
    x = xa;
    tempx = x;
    tempName = name;
    y = ya - 75;
    song = music;
    name = song.getName().substring(0, music.getName().length()-4);
  }
  
  String name(){
    return name;
  }
  
  void fileDisplay(float yChange){
    textSize(textScale);
    y -= int(yChange) * (textScale+18);
    float tooLong = textWidth(name);
    color notYet = colVars[5];
    color notYetStroke = colVars[2];
    
    tempName = name;
    
    if(UIfileSelected() && !menuOpen){
      notYet = colVars[1];
      notYetStroke = colVars[3];
      if(textWidth(name) + tempx > widthLimit){
        if(currentMils == 0){
          currentMils = millis();
        }
        tempName += "   ||   ";
        tempx = x - int(((millis()-currentMils))%15000/15000.0 * textWidth(name));
        tempName += tempName;
      }
    } else {
      tempx = x;
      currentMils = 0;
    }
    if(textWidth(name) + x > widthLimit){
      tooLong = widthLimit - x + 1;
    }
    
    fill(notYet);
    rect(x-10, y+10, tooLong+10, textScale+10, 0, 10, 10, 0);
    fill(colVars[3]);
    text(name, tempx-5, y+textScale+11);
    fill(colVars[7]);
    stroke(colVars[7]);
    rect(0, y+10, x-11, textScale+10);
    rect(widthLimit + 2, y+10, width-widthLimit, textScale + 10);
    fill(0, 0, 0, 0);
    stroke(notYetStroke);
    rect(x-10, y+10, tooLong+10, textScale+10, 0, 10, 10, 0);
    stroke(colVars[7]);
  }
  
  boolean UIfileSelected(){
    if(mouseX > x-10 && mouseX < x+textWidth(name) && mouseY > y+10 && mouseY < y+10+textScale+10 && mouseX < widthLimit){
      return true;
    }
    return false;
  }
}
