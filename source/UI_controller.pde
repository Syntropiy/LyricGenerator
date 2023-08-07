public class Controller{
  int textScale = 25;
  Boolean pressing = false;
  AudioMetaData meta;
  public Controller(){
  }
  int xPos;
  public void songInfo(){
    fill(colVars[3]);
    textSize(45);
    String seconds = "Loading...";
    //I have to do it this way because the way that minim handles time metadata is broken
    //and the default processing sound library uses to low a sample rate 
    //attempting to change it results in so many errors - it's a known bug
    if (song != null){
      if(songDummy != null){
        int time = int(songDummy.duration());
        if(time%60 > 9){
          seconds = str(time%60);
        } else if(time%60 != 0){
          seconds = "0" + time%60;
        } else {
          seconds = "00";
        }
        seconds = str(time/60) + ":" + seconds;
      }
      
      meta = song.getMetaData();
      String songname = meta.fileName();
      File sn = new File(songname);
      songname = sn.getName();
      songname = "Song: " + songname.substring(0, songname.length()-4);
      textSize(30);
      if(textWidth(songname) > .85*width){
        songname += "   ||   ";
        xPos = int((1000-millis())%20000/20000.0 * textWidth(songname));
        songname += songname;
      } else {
        xPos = 15;
      }
      fill(colVars[1]);
      text(songname, xPos, 64);
      textSize(15);
      fill(colVars[2]);
      text("By " + meta.author(), 33, 83);
      textSize(20);

      text("Lines: " + (lyrics.length-1), 15, 35);
      textSize(30);
      text(currentMin + ":" + currentSec, 135, 35);
      textSize(20);
      text("   / " + seconds, 145+textWidth(currentMin + ":" + currentSec), 35);
      textSize(25);
      float pos = song.position();
      float len = songDummy.duration()*1000;
      float percent;
      if(pos < len){
        percent = pos*100.0/len;
      } else {
        percent = 100;
      }
      fill(colVars[4]);
      text(int(percent) + "%", 6*width/28, 115);
      int percentBar = int((percent/100.0) * (3*width/7));
      fill(colVars[3]);
      rect(width/28, 120, 12*width/28, 10, 8);
      fill(colVars[1]);
      rect(width/28, 120, percentBar, 10, 8);
    } else if (lyrics == null){
      if(songDummy == null && fileSelected){
        loading();
        println("Loading song...");
      } else if(folderSelected){
        fill(colVars[7]);
        rect(-2, -2, width+4, 80);
        fill(colVars[3]);
        text("Please Select Song", 25, 60);
      } else{
        textSize(40);
        text("Please Select Song Folder", 25, 50);
        textSize(15);
        text("Ensure each song [.mp3] you wish to give lyrics has a matching .txt file \n which share a directory and filename with the song", 20, 90);
        fill(colVars[1]);
        text("NOTE: If there is a .lrc for a song already in this directory, saving lyrics that song will overwrite it", 15, 150);
      }
    }
    volumeSlider();
  }
  
  public void lyricDisplay(String[] lyr, int pos, int x, int y){
    y-=lyrScroll*23;
    textSize(20);
    //keep text in frame
    int a = 0;
    if(pos > 1){
      a = pos-1;
    }
    for(int i = a; i < lyr.length; i++){
      //highlight current lyric
      if(i == pos-1){
        fill(colVars[1]);
        //visibility for instrumental sections
        if(lyr[i].trim().length() == 0){
          text("/////////////", x+25, y);
        }
      }
      else{
        fill(colVars[3]);
      }
      if(lyrics != null && line == lyrics.length){
        fill(colVars[1]);
      }
      //show lyrics
      textSize(20);
      text(lyr[i], x+25, y);
      textSize(13);
      fill(colVars[4]);
      if(i > 0){
        text(i + "/" + (lyr.length-1), x-20, y);
      }
      y+=23;
    }
    fill(colVars[7]);
    rect(-3, 0, width+6, yInit-19);
    if(lyrScroll > 0 && pos > 0){
      fill(colVars[5]);
      stroke(colVars[1]);
      rect(-3, yInit-18, width+6, 23);
      stroke(colVars[7]);
      textSize(20);
      fill(colVars[1]);
      text(lyr[a], x+25, yInit);
      if(lyr[a].trim().length() == 0){
        text("/////////////", x+25, yInit);
      }
      textSize(13);
      fill(colVars[4]);
      text(a + "/" + (lyr.length-1), x-20, yInit);
    }
  }
  
  public void loading(){
    textSize(40);
    String elli = "";
    for(int i = 0; i < second(); i++){
      elli += ".";
      if(elli.length() > 3){
        elli = "";
      }
    }
    fill(colVars[3]);
    text("Loading Song" + elli, 25, 60);
    println("Loading Song" + elli);
  }
  
  public void menuDisplay(String name, int x, int y){
    fill(colVars[5]);
    stroke(colVars[1]);
    textSize(textScale);
    if(UIoptionSelected(name, x, y)){
      fill(colVars[1]);
      stroke(colVars[3]);
    }
    rect(x-10, y+10, textWidth(name)+10, textScale+10, 0, 10, 10, 0);
    fill(colVars[3]);
    text(name, x-5, y+textScale+11);
    fill(colVars[7]);
    stroke(colVars[7]);
    rect(0, y+10, x-11, textScale+10);
  }
  
  boolean UIoptionSelected(String name, int x, int y){
    if(mouseX > x-10 && mouseX < x+textWidth(name) && mouseY > y+10 && mouseY < y+10+textScale+10){
      return true;
    }
    return false;
  }
  
  void volumeSlider(){
    fill(colVars[4]);
    int sliderX = int(width*5.15/7);
    float volumeWidth = volume/50.0 * int(width/4);
    if((mouseX >= sliderX && mouseX <= sliderX+int(width/4)) && ((mouseY < 20 && mouseY > 5 && mousePressed) || (pressing && mousePressed))){
      pressing = true;
      volumeWidth = mouseX - sliderX;
      volume = volumeWidth/1.68/2;
      textSize(13);
      String percentVolume = str(int(volume*20)/10.0) + "%";
      float perVolX = sliderX + volumeWidth-textWidth(percentVolume)-5;
      float perVolY = 34;
      if(perVolX <= sliderX+5){
        perVolY += sliderX+5 - perVolX;
        if(perVolY >= 40){
          perVolY = 40;
        }
        perVolX = sliderX+5;
      }
      text(percentVolume, perVolX, perVolY);
    } else {
      pressing = false;
      textSize(14);
      fill(colVars[2]);
      String vol = "volume".substring(0, int(6 * volume/50.0 + 0.5));
      String ume = "volume".substring(int(6 * volume/50.0 + 0.5));
      float pos = sliderX + int(width/4)/2 + textWidth("volume")/2;
      text(vol, pos - textWidth("volume"), 30);
      fill(colVars[4]);
      text(ume, pos - textWidth(ume), 30);
    }
    //Volume bar
    fill(colVars[4]);
    rect(sliderX, 10, int(width/4), 7, 4, 4, 4, 4);
    //Volume indicator
    fill(colVars[2]);
    circle(sliderX + volumeWidth, 13, 12);
    //Colour aesthetics
    stroke(colVars[2]);
    rect(sliderX, 10, volumeWidth, 6, 4, 4, 4, 4);
    stroke(colVars[7]);
  }
}
