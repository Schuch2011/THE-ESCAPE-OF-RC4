display.setStatusBar( display.HiddenStatusBar )
system.activate('multitouch')

local composer = require("composer")

composer.gotoScene("scenes.menu",{time=0, effect="slideLeft"})

