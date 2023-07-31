/*todo (in order of doing):
Add volume slider to upper right corner - make it live interactable
Change esc from quit to pause
If paused, make esc AND enter AND a clickable menu resume
Add an options menu as a second pop out window (like preferences in any application) that can display side by side the main window, which lets you alter preferences and view the alterations live
Options menu support for colour scheme changing
Options menu to enable/disable archiving lyrics
Add support for non txt/mp3 files (make grid of clickables in options menu where 
             any number can be selected/deselected so that any can be searched)
             
Button on song selection screen to reselect directory (for misinputs & altering old preferences)
Config file to remember preferences (including all options menu things, volume, & originally selected directory)

scroll functionality in the song selection ui if there are too many file available
arrow key support in song selection ui
  > make this a method for arrow key support in lyric saving/end of song UI

Make the loading screen trigger while waiting for the file to load!!! why is it broken!!!
  > current patch fix - window title displays the current status of the program
  
Make window resizeable/scale to different monitor resolutions

~do at any time~
General code cleanup oh my god its such a mess
Remove redundant variables/unnecessarily complicated code
Instead of duplicate button code, have a button interactions handler that lets me just create buttons fit to the text size (or that take inputs for x1/y1/width/height)
*/

import ddf.minim.*;
import java.util.*;
import java.io.*;
import java.nio.file.*;
import processing.sound.*;

//Use these when making colour selection UI, eventually integrate with a config file
color selectionColour = color(255, 40, 150);
color selectionColourSecondary = color(220, 20, 110);
color textColour = color(255);
color textColourSecondary = color(150);
color buttonColour = color(10);
color backgroundColour = color(30);

Controller ui;
Minim minim;
Archive archive;
List<File> ls;
ArrayList<MusicFile> files = new ArrayList<>();
AudioPlayer song;
SoundFile songDummy;
Boolean firstTime = true;
Boolean fileSelected = false;
Boolean folderSelected = false;
Boolean clicked = false;
Boolean failedToArchive = false;
int archiveFailedTimer = 0;
String[] lyrics, lryc, LyricSync;
File lyricsName, selectedDirectory;
String lyrName, fName;
int line = 0;
int activeFileIndex;
int xInit = 30;
int yInit = 150;
int offTime, currentMin, currentSec, currentMili;

void setup(){
  PFont font;
  font = createFont("Dialog.plain", 5);
  textFont(font);
  minim = new Minim(this);
  archive = new Archive();
  ui = new Controller();
  size(675, 900);
  selectFolder("Select directory of music:", "directSelect");
  //selectInput("Select lyric txt:", "fileSelected");
}

//ui
void draw() {
  fill(backgroundColour);
  background(backgroundColour);
  stroke(backgroundColour);
  if(line == 0){
    offTime = millis();
  }
  ui.songInfo();
  if(lyrics != null){
    ui.lyricDisplay(lyrics, line, xInit, yInit);
    if(song != null && song.isPlaying()){
      timeFormat();
    }
    if(line == lyrics.length){
      EoSMenu();
    }
  }

  fill(buttonColour);
  rect(0, height-25, width, height);
  textSize(16);
  fill(textColourSecondary);
  String controlsExplain = "[ESC] to exit program at any time (without saving)           [ENTER] to advance to next lyric";
  text(controlsExplain, width/2 - textWidth(controlsExplain)/2, height-7);
  
  if(firstTime && !fileSelected){
    selector();
  }
  
  if(failedToArchive){
    //These colour values should not be variable methinks
    fill(100, 10, 10);
    rect(0, height-50, width, 26);
    textSize(16);
    fill(255);
    String errorExplain = "[.txt] file not added to archive! It will not be deleted from original directory";
    text(errorExplain, width/2 - textWidth(errorExplain)/2, height-32);
    if(millis()-archiveFailedTimer > 15000){
      failedToArchive = false;
      archiveFailedTimer = 0;
    }
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
  } else if (firstTime && key==ENTER){
    song.setVolume(.25);
    song.play();
    String a = (timeFormat() + "");
    println(a);
    lryc[line] = a;
    firstTime = false;
    line++;
  }
  if(key==ESC){
    if(lyrics != null && line == lyrics.length){
      String fileName = fName+".lrc";
      saveStrings(fileName, LyricSync);
    }
    surface.setTitle("Quitting Safely...");
    exit();
  }
}

//formats the time tag
String timeFormat(){
  int currentTime = millis()-offTime;
  currentMili = currentTime%1000;
  currentSec = (currentTime/1000);
  currentMin = currentSec/60;
  currentSec %= 60;
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

//Select the directory
void directSelect(File selection) {
  if (selection == null){
    println("Window closed or user hit cancel");
    exit();
  } else {
    println("Selected " + selection.getAbsolutePath());
    selectedDirectory = archive.makeDirectory(selection.getAbsolutePath());
  }
  addMusicFiles(selection);
  folderSelected = true;
}

void addMusicFiles(File selection){
  ls = listf(selection);
  int x = xInit;
  int y = yInit;
  for(int i = 0; i < ls.size(); i++){
    files.add(new MusicFile(x, y, ls.get(i)));
    y+=38;
  }
}

public static FilenameFilter filter = new FilenameFilter(){
  public boolean accept(File f, String name){
    return name.endsWith(".txt");
  }
};

//Thanks to Cyrille Ka on stackoverflow in 2013
public static List<File> listf(File directoryName) {
  File directory = directoryName;
  
  List<File> resultList = new ArrayList<File>();

  // get all the files from a directory
  File[] fList = directory.listFiles(filter);
  resultList.addAll(Arrays.asList(fList));
  for (File file : fList) {
    if (file.isFile()) {
      //System.out.println(file.getAbsolutePath());
    } else if (file.isDirectory()) {
      resultList.addAll(listf(new File(file.getAbsolutePath())));
    }
  }
  return resultList;
}

//file selection code
void fileSelected(File selection){
  fileSelected = true;
  if (selection == null){
    println("Invalid filetype/no file selected");
    exit();
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
  song = minim.loadFile(fName+".mp3");
  surface.setTitle("Loading...");
  songDummy = new SoundFile(this, fName+".mp3", false);
  println("Song loaded");
  surface.setTitle(selection.getName().substring(0, selection.getName().length()-4));
}

void mouseClicked(){
  clicked = true;
}

void selector(){
  int i = 0;
    int foundClick = 0;
    Boolean fc = false;
    for(i = 0; i < files.size(); i++){
      MusicFile mf = files.get(i);
      mf.fileDisplay();
      if(clicked){
        if(mf.UIfileSelected()){
          foundClick = i;
          fc = true;
        }
      }
    }
    clicked = false;
    if(fc){
      activeFileIndex = foundClick;
      fileSelected(ls.get(foundClick));
    }
}

//Handle end of song menu
void EoSMenu(){
  fill(selectionColour);
  textSize(40);
  text("Lyrics Complete!", 20, 220); 
  int xTemp = xInit+40;
  int yTemp = yInit+95;
  String[] eos = {"Save & Select New", "Restart This Song", "Save & Choose New Directory", "Save & Quit", "Quit Without Saving"};
  int i = 0;
  int foundClick = 0;
  Boolean fc = false;
  for(i = 0; i < eos.length; i++){
    ui.menuDisplay(eos[i], xTemp, yTemp);
    if(clicked){
      if(ui.UIoptionSelected(eos[i], xTemp, yTemp)){
        foundClick = i;
        fc = true;
      }
    }
    yTemp += 45;
  }
  clicked = false;
  if(fc){
    songEnd(foundClick);
  }
}

//Handle end of song saving & such
void songEnd(int a){
  int selection = a;
  LyricSync = Arrays.copyOf(lryc, lryc.length-1);
  ui.lyricDisplay(lyrics, line, xInit, yInit);
  String fileName = fName+".lrc";
  //save and select new + Choose new directory
  if(selection == 0 || selection == 2){
    println("Saved song, selecting new");
    saveStrings(fileName, LyricSync);
    archiveLyrics();
    song.pause();
    fill(textColour);
    resetVars();
    if(selection == 2){
      files = new ArrayList<>();
      selectFolder("Select directory of music:", "directSelect");
      print(", and selecting new directory");
    }
  }
  //Restart this song
  else if(selection == 1){
    println("Restarted song");
    fill(textColour);
    song.rewind();
    song.pause();
    firstTime = true;
    currentMin = 0;
    currentSec = 0;
    currentMili = 0;
    line = 0;
  } 
  //Save & quit
  else if(selection == 3){
    println("Saved & quit");
    saveStrings(fileName, LyricSync);
    archiveLyrics();
    surface.setTitle("Saving...");
    exit();
  }
  //Quit w/o saving
  else if(selection == 4){
    println("Exited without saving");
    surface.setTitle("Quitting Safely...");
    exit();
  }
}

void archiveLyrics(){
  if(archive.fileTransfer(selectedDirectory, lyricsName.getAbsolutePath())){
    println("Removing txt file from original directory...");
    files.remove(activeFileIndex);
    ls.remove(activeFileIndex);
    lyricsName.delete();
  } else {
    failedToArchive = true;
    archiveFailedTimer = millis();
    println("File not added to archive - not deleting original");
  }
}

//Reset all variables to starting state (bar directory)
void resetVars(){
  minim = new Minim(this);
  ui = new Controller();
  firstTime = true;
  clicked = false;
  line = 0;
  xInit = 30;
  yInit = 150;
  currentMin = 0;
  currentSec = 0; 
  currentMili = 0;
  lyrics = null;
  lryc = null; 
  LyricSync = null;
  fileSelected = false;
  song = null;
  songDummy.removeFromCache();
  songDummy = null;
  surface.setTitle("Lyrical");
}
