/*todo (in order of doing):
Change esc from quit to pause
If paused, make esc AND enter AND a clickable menu resume
Add rewinding
Add support for non txt/mp3 files (make grid of clickables in options menu where 
             any number can be selected/deselected so that any can be searched)
Options button for invert scrolling
Make option selections only alter the config file if a 'save' button is clicked in the options menu

Display function of button floating by mouse when hovering over buttons

Let user edit the to-be-.lrc file by hand if they want to make by hand edits at the end of a song
   
Button on song selection screen or maybe options menu to reselect directory (for misinputs & altering old preferences)
Config file to remember preferences (including all options menu things, volume, & originally selected directory)
Upon exiting program, generate a log.txt of console so the user can review console events, probably store them wherever the config file will be stored

arrow key support in song selection ui
  > make this a method for arrow key support in lyric saving/end of song UI

Make window resizeable/scale to different monitor resolutions

~do at any time~
General code cleanup oh my god its such a mess
Remove redundant variables/unnecessarily complicated code
Instead of duplicate button code, have a button interactions handler that lets me just create buttons fit to the text size (or that take inputs for x1/y1/width/height)

Known bugs:
  > When selecting songs, the draw() function freezes for a few seconds, longer the bigger the music file. 
    It's supposed to keep working and the songInfo function to handle the unloaded bits of song data on its own with 
    a little loading... animation, but instead the program appears to just freeze until the song is fully loaded.
  > When lyric-ing songs out of order, the menu displaying available songs will just not display a button where the last song was 
    so the list doesn't get shorter, it just gets holes in it
  > If a lyric is too long to display, it runs off screen
  > Menu is inaccessable on the end of song menu
*/

import ddf.minim.*;
import java.util.*;
import java.io.*;
import java.nio.file.*;
import java.lang.Math.*;
import processing.sound.*;

//Use these when making colour selection UI, eventually integrate with a config file
color selectionColour = color(255, 40, 150);
color selectionColourSecondary = color(220, 20, 110);
color textColour = color(255);
color textColourSecondary = color(150);
color buttonColour = color(10);
color menuColour = color(0);
color backgroundColour = color(30);
color dummy = color(0);
color[] colVars = {dummy, selectionColour, selectionColourSecondary, textColour, textColourSecondary, buttonColour, menuColour, backgroundColour};
String[] colVarNames = {"dummy", "Selection", "Selection (2)", "Text", "Text (2)", "Buttons", "Menu", "Background"};

//Moves from 0 to 50 - my preference is @ 20/30
float volume = 20;

//Toggles whether or not files are archived
Boolean doArchive = true;

Controller ui;
Options options;
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
Boolean menuOpen = false;
int archiveFailedTimer = 0;
String[] lyrics, lryc, LyricSync;
File lyricsName, selectedDirectory;
String lyrName, fName;
int line = 0;
int activeFileIndex;
int xInit = 30;
int yInit = 150;
int offTime, currentMin, currentSec, currentMili;
float scroll = 0;
int scrollPos = 0;
int lyrScroll = 0;

void setup(){
  PFont font;
  font = createFont("Dialog.plain", 5);
  textFont(font);
  minim = new Minim(this);
  options = new Options();
  archive = new Archive();
  ui = new Controller();
  size(675, 900);
  selectFolder("Select directory of music:", "directSelect");
}

//ui
void draw() {
  fill(colVars[7]);
  background(colVars[7]);
  stroke(colVars[7]);
  
  if(lyrics != null){
    if(lyrics.length-line > 30){
      lyrScroll += int(scroll);
      if(lyrScroll > lyrics.length-line-31){
        lyrScroll = lyrics.length-line-31;
      } else if (lyrScroll < 0){
        lyrScroll = 0;
      }
    } else {
      lyrScroll = 0;
    }
    
    ui.lyricDisplay(lyrics, line, xInit, yInit);
    scroll = 0;
    if(song != null && song.isPlaying()){
      timeFormat();
      song.setGain(volume-44);
    }
    if(line == lyrics.length){
      EoSMenu();
    } else if(line == 0){
      offTime = millis();
    }
  } else if(firstTime && !fileSelected){
    selector();
  }
  ui.songInfo();
  options.button(clicked);
  
  fill(colVars[5]);
  rect(0, height-25, width, height);
  textSize(16);
  fill(colVars[4]);
  String controlsExplain = "[ESC] to exit program at any time (without saving)           [ENTER] to advance to next lyric";
  text(controlsExplain, width/2 - textWidth(controlsExplain)/2, height-7);
  
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
  clicked = false;
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
  List<File> resultListCurated = new ArrayList<File>();

  // get all the files from a directory
  File[] fList = directory.listFiles(filter);
  resultList.addAll(Arrays.asList(fList));
  for (File file : fList) {
    if (file.isFile()) {
    } else if (file.isDirectory()) {
      resultList.addAll(listf(new File(file.getAbsolutePath())));
    }
  }
  
  //my own code to ensure only .txts with .mp3s associated are allowed
  for(int i = 0; i < resultList.size(); i++){
    File textFile = resultList.get(i);
    String textFileString = textFile.toString();
    String textFilePath = textFileString.substring(0, textFileString.length()-4) + ".mp3";
    if(Paths.get(textFilePath).toFile().exists()){
      resultListCurated.add(resultList.get(i));
    }
  }
  println(resultListCurated);
  return resultListCurated;
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

//input handling
void keyPressed() {
  if(key==ENTER && !firstTime){
    if(line < lyrics.length){
      String a = (timeFormat() + lyrics[line]);
      println(a);
      lryc[line] = a;
      line++;
      if(lyrScroll > 0){
        lyrScroll --;
      }
    }
  } else if (firstTime && key==ENTER){
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

void mouseClicked(){
  clicked = true;
}

void mouseWheel(MouseEvent event){
  scroll = event.getCount();
}

void selector(){
  int i = 0;
  int foundClick = 0;
  Boolean fc = false;
  if(files.size() < 20){
    scroll = 0;
  } else if(scrollPos+scroll < 0){
    scroll = -1 * scrollPos;
  } else if (scrollPos + scroll + 20 > files.size()){
    scroll = files.size() - 20 - scrollPos;
  }
  for(i = 0; i < files.size(); i++){
    MusicFile mf = files.get(i);
    mf.fileDisplay(scroll);
    if(clicked && !menuOpen){
      if(mf.UIfileSelected()){
        foundClick = i;
        fc = true;
      }
    }
  }
  scrollPos += int(scroll);
  scroll = 0;
  if(fc){
    activeFileIndex = foundClick;
    fileSelected(ls.get(foundClick));
  }
}

//Handle end of song menu
void EoSMenu(){
  fill(colVars[1]);
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
    fill(colVars[3]);
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
    fill(colVars[3]);
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
  if(archive.fileTransfer(selectedDirectory, lyricsName.getAbsolutePath()) && doArchive){
    println("Removing txt file from original directory...");
    files.remove(activeFileIndex);
    ls.remove(activeFileIndex);
    lyricsName.delete();
  } else if(doArchive){
    failedToArchive = true;
    archiveFailedTimer = millis();
    println("File not added to archive - not deleting original");
  } else {
    println("doArchive (" + doArchive + ") should be false");
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
