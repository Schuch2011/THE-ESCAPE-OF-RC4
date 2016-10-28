display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()


function scene:create(event)
	local sceneGroup = self.view

	gameTitle = display.newText("THE ESCAPE OF RC4",W/2,H*.35,native.systemFontBold,40)
	gameTitle:setFillColor(1)

	startButton = widget.newButton(
		{
			x = W/2,
			y = H*.75,
			shape = "roundedRect",
			width = W*.6,
			height = H*.20,
			cornerRadius = 15,
			label= "PLAY",
			font = native.systemFontBold,
			fontSize = 35,
			labelColor = { default={0}, over={0} },
			fillColor = { default={0,1,0}, over={0,1,0} },
			strokeWidth = 3,
			strokeColor = { default={0}, over={0} },
			onPress = function ()
				composer.gotoScene("menuCharacterSelection", {time=500, effect="slideLeft"})
			end
		}
	)

	sceneGroup:insert(startButton)
	sceneGroup:insert(gameTitle)
end

scene:addEventListener("create",scene)

return scene

