display.setStatusBar( display.HiddenStatusBar )

_achievement = require("classes.achievement").new()

local composer = require("composer")

local stage = display.getCurrentStage()
stage:insert(composer.stage)
stage:insert(_achievement)

composer.gotoScene("scenes.intro")

