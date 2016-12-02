local composer = require("composer")
local widget = require("widget")

local _W = display.contentWidth
local _H = display.contentHeight

local scene = composer.newScene()

local isClosing = false

-- AUDIOS

local sfxButton

function scene:create(event)
	local sceneGroup = self.view

	sfxButton = audio.loadSound("audios/button.wav")
	
	local background = display.newRect(_W * .5, _H * .5, display.actualContentWidth, display.actualContentHeight)
	background:setFillColor(0, 0, 0, .8)
	
	local resumeButton = widget.newButton({
		x = _W * .5,
		y = _H * .2,
		width = _W * .6,
		height = _H * .2,
		shape = "roundedRect",
		fillColor = {default = {0, 1, 0}, over = {0, 1, 0}},
		cornerRadius = 15,
		label = "RESUME",
		labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
		fontSize = 35,
		strokeWidth = 3,
		strokeColor = { default={0}, over={0} },
		font = native.systemFontBold,
		onRelease = function()
			audio.play(sfxButton)
			composer.hideOverlay("fade", 200)
		end
	})

	local parent = composer.getScene("scenes.game")

	local restartButton = widget.newButton({
		x = _W * .5,
		y = _H * .5,
		width = _W * .6,
		height = _H * .2,
		shape = "roundedRect",
		fillColor = {default = {0, 1, 0}, over = {0, 1, 0}},
		cornerRadius = 15,
		label = "RESTART",
		labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
		fontSize = 35,
		strokeWidth = 3,
		strokeColor = { default={0}, over={0} },
		font = native.systemFontBold,
		onRelease = function()
			parent:finishGame()
			audio.play(sfxButton)
			composer.gotoScene("scenes.retry")
		end
	})

	local backToMenuButton = widget.newButton({
		x = _W * .5,
		y = _H * .8,
		width = _W * .6,
		height = _H * .2,
		shape = "roundedRect",
		fillColor = {default = {0, 1, 0}, over = {0, 1, 0}},
		cornerRadius = 15,
		label = "BACK TO MENU",
		labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
		fontSize = 35,
		strokeWidth = 3,
		strokeColor = { default={0}, over={0} },
		font = native.systemFontBold,
		onRelease = function()
			isClosing = true
			audio.stop(1)
			composer.gotoScene("scenes.menu","slideRight",500)
		end
	})
	
	sceneGroup:insert(background)
	sceneGroup:insert(resumeButton)
	sceneGroup:insert(restartButton)
	sceneGroup:insert(backToMenuButton)
end

function scene:hide(event)
	local phase = event.phase
	local parent = event.parent

	if phase == "did" and isClosing == false then
		parent:resumeGame()
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)

return scene