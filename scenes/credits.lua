local composer = require("composer")
local widget = require("widget")

local W = display.contentWidth
local H = display.contentHeight

local scene = composer.newScene()

local sfxButton

function scene:create(event)
	local sceneGroup = self.view
	local creditsGroup = display.newGroup()
	
	sfxButton = audio.loadSound("audios/button.wav")
	
	local menuTitle = display.newText({
		x = W * .52,
		y = H * .185,
		align = "center",
		text = "CREDITS ",
		font = "airstrike.ttf",
		fontSize = 30,
	})
	menuTitle:setFillColor(.97, .95, 0)

	local background = display.newImageRect(creditsGroup, "images/background.jpg", display.actualContentWidth, H)
	background.x = W * .5
	background.y = H * .5

	local backButton = widget.newButton({
		defaultFile = "images/arrow-right.png",
		x = W*0.9,
		y = H*0.85,
		onRelease = function()
			audio.play(sfxButton)
			composer.gotoScene("scenes.menu", {time=500, effect="slideLeft"})
		end
	})
	
	display.newText({parent = creditsGroup, text = "Programming ", x = W * .25, y = H * .37, font = "airstrikebold.ttf", fontSize = 22})
	display.newText({parent = creditsGroup, text = "André Schuch ", x = W * .25, y = H * .47, font = "airstrike.ttf", fontSize = 16})
	display.newText({parent = creditsGroup, text = "Jonas Pohren ", x = W * .25, y = H * .545, font = "airstrike.ttf", fontSize = 16})
	
	display.newText({parent = creditsGroup, text = "Art ", x = W * .75, y = H * .37, font = "airstrikebold.ttf", fontSize = 22})
	display.newText({parent = creditsGroup, text = "Murilo Fazan ", x = W * .75, y = H * .47, font = "airstrike.ttf", fontSize = 16})
	display.newText({parent = creditsGroup, text = "Sérgio Alves ", x = W * .75, y = H * .545, font = "airstrike.ttf", fontSize = 16})
	
	display.newText({parent = creditsGroup, text = "Coordinator ", x = W * .5, y = H * .7, font = "airstrikebold.ttf", fontSize = 22})
	display.newText({parent = creditsGroup, text = "Eduardo 'EdH' Muller ", x = W * .5, y = H * .775, font = "airstrike.ttf", fontSize = 16})
	
	sceneGroup:insert(creditsGroup)
	sceneGroup:insert(backButton)
	sceneGroup:insert(menuTitle)
end

scene:addEventListener("create",scene)

return scene