display.setStatusBar( display.HiddenStatusBar )
system.activate('multitouch')

local composer = require("composer")
composer.recycleOnSceneChange = true

composer.gotoScene("scenes.menu",{time=500, effect="slideLeft"})

