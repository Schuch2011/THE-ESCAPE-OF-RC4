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
		y = _H * .27,
		defaultFile = "images/continue-button.png",
		onRelease = function()
			audio.play(sfxButton)
			composer.hideOverlay("fade", 200)
		end
	})

	local parent = composer.getScene("scenes.game")

	local restartButton = widget.newButton({
		x = _W * .5,
		y = _H * .55,
		defaultFile = "images/retry-button.png",
		onRelease = function()
			parent:finishGame()
			audio.play(sfxButton)
			composer.gotoScene("scenes.retry")
		end
	})

	local backToMenuButton = widget.newButton({
		x = _W * .5,
		y = _H * .8,
		defaultFile = "images/back-to-menu-button.png",
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