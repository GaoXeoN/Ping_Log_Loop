# Pings and Logs

Scripts that ping and log files to check that the network is working.

Small and simple script that takes an ip number as a parameter and pings it once a second.
The answer is saved in a file with today's date as the name (when there is a new date there will be a new file).
The script terminates if the file "stop.txt" is in the same folder.
There is a simple stop script that simply creates a "stop.txt" file.
Then there is a run script that runs one or more copies of the script (the exe file).
The run script can be edited so you can ping as many places as you want (look in the run script)

It should be mentioned that part of the code is downloaded from github (https://gist.github.com/Uberi/5987142)
Slightly modified but I don't take any credit for that piece of code.

# How to use it:

1) You need to download and install AutoHotkey (https://www.autohotkey.com)
2) Download all files from this repository (make sure that all files are in the same folder and that the folder is not read-only)
3) Open the file *\_run_script.ahk* with notepad and change the ip numbers to what you want to ping, if you want to ping more ip numbers, just copy a new line (the whole line) and if you want fewer, just delete unwanted lines
4) Then run (double click) *\_run_skript.ahk* (it vill run until you stop it or the os rebot or stop working)
5) To stop the ping script you just run *\_stop_script.ahk* (or put a text file named stop.txt in the same folder)

If you don't like to run my *ping.exe* you can can create one my right click on *ping.ahk* and click *Compile Script* (AutoHotkey need to be installed)
