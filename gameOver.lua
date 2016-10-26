display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view

	--TEXTO DE GAME OVER

	gameOverText = display.newText("GAME OVER",W/2,H*.15,native.systemFontBold,40)
	gameOverText:setFillColor(1,0,0)

	-- BOTAO DE RETRY

	retryButton = widget.newButton(
		{
			x = W/2,
			y = H*.47,
			shape = "roundedRect",
			width = W*.6,
			height = H*.20,
			cornerRadius = 15,
			label= "RETRY",
			font = native.systemFontBold,
			fontSize = 35,
			labelColor = { default={0}, over={0} },
			fillColor = { default={0,1,0}, over={0,1,0} },
			strokeWidth = 3,
			strokeColor = { default={0}, over={0} },
			onPress = function ()
				composer.gotoScene("game", {time=500, effect="slideRight"})
			end
		}
	)

	-- BOTAO DE VOLTAR AO MENU

	backButton = widget.newButton(
		{
			x = W/2,
			y = H*.8,
			shape = "roundedRect",
			width = W*.6,
			height = H*.20,
			cornerRadius = 15,
			label= "BACK TO MENU",
			font = native.systemFontBold,
			fontSize = 35,
			labelColor = { default={0}, over={0} },
			fillColor = { default={0,1,0}, over={0,1,0} },
			strokeWidth = 3,
			strokeColor = { default={0}, over={0} },
			onPress = function ()
				composer.gotoScene("menu", {time=500, effect="slideRight"})
			end
		}
	)

	sceneGroup:insert(gameOverText)
	sceneGroup:insert(retryButton)
	sceneGroup:insert(backButton)
end

scene:addEventListener("create",scene)

return scene

