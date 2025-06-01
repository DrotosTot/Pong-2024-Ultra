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
