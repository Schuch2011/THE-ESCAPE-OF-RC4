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
		y = _H * .22,
		width = 320,
		height = 50,
		shape = "roundedRect",
		cornerRadius = 15,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "RESUME ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 35,
		onRelease = function()
			audio.play(sfxButton)
			composer.hideOverlay("fade", 200)
		end
	})

	local parent = composer.getScene("scenes.game")

	local restartButton = widget.newButton({
		x = _W * .5,
		y = _H * .485,
		width = 320,
		height = 50,
		shape = "roundedRect",
		cornerRadius = 15,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "RESTART ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 35,
		onRelease = function()
			parent:finishGame()
			audio.play(sfxButton)
			composer.gotoScene("scenes.retry")
		end
	})

	local backToMenuButton = widget.newButton({
		x = _W * .5,
		y = _H * .75,
		width = 320,
		height = 50,
		shape = "roundedRect",
		cornerRadius = 15,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "BACK TO MENU ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 35,
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