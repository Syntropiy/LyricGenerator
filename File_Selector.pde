public class MusicFile{
  int x, y, tempx;
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
  
  void fileDisplay(){
    tempName = name;
    fill(buttonColour);
    if(UIfileSelected() && !menuOpen){
      fill(selectionColour);
      if(textWidth(name) + tempx > .95*width){
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
    textSize(textScale);
    rect(x-10, y+10, textWidth(name)+10, textScale+10, 0, 10, 10, 0);
    fill(textColour);
    text(name, tempx-5, y+textScale+11);
    fill(backgroundColour);
    rect(0, y+10, x-10, textScale+10);
  }
  
  boolean UIfileSelected(){
    if(mouseX > x-10 && mouseX < x+textWidth(name) && mouseY > y+10 && mouseY < y+10+textScale+10){
      return true;
    }
    return false;
  }
}
