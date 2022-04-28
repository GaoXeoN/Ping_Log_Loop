#NoEnv
#Warn All, MsgBox

t1 = ""
t2 = ""
t3 = ""
t4 = 0

if 0 < 1
{
	MsgBox Missing parameter (like "192.168.0.1")  ;More info about the program and help
	ExitApp
}

if 0 > 1
{
	MsgBox Too many parameters, just one IP number nothing else (like "192.168.0.1")
	ExitApp
}

t1 = %1%
StringReplace, t1, t1,",, All

; checks an ip number per second in a loop
; saves the result in a txt file with date and ip number as name (a log file)
; ends when the file stop.txt is in the same folder

Loop
{
    FormatTime, t2,,yy-MM-dd
    FormatTime, t3,,yy-MM-dd HH:mm:ss
    t4 := Ping(t1)
    ;t4 := Ping("127.0.0.1")
    FileAppend, %t3%%A_Space%%t4%`r`n, %t2%%A_Space%%t1%.txt
    IfExist, stop.txt
        ExitApp
    Sleep, 1000
}
	


; following code is taken from github (and slightly modified)
; https://gist.github.com/Uberi/5987142

Ping(Address,Timeout = 800,ByRef Data = "",Length = 0,ByRef Result = "",ByRef ResultLength = 0)
{
    ; loads necessary windows libraries
    If DllCall("LoadLibrary","Str","ws2_32","UPtr") = 0 ;NULL
        throw Exception("Could not load WinSock 2 library.")
    If DllCall("LoadLibrary","Str","icmp","UPtr") = 0 ;NULL
        throw Exception("Could not load ICMP library.")

    ; retrieves the ip address
    NumericAddress := DllCall("ws2_32\inet_addr","AStr",Address,"UInt")
    If NumericAddress = 0xFFFFFFFF ;INADDR_NONE
        throw Exception("Could not convert IP address string to numeric format.")

    ; opens a connection (for communication)
	 hPort := DllCall("icmp\IcmpCreateFile","UPtr")  ;open port
    If hPort = -1  ;INVALID_HANDLE_VALUE
        throw Exception("Could not open port.")

    ; creates a ping package
    StructLength := 270 + (A_PtrSize * 2)  ;ICMP_ECHO_REPLY structure
    VarSetCapacity(Reply,StructLength)
    Count := DllCall("icmp\IcmpSendEcho"
        ,"UPtr",hPort            ;ICMP handle
        ,"UInt",NumericAddress   ;IP address
        ,"UPtr",&Data            ;request data
        ,"UShort",Length         ;length of request data
        ,"UPtr",0                ;pointer to IP options structure
        ,"UPtr",&Reply           ;reply buffer
        ,"UInt",StructLength     ;length of reply buffer
        ,"UInt",Timeout)         ;ping timeout

    ; check that the package is the correct length
    ; if not: make a corrected one
    If NumGet(Reply,4,"UInt") = 11001 ;IP_BUF_TOO_SMALL
    {
        StructLength *= Count
        VarSetCapacity(Reply,StructLength)
        DllCall("icmp\IcmpSendEcho"
            ,"UPtr",hPort            ;ICMP handle
            ,"UInt",NumericAddress   ;IP address
            ,"UPtr",&Data            ;request data
            ,"UShort",Length         ;length of request data
            ,"UPtr",0                ;pointer to IP options structure
            ,"UPtr",&Reply           ;reply buffer
            ,"UInt",StructLength     ;length of reply buffer
            ,"UInt",Timeout)         ;ping timeout
    }

    ; if the connection could not be closed
    If !DllCall("icmp\IcmpCloseHandle","UInt",hPort) ;close port
        throw Exception("Could not close port.")

    ; something went wrong    
    Status := NumGet(Reply,4,"UInt")
    If Status In 11002,11003,11004,11005,11010 ;IP_DEST_NET_UNREACHABLE, IP_DEST_HOST_UNREACHABLE, IP_DEST_PROT_UNREACHABLE, IP_DEST_PORT_UNREACHABLE, IP_REQ_TIMED_OUT
    {
        VarSetCapacity(Result,0)
        Return, -1
    }

    ; could not send the package
    If NumGet(Reply,4,"UInt") != 0 ;IP_SUCCESS
        throw Exception("Could not send echo.")

    ; has received a response and returns the result
    ResultLength := NumGet(Reply,12,"UShort")
    VarSetCapacity(Result,ResultLength)
    DllCall("RtlMoveMemory","UPtr",&Result,"UPtr",NumGet(Reply,16),"UPtr",ResultLength)
    Return, NumGet(Reply,8,"UInt")
}
