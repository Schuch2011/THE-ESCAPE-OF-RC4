display.setStatusBar( display.HiddenStatusBar )

local composer = require("composer")
composer.recycleOnSceneChange = true

composer.gotoScene("menu",{time=500, effect="slideLeft"})

