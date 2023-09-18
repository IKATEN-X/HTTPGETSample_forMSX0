10 'save"gettest.bas
20 CLEAR 800:SCREEN 2:DEFINTA-Y
30 NL$=CHR$(13)+CHR$(10)
40 PA$="msx/me/if/NET0/"  'path
50 E$(0)="yahoo.sr2"
60 E$(1)="b.sc2"
70 E$(2)="p1.sr2"
80 E$(3)="SO.SC2"
90 E$(5)="DR.SC2"
100 FOR W=0 TO 5
110 _IOTPUT(PA$+ "conf/addr","YOURWWWADDRESS")
120 _IOTPUT(PA$+ "conf/port",80)
130 _IOTPUT(PA$+ "connect",1)
140 '----------------------- check connect status
150 FOR I=0 TO 100:NEXT
160 E$(4)="DA.SC2"
170 _IOTGET(PA$+ "connect",S)
180 PRINT S
190 '----------------------- send message
200 PRINT NL$+"---- Send Message ----"
210 _IOTPUT(PA$+ "msg", "GET /~ikaten/"+E$(W)+" HTTP/1.1"+NL$)
220 _IOTPUT(PA$+ "msg", "Host: YOURWWWADDRESS"+NL$)
230 _IOTPUT(PA$+ "msg", ""+NL$)
250 '----------------------- receive message
260 _TURBO ON
270 DIM X(100),DP(100)
280 PA$="msx/me/if/NET0/":M=0:P=0:F=0
290 NL$=CHR$(13)+CHR$(10)
300 PRINT NL$+"---- Receive Message ----"
310 D$=PA$+"msg":DL=LEN(D$)
320 FORI=1 TO DL:DP(I)=ASC(MID$(D$,I,1)):NEXTI
330 '-------------------- IOTGET Return String Val
340 OUT8,&HE0:OUT8,1:OUT8,&H53
350 OUT8,&HC0::OUT8,DL:FORI=1 TO DL:OUT8,DP(I):NEXTI:OUT8,0:R=INP(8)
360 OUT8,&HE0:OUT8,1:OUT8,3:OUT8,&H80
370 L=INP(8)
380 'FOR I=0 TO 10:NEXT I
390 '-------------------- Data Analysis
400 FOR K=1 TO L:B=INP(8)
410     IF M<=10 THEN 440
420     IF P<&H1B7F OR P>&H2000 THEN VPOKE P,B
430     P=P+1:IF P>F THEN 550 ELSE 520
440     IF M=4 THEN M=M+1:GOTO 520
450     IF M=5 THEN S2$=RIGHT$("0"+HEX$(B),2):M=M+1:GOTO 520
460     IF M=6 THEN S1$=RIGHT$("0"+HEX$(B),2):P=VAL("&H"+S1$+S2$):PRINT "&H"+S1$+S2$:M=M+1:GOTO 520
470     IF M=7 THEN S4$=RIGHT$("0"+HEX$(B),2):M=M+1:GOTO 520
480     IF M=8 THEN S3$=RIGHT$("0"+HEX$(B),2):F=VAL("&H"+S3$+S4$):PRINT "&H"+S3$+S4$:M=M+1:GOTO 520
490     IF M=9 THEN S6$=RIGHT$("0"+HEX$(B),2):M=M+1:GOTO 520
500     IF M=10 THEN S5$=RIGHT$("0"+HEX$(B),2):S=VAL("&H"+S5$+S6$):PRINT "&H"+S5$+S6$:M=M+1:GOTO 520
510     IF ((M=0 OR M=2) AND B=13) OR ((M=1 OR M=3) AND B=10) THEN M=M+1:PRINT M ELSE M=0
520 NEXT K
530 IF STRIG(0) THEN 550
540 GOTO 340
550 _TURBO OFF
560 _IOTPUT(PA$+ "connect",0)
565 IF STRIG(0) THEN END
570 NEXT
580 GOTO 100
