'--------------------------------------------------------------
'                   Thomas Jensen | stdout.no
'--------------------------------------------------------------
'  file: AVR_MOOD_LIGHT
'  date: 13/01/2007
'--------------------------------------------------------------
$regfile = "m8def.dat"
$crystal = 1000000
Config Watchdog = 1024
Config Portb = Output
Config Portd = Input
Dim A As Byte , R As Integer , Speed As Integer , Fade As Integer , Random As Integer
Dim Hyst1 As Byte , Hyst2 As Byte , Hyst3 As Byte

'Config Timer0 = Pwm , Prescale = 64 , Compare A Pwm = Clear Down , Pwm = On
'Tccr0 = &B01101011
'Tccr0 = &B01100100
'Tccr1b = &B01101011
'Config Timer0 = Pwm , Prescale = 8 , Compare A Pwm = Clear Down , Compare B Pwm = Clear Down
Config Timer1 = Pwm , Pwm = 8 , Prescale = 1 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up
Config Timer2 = Pwm , Prescale = 1 , Compare Pwm = Clear Down

'input
'0. Speed 1
'1. Fade
'2. Crossover
'3. Mode

Ddrb.1 = 1
Ddrb.2 = 1
Ddrb.3 = 1

Ocr2 = 0
Pwm1a = 255
Pwm1b = 255

Main:
Do

For A = 1 To 255
Decr Pwm1a
Incr Ocr2
Waitms Fade
Next A

Gosub Switches

For A = 1 To 255
Decr Pwm1b
Incr Pwm1a
Waitms Fade
Next A

Gosub Switches

For A = 1 To 255
Decr Ocr2
Incr Pwm1b
Waitms Fade
Next A

Gosub Switches

Loop

Switches:
If Pind.0 = 0 Then Speed = 500 Else Speed = 200
If Pind.1 = 0 Then Fade = 5 Else Fade = 15
If Pind.2 = 0 Then Fade = 0
If Pind.3 = 0 Then Goto Hysterisk

Random = Rnd(speed)

For R = 1 To Random
Waitms 10
Next R

Return

Hysterisk:
Pwm1a = 255
Pwm1b = 255
Ocr2 = 255
Do
If Pind.3 = 1 Then
     Pwm1a = 255
     Pwm1b = 255
     Ocr2 = 0
     Goto Main
   End If

Hyst1 = Rnd(255)
For A = 1 To Hyst1
Decr Pwm1a
Waitms Fade
Next A

Hyst2 = Rnd(255)
For A = 1 To Hyst2
Decr Pwm1b
Waitms Fade
Next A

Hyst3 = Rnd(255)
For A = 1 To Hyst3
Decr Ocr2
Waitms Fade
Next A

'senk
For A = 1 To Hyst1
Incr Pwm1a
Waitms Fade
Next A

For A = 1 To Hyst2
Incr Pwm1b
Waitms Fade
Next A

For A = 1 To Hyst3
Incr Ocr2
Waitms Fade
Next A

Gosub Switches
Loop
End