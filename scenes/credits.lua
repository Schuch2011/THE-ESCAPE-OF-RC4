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
	
	local background = display.newImageRect(creditsGroup, "images/background-credits.jpg", display.actualContentWidth, H)
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
	
	display.newText({parent = creditsGroup, text = "Programming", x = W * .25, y = H * .37, font = native.systemFontBold, fontSize = 22})
	display.newText({parent = creditsGroup, text = "André Schuch", x = W * .25, y = H * .47, font = native.systemFont, fontSize = 16})
	display.newText({parent = creditsGroup, text = "Jonas Pohren", x = W * .25, y = H * .545, font = native.systemFont, fontSize = 16})
	
	display.newText({parent = creditsGroup, text = "Art", x = W * .75, y = H * .37, font = native.systemFontBold, fontSize = 22})
	display.newText({parent = creditsGroup, text = "Murilo Fazan", x = W * .75, y = H * .47, font = native.systemFont, fontSize = 16})
	display.newText({parent = creditsGroup, text = "Sérgio Alves", x = W * .75, y = H * .545, font = native.systemFont, fontSize = 16})
	
	display.newText({parent = creditsGroup, text = "Coordinator", x = W * .5, y = H * .7, font = native.systemFontBold, fontSize = 22})
	display.newText({parent = creditsGroup, text = "Eduardo Muller", x = W * .5, y = H * .775, font = native.systemFont, fontSize = 16})
	
	sceneGroup:insert(creditsGroup)
	sceneGroup:insert(backButton)
end

scene:addEventListener("create",scene)

return scene