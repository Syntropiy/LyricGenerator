# LyricGenerator
a converter that turns unsynchronized .txt files into music synced .lrc files

This was a quick sketch done in processing (if you need to build for a non windows64 version, just use the pde & processing), pardon the completely inefficient and janky code, I made this at like 4am and havn't used java for a hot minute :p

Description:
Takes an input .txt file that contains lyrics separated out by line (like you pasted it in from like Genius or something and removed the [verse x] parts, or like you had musicbee (with the lyrics reloaded plugin) autogenerate the lyric file to an mp3.

*There must be a .mp3 file in the same directory as the .txt file with the same name for the program to work*

The program then displays the lyrics to the song, and upon pressing the enter key, the song will start playing. Once the song has begun, any future enter key taps until the final lyric will progress to the next lyric, saving the timestamp input. Think of it like hitting enter to start playback, and then playing a simple rhythm game where you tap enter when the lyrics come up in the song! Should be pretty intuitive.
Once the last lyric is complete, it will not automatically save - 
- press  '1' to save the lrc and select another song
- press '2' to not save the lrc and to restart the song, to re-try generation (unfortunately sleepy me decided to only have '2' work after the last lyric is run, so if you mess up you need to quickly shuffle through all the lyrics remaining by spamming enter). 
- press '3' at any time to exit the program & save the lrc - I didn't test what happens if you do that while in the middle of the lyrics, probably an out of bounds error, or maybe it would just display as a bunch of null lines. I can't really be bothered to check.

Though the program only takes .mp3 files, you can just alter the program to handle a different audio format - just control f in the code for .mp3 and edit the once instance of the string appearing to be whatever extention you want. 

if something's wrong with the program then it shouldn't be too hard to change it, it's only one file after all, though i didn't really make this with the intent of the code ever being viewed by human eyes again so it may be convoluted or just real inefficient or hard to read. It was late, i just fiddled with values until I stopped getting out of bounds errors and the lrc generated properly.
