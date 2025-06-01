Rem AY-3-8500 gameselector
Rem DrotosTot 2024.

$regfile = "attiny2313.dat"
'$lib "mcsbyte.lbx"
$crystal = 4000000
$hwstack = 40
$swstack = 16
$framesize = 24

Rem Port configuration
Config PortA.0 = Output ' TIL302: F
Config PortA.1 = Output ' TIL302: E

Config PortB = &B11111111
DdrB = &B11111111
Config PortB.0 = Output ' TIL302: D
Config PortB.1 = Output ' TIL302: C
Config PortB.2 = Output ' TIL302: B
Config PortB.3 = Output ' TIL302: G
Config PortB.4 = Output ' TIL302: A
Config PortB.5 = Output ' I2C SDA
Config PortB.6 = Output ' AVR Audio out
Config Portb.7 = Output ' I2C SCL

Seg_a Alias Portb.4
Seg_b Alias Portb.2
Seg_c Alias Portb.1
Seg_d Alias Portb.0
Seg_e Alias PortA.1
Seg_f Alias PortA.0
Seg_g Alias Portb.3

Config PortD = &B10111111
DdrD = &B10111111
Config PortD.0 = Output ' Game: Practice
Config PortD.1 = Output ' Game: Squash
Config PortD.2 = Output ' Game: Soccer
Config PORTd.3 = Output ' Game: Tennis
Config PortD.4 = Output ' Game: Riffle 1
Config PortD.5 = Output ' Game: Riffle 2
Config PinD.6 = Input   ' Games sel button

Rem I2C
Config Sda = Portb.5
Config Scl = Portb.7

Rem Audio output
Avr_audio Alias Pinb.6

Rem Pushbutton
Game_sel Alias PinD.6

Rem Variables
Dim Cntr as byte
Dim Current_game as byte
Dim Cntr2 as byte

Rem Modulator init with test pattern
Current_game = &B01100111
Gosub Modulator_init

Rem Into on LED display
Gosub Show_intro

Rem Modulator init w/o test pattern
Current_game = &B00100111
Gosub Modulator_init

Cntr2 = 1

Current_game = 1
Gosub Display_number

Rem Main
Do
   If Game_sel = 0 Then
      Incr Cntr2
      If Cntr2 = 5 Then
         Cntr2 = 1
         Gosub Show_UHF
         Current_game = 1
         Gosub Game_change
      Else
         Gosub Game_change
      Endif
   Else
      Cntr2 = 1
   Endif
Loop
End

Rem Subroutines
Modulator_init:
   I2cinit
   I2cstart
' MC44BC374TD address (Samsung RMUP74055WM modulator)
' Keep in mind: TD/T1 has reverse OSC bit!
   I2cwbyte &HCA
   waitms 10
' C1:  1   0  SO   0   PS   X3 X2 0
   I2cwbyte &B10000000
   waitms 10
' C0: PWC OSC ATT SFD1 SFD0 0  X5 X4
   I2cwbyte &B01001000
   waitms 10
Rem Set modulator to UHF41 (631.25 MHz/0,25MHz = 2525 => FM: 100111 FL: 011101)
Rem Fact: my father was born in 1941... :-)
' FM
'   I2cwbyte &B00100111
   I2cwbyte Current_game
   waitms 10
' FL
   I2cwbyte &B01110100
   waitms 10
   I2cstop
Return

Show_intro:
   Restore Intro
   For Cntr=1 to 10
      Read Current_game
      Gosub Display_number
      waitms 400
   Next
Return

Show_UHF:
   Restore Uhf_ch
   For Cntr=1 to 6
      Read Current_game
      Gosub Display_number
      waitms 400
   Next
Return

Game_change:
   Seg_a = 1
   Seg_b = 1
   Seg_c = 1
   Seg_d = 1
   Seg_e = 1
   Seg_f = 1
   Seg_g = 1

   Incr Current_game
   If Current_game>7 Then Current_game=1
   Game_sel = 1

   Sound Avr_audio , 600 , 100

   waitms 300
   Gosub Display_number
Return

Display_number:
   Select Case current_game
      case 0:
         Seg_a = 0
         Seg_b = 0
         Seg_c = 0
         Seg_d = 0
         Seg_e = 0
         Seg_f = 0
         Seg_g = 1
      case 1:
         Seg_a = 1
         Seg_b = 0
         Seg_c = 0
         Seg_d = 1
         Seg_e = 1
         Seg_f = 1
         Seg_g = 1
         PortD = &B11111110
      case 2:
         Seg_a = 0
         Seg_b = 0
         Seg_c = 1
         Seg_d = 0
         Seg_e = 0
         Seg_f = 1
         Seg_g = 0
         PortD = &B11111101
      case 3:
         Seg_a = 0
         Seg_b = 0
         Seg_c = 0
         Seg_d = 0
         Seg_e = 1
         Seg_f = 1
         Seg_g = 0
         PortD = &B11111011
      case 4:
         Seg_a = 1
         Seg_b = 0
         Seg_c = 0
         Seg_d = 1
         Seg_e = 1
         Seg_f = 0
         Seg_g = 0
         PortD = &B11110111
      case 5:
         Seg_a = 0
         Seg_b = 1
         Seg_c = 0
         Seg_d = 0
         Seg_e = 1
         Seg_f = 0
         Seg_g = 0
         PortD = &B11101111
      case 6:
         Seg_a = 0
         Seg_b = 1
         Seg_c = 0
         Seg_d = 0
         Seg_e = 0
         Seg_f = 0
         Seg_g = 0
         PortD = &B11011111
      case 7:
         Seg_a = 0
         Seg_b = 0
         Seg_c = 0
         Seg_d = 1
         Seg_e = 1
         Seg_f = 1
         Seg_g = 1
         PortD = &B11111111
      case 8:
         Seg_a = 0
         Seg_b = 0
         Seg_c = 0
         Seg_d = 0
         Seg_e = 0
         Seg_f = 0
         Seg_g = 0
      case 9:
         Seg_a = 0
         Seg_b = 0
         Seg_c = 0
         Seg_d = 1
         Seg_e = 0
         Seg_f = 0
         Seg_g = 0
      case else:
         Seg_a = Current_game.0
         Seg_b = Current_game.1
         Seg_c = Current_game.2
         Seg_d = Current_game.3
         Seg_e = Current_game.4
         Seg_f = Current_game.5
         Seg_g = Current_game.6
   End Select
Return

Rem Segment order: Xgfedcba
Intro:
Data &B10001100, &B11000000, &B11001000, &B11000010, &B11111111, &B10100100, &B11000000, &B10100100, &B10011001, &B11111111

Uhf_ch:
Data &B11000001, &B10001001, &B10001110, &B10011001, &B11111001, &B11111111
