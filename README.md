# Lyrical
a converter that turns unsynchronized .txt files into music synced .lrc files

This is a gradually improving processing sketch originally made between midnight and 6ish am, and now I'm slowly regretting everything i've ever created code wise while adding new features!

Description:
Takes an input .txt file that contains lyrics separated out by line (like you pasted it in from like Genius or something and removed the [verse x] parts, or like you had musicbee (with the lyrics reloaded plugin) autogenerate the lyric file to an mp3.

Controls:
ENTER = Advance to next lyric [if lyrics are selected]
ESC = Exit the program at any time [must not be tapped but truely pressed, key detection is a bit janky]

Use the volume slider like a volume slider to slide the volume to a different volume yk? like how it works in most programs
Click the button on the lower right to open the options menu, which has all of the options! Currently in the options you can:
> Disable or enable automatic archiving of .txt files once a .lrc file is generated
aaaand that's it!

When starting the program, select the directory of your song files you would like to have lyrics. This directory must include .txt files with names that match those of the corresponding song, and the songs must be in .mp3 format for now (if you gotta change it, just edit the code tbh find+replace 'mp3' with 'wav' or smthn). 
Then, the program gives you a list of songs in that directory - it only displays songs that it recognizes also have lyrics. Make sure though that these files do only have lyrics in them, no other junk. Each new lyric should be separated by a line break.

Hit ENTER to start song playback & to define the start time of the song, then on your second press of ENTER you'll be advancing the lyrics! The highlighted lyric is the lyric you have *already marked* - if the lyric is pink, its time is already saved. 

At the end of song playback, buttons will be displayed. They should be self explanitory.

WHEN LYRICS ARE SAVED, THE ORIGINAL TXT FILE WILL BE ARCHIVED - Upon saving, if one does not already exist, a folder will be created in the selected directory titled Lyrical_Archive. Upon saving a file, the original TXT will be copied into this new directory, and then the original replaced with a .lrc. This file will now no longer display inside the program unless you return the txt file to the same directory as the song. If the file fails to copy or in any way archiving messes up, the txt file will remain in its original position unaltered, and a .lrc file will be added alongside it. 

RUNNING THE CODE:
You should be just able to run the .java file from your command line and it should work(?) ngl it's late, I havn't tested it, and I'm not gonna.
If that doesn't work, just download processing 4 (as of current this works in 4.2) and plop in those pde files into the sucker and build the app yourself, it's easy, right in the [file] menu just hit "export application" and then go rooting in the windows_amdsomethingorother file it makes for the exe or the .java, whichever you prefer. This has the fun bonus of letting you edit my spaghetti code however you so please!

Little bonus feature: if you don't like the colours i do, you can just edit the colour variables in the java file at the very start of the program, you should be able to infer what the names refer to (or just trial and error it, it's not that bad trust me I trial-and-errored it too)

Anyways this will be my little ongoing pet for a bit, gl getting it to work if you have a use for it! Could be song lyrics, could be subtitles for videos, idrk I just hadn't been able to find something like this online so I made this!


For a little sneaksies peaksies at what's coming up, here's my todo list:

todo (in order of doing):
Change esc from quit to pause
If paused, make esc AND enter AND a clickable menu resume
Add rewinding
Options menu support for colour scheme changing
Add support for non txt/mp3 files (make grid of clickables in options menu where 
             any number can be selected/deselected so that any can be searched)
             
Button on song selection screen or maybe options menu to reselect directory (for misinputs & altering old preferences)
Config file to remember preferences (including all options menu things, volume, & originally selected directory)

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
