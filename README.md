# Pong-2024-Ultra
An old classic reimagined

Long story short: My father passed away some years ago and I found some AY-3-8500 ICs in his apartment. I remember that he also built the game in the early '80s, so I thought I'd recreate it in his memory.
 
Requirements:
- full-color (based on exrom's solution: https://github.com/exrom/rgbpong)
- composite, S-video and RF output (with sound)
- speaker output
- sound can be muted
- game selection and display with AVR
- when selecting a game, a beep should play combined with the sound of the game
- support for TIL302 (and compatible), TIL311 and HD44780 LCD displays
- long pressing the game selector displays UHF channel
- status of switches indicated by two-color LEDs
- i used mice as "controllers", their buttons can be used to serve in case of manual serving
- shoot inputs are also available on the controller's connector

# 1., Power supply, clock generators
Originally, the AY-3-8500 IC was designed for a 6-volt battery operation. Therefore, a a minimum 7.5VDC, maximum 9VDC transformer power source is recommended as the main power source.
The 6VDC (shown as VCC on the schematic) is produced by a 7806 voltage regulator IC, the 5VDC (shown as +5V on the schematic) required for the other circuits is produced by an MC33269-5.0 LDO IC.
Due to the heat, it is recommended to use a heatsink for the 7806.
![Power supply](/images/1_sch_psu.png)

Two clock signals are required for operation, 2 MHz for the game IC and one for the composite video signal. A clock signal of 14.31818 MHz must be generated for an NTSC, and 17.734480 MHz for a PAL video signal. A corresponding quartz crystal must be used in the clock signal generator.
![Clock generators](/images/1_sch_clock.png)

# 2., Main game circuit
Following the recommendations of the manufacturer General Instrument, the circuits of the main IC were designed accordingly. The sound amplifier and the speaker with the mode change switches and the indicator LEDs were placed on this part of the drawing. The socket for the controllers is located there, also.
 
# 3., Game selector
This section is what's controlling everything. 
While looking for a suitable yaxley switch to select the game, it occurred to me how easy it would be to entrust the task to a microcontroller. This sub-circuit designed to control LCD and LED displays and the RF modulator, generate sound and of course the game IC. As you can see in the drawing, in order to use different displays, different components must be soldered and the firmware corresponding to the display must be used.
The controller uses the internal RC clock generator, so most I/O pins can be used and an ATTINY2313 is more than enough.
 
# 4., AV output
The minimalistic design of the audio output does not deserve as many words as the video output.
The original game could be connected to the TV with an RF modulator, solutions equipped with a composite video signal only appeared later. Since I really liked Exrom's idea for the color display, I stuck to this solution. The color version had an RGB output, which came in handy, since the AD724/AD725 RGB -> PAL/NTSC encoders have such an input. I had an AD725 at the bottom of the drawer, so that was included in the final schematic. This solved the composite and S-video output. The composite video and audio outputs are connected to the RF modulator, which I disassembled from a satellite receiver unit. The RF modulator has a Motorola MC44BC374T1 IC. This modulator is made with several pin assignments (and ICs), so you should choose carefully.
 
# 5., Controllers
What could be better than using broken mice to hide the game controller inside them? Their cabling is long enough and contains enough wires to allow manual serving to be controlled by pressing mouse buttons.
In the future, I would like to implement controlling with digital potentiometers, so I have already designed the PCB in such a way that it will also be suitable for this.
 
# 6., AVR Firmware
I wrote the AVR control program in BASCOM, so it is very easy for others to understand and modify.
Due to the size of the program, it is sufficient to use the demo version. I have attached the TIL302 display control version to the project, it can be easily converted to additional displays.
 
# 7., PCB
For a retro look, there are no SMD components on the PCB component side, only on the solder side. The PCB was manufactured by JLCPCB.
 
# 8., Case
The mechanical protection of the game is protected from the bottom and top by laser-cut plexiglass. The speaker can be screwed onto the bottom cover.
