display.setStatusBar( display.HiddenStatusBar )
system.activate('multitouch')

local composer = require("composer")
composer.recycleOnSceneChange = true

totalCoins = 0

composer.gotoScene("menu",{time=500, effect="slideLeft"})

