# Lyrical
a converter that turns unsynchronized .txt files into music synced .lrc files

This is a gradually improving processing sketch originally made between midnight and 6ish am, and now I'm slowly regretting everything i've ever created code wise while adding new features!

### Description:
Takes an input directory that contains .mp3 files and .txt files, and based on user inputs during audio playback, generates a time-synced .lrc file. Essentially lets the user play a rhythm game to sync up lyrics to songs (or really any text to any audio)

## Controls:
ENTER = Advance to next lyric [if lyrics have been input]
ESC = Exit the program at any time [must not be tapped but truely pressed, key detection is a bit janky]
Volume Control is a slider in the upper right corner [it actually controls gain, due to issues with the minim library]
  #### Options - A button in the lower right, that pulls up a menu displaying all options. Click the button again to close.
Options menu controls:
    Toggle file archiving - Enables/disables if, after creating the .lrc file, the original .txt file gets moved to a dedicated archive folder
    Colour variables & sliders - Select a variable by clicking it's button to view its current colour on the swatch (far left side of the menu)
    You can edit the colour of that variable by adjusting the rgb sliders - any changes persist unless manually readjusted or the program is restarted
    [variablename] (2) indicates that this is a secondary colour/a variant of a colour. So by default, Selection is pink, and Selection (2) is a darker pink

### Song selection:
Upon opening the program, you must select the directory which contains your music.mp3 & text.txt files.
Once the directory has been selected, if a .mp3 and .txt file share the same name in the directory, they will be displayed on the main window. Click on a song to select it, which will cause the program to freeze while the song is loaded, until the lyrics & certain song information is displayed.

### End of song menu:
Once the final lyric has been reached, the end of song menu will be displayed. This DOES NOT TRIGGER at the end of a song's playback - it waits on the user.
Once the menu is open, click the corresponding button to the action you want to do. You can:
    Save the lyrics & select a new one from the same directory
    Save the lyrics & select a new directory
    Save the lyrics & then quit the program
    Re-try the just complete song/lyrics
    Quit without saving

### Syncing a file:
The currently playing lyric should be the one of a different colour - by default pink. Creating synced lyrics **is not automatic**, the user *must* click in time to the music to advance to the next lyric. Whatever is highlighted in pink is what will be displayed at that same spot in the song by mp3 players.

# How do certain features work?
   ## Archiving  
By default (this can be disabled in options), when the user selects any 'save' option at the end of a lyric file, a .lrc will be generated. Then, if there is no existing archive folder in the selected directory, one will be created, and then the original .txt lyrics will be copied into that new folder. If that copied .txt exactly matches the old .txt, then the old .txt in the original directory will be **deleted**. If you do not wish for this to happen, disable archiving in the options menu, and no archive directory will be created or any files be copied.

# How to run the code:
Method 1:
```
Run the .java file:
Use shell/cmd/terminal on your system to navigate to the folder you placed Lyrical.java 
  > (ex: 'cd c:\Users\username\Documents\']
If you want to ensure you're in the correct directory:
  > on windows run 'dir *.java'
  > on linux/mac, run 'ls *.java'
  > check that Lyrical.java appears in the list
compile the file with: 'javac Lyrical.java'
run the program with: 'java Lyrical'
```
Method 2:
```
Download processing 4.2 (latest version) https://processing.org/
Run processing, then open Lyrical.pde in processing
Run using the big play button!
Alternatively, go to file > build to application
Run from the .exe inside the folder it generates
```

Little bonus feature: if you don't like the colours i do, you can just edit the colour variables in the java file at the very start of the program, you should be able to infer what the names refer to (or just trial and error it, it's not that bad trust me I trial-and-errored it too)

# Bugs & Plans
my own notes for myself, tracking some bugs & next plans
```
todo (in order of doing):
Change esc from quit to pause
If paused, make esc AND enter AND a clickable menu resume
Add rewinding
Add support for non txt/mp3 files (make grid of clickables in options menu where 
             any number can be selected/deselected so that any can be searched)
Make option selections only alter the config file if a 'save' button is clicked in the options menu
             
Let user restart the song from any timestamp in the song

Let user edit the .txt lyric file by hand/open it up with a button press if they notice the lyrics are wrong
Let user edit the to-be-.lrc file by hand if they want to make by hand edits at the end of a song
   
Button on song selection screen or maybe options menu to reselect directory (for misinputs & altering old preferences)
Config file to remember preferences (including all options menu things, volume, & originally selected directory)
Upon exiting program, generate a log.txt of console so the user can review console events, probably store them wherever the config file will be stored

scroll functionality in the song selection ui if there are too many file available
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
  > Non Latin text displays //// overlayed on top of it, which is not ideal when selected
  > Menu is inaccessable on the end of song menu
```
