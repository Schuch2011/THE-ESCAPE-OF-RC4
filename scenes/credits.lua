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
	
	local backButton = widget.newButton({
		defaultFile = "images/backButton.png",
		width = - H*.22,
		height = H*.22,
		x = W*0.9,
		y = H*0.85,
		onRelease = function()
			audio.play(sfxButton)
			composer.gotoScene("scenes.menu", {time=500, effect="slideLeft"})
		end
	})
	
	display.newText({parent = creditsGroup, text = "Programming", x = W * .5, y = H * .1, font = native.systemFontBold, fontSize = 22})
	display.newText({parent = creditsGroup, text = "André Schuch", x = W * .5, y = H * .2, font = native.systemFont, fontSize = 16})
	display.newText({parent = creditsGroup, text = "Jonas Pohren", x = W * .5, y = H * .275, font = native.systemFont, fontSize = 16})
	
	display.newText({parent = creditsGroup, text = "Art", x = W * .5, y = H * .45, font = native.systemFontBold, fontSize = 22})
	display.newText({parent = creditsGroup, text = "Murilo Fazan", x = W * .5, y = H * .55, font = native.systemFont, fontSize = 16})
	display.newText({parent = creditsGroup, text = "Sérgio Alves", x = W * .5, y = H * .625, font = native.systemFont, fontSize = 16})
	
	display.newText({parent = creditsGroup, text = "Coordinator", x = W * .5, y = H * .8, font = native.systemFontBold, fontSize = 22})
	display.newText({parent = creditsGroup, text = "Eduardo Muller", x = W * .5, y = H * .875, font = native.systemFont, fontSize = 16})
	
	sceneGroup:insert(creditsGroup)
	sceneGroup:insert(backButton)
end

scene:addEventListener("create",scene)

return scene