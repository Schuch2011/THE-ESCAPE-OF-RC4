display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local sfxButton

function scene:create(event)
	local sceneGroup = self.view

	sfxButton = audio.loadSound("audios/button.wav")

	local background = display.newImageRect(sceneGroup, "images/main-menu.jpg", display.actualContentWidth, H)
	background.x = W * .5
	background.y = H * .5

	local startButton = widget.newButton(
		{
			x = W/2,
			y = H*.5,
			defaultFile = "images/play-button.png",
			onPress = function ()
				audio.play(sfxButton)
				composer.gotoScene("scenes.menuCharacterSelection", {time=500, effect="slideLeft"})
			end
		}
	)
	
	local creditsButton = widget.newButton(
		{
			x = W/2,
			y = H*.79,
			defaultFile = "images/credits-button.png",
			onPress = function ()
				audio.play(sfxButton)
				composer.gotoScene("scenes.credits", {time=500, effect="slideRight"})
			end
		}
	)

	sceneGroup:insert(startButton)
	sceneGroup:insert(creditsButton)
end

function scene:show(event)
	if event.phase == "did" then
		local previous = composer.getSceneName("previous")
		if previous ~= nil then
			composer.removeScene(composer.getSceneName("previous"))
		end
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene

