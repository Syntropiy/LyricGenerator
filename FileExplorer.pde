import processing.sound.*;
import java.util.*;

SoundFile file;
void setup(){
  size(1000, 800);
  selectInput("Select lyric txt:", "fileSelected");
  //selectInput("Select song mp3:", 
}
Boolean firstTime = true;
String[] lyrics;
String[] lryc, LyricSync;
File lyricsName; 
SoundFile song;
String lyrName;
String fName;
int line = 0;
int xInit = 475;
int yInit = 45;
int offTime, currentMin, currentSec, currentMili;

//ui
void draw() {
  if(line == 0){
    offTime = millis();
  }
  background(30);
  fill(255);
  textSize(65);
  text("Next Lyric", 167, 310);
  textSize(24);
  text("hit enter", 210, 350);
  
  if(lyrics != null){
    lyricDisplay(lyrics, line, xInit, yInit);
  }
  
  //Timer
  int currentTime = millis()-offTime;
  currentMili = currentTime%1000;
  currentSec = (currentTime/1000);
  currentMin = currentSec/60;
  currentSec %= 60;
  
  //write to file
  if(lyrics != null && line == lyrics.length){
    fill(255, 40, 150);
    background(25);
    textSize(65);
    text("Lyrics Complete!", 167, 310);
    textSize(24);
    text("1 = save lyrics & select new \n2 = retry this song \n3 = save lyrics & quit program", 210, 400);
    LyricSync = Arrays.copyOf(lryc, lryc.length-1);
    lyricDisplay(lyrics, line, xInit, yInit);
    if(keyPressed && key == '1'){
      String fileName = fName+".lrc";
      saveStrings(fileName, LyricSync);
      song.stop();
      firstTime = true;
      line = 0;
      xInit = 475;
      yInit = 45;
      selectInput("Select lyric txt:", "fileSelected");
      fill(255);
    } else if(keyPressed && key == '2'){
      fill(255);
      song.stop();
      firstTime = true;
      line = 0;
      xInit = 475;
      yInit = 45;
    }
  }
}

//display the lyrics & highlight the currently selected lyric
void lyricDisplay(String[] lyr, int pos, int x, int y){
  textSize(20);
  //keep text in frame
  int a = 0;
  if(pos > 10){
    a = pos-10;
  }
  
  for(int i = a; i < lyr.length; i++){
    //highlight current lyric
    if(i == pos-1){
      fill(255, 40, 150);
      //visibility for instrumental sections
      if(!lyr[i].matches(".*[a-zA-Z]+.*")){
        text("/////////////", x, y);
      }
    }
    else{
      fill(255);
    }
    if(lyrics != null && line == lyrics.length){
      fill(255, 40, 150);
    }
    
    //show lyrics
    text(lyr[i], x, y);
    y+=23;
  }
}

//input handling
void keyPressed() {
  if(key==ENTER && !firstTime){
    if(line < lyrics.length){
      String a = (timeFormat() + lyrics[line]);
      println(a);
      lryc[line] = a;
      line++;
    }
  } else if (firstTime){
    song.amp(.25);
    song.play();
    String a = (timeFormat() + "");
    println(a);
    lryc[line] = a;
    firstTime = false;
    line++;
  }
  if(key=='3'){
    if(line == lyrics.length){
      String fileName = fName+".lrc";
      saveStrings(fileName, LyricSync);
    }
    exit();
  }
}

//formats the time tag
String timeFormat(){
  String Sec = str(currentSec);
  String Min = str(currentMin);
  String Mili = str(currentMili);
  if(currentSec < 10){
    Sec = "0" + currentSec;
  }
  if(currentMin < 10){
    Min = "0" + currentMin;
  }
  if(currentMili < 10){
    Mili = "0" + currentMili;
  } else if (currentMili > 99){
    Mili = str(currentMili/10);
  }
  return ("[" + Min + ":" + Sec + "." + Mili + "] ");
}

void fileSelected(File selection){
  if (selection == null){
    println("Window closed or user hit cancel");
  } else {
    println("Selected " + selection.getAbsolutePath());
  }
  String[] lyrrayPart = loadStrings(selection);
  lyrics = new String[lyrrayPart.length+1];
  lyrics[0] = " ";
  arraycopy(lyrrayPart, 0, lyrics, 1, lyrrayPart.length);
  
  lyricsName = selection;
  lryc = new String[lyrics.length+1];
  lyrName = lyricsName.toString();
  fName = lyrName.substring(0, (lyrName.length()-4));
  song = new SoundFile(this, fName+".mp3");
}
