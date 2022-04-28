#NoEnv
#Warn

FileDelete stop.txt



; these lines can be copied and the ip number changed
Run ping.exe 127.0.0.1			; loop localhost
Run ping.exe 192.168.0.1		; loop local ip number
Run ping.exe 8.8.8.8			; loop google dns
