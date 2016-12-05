display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()
local currentLevel

local sfxButton

function scene:create(event)
	local sceneGroup = self.view
	currentLevel = composer.getVariable("selectedStage")
	sfxButton = audio.loadSound("audios/button.wav")

	--TEXTO DE GAME OVER

	--local gameOverText = display.newText("GAME OVER",W/2,H*.15,native.systemFontBold,40)
	--gameOverText:setFillColor(1,0,0)

	local background = display.newImageRect(sceneGroup, "images/background-game-over.jpg", display.actualContentWidth, H)
	background.x = W * .5
	background.y = H * .5

	-- BOTAO DE RETRY

	local retryButton = widget.newButton(
		{
			x = W/2,
			y = H*.425,
			defaultFile = "images/retry-button.png",
			onPress = function ()
				audio.play(sfxButton)
				composer.gotoScene("scenes.game", {time=500, effect="slideRight"})
			end
		}
	)

	-- BOTAO DE VOLTAR AO MENU

	local backButton = widget.newButton(
		{
			x = W/2,
			y = H*.7,
			defaultFile = "images/back-to-menu-button.png",
			onPress = function ()
				audio.play(sfxButton)
				composer.gotoScene("scenes.menu", {time=500, effect="slideRight"})
			end
		}
	)

	--sceneGroup:insert(gameOverText)
	sceneGroup:insert(retryButton)
	sceneGroup:insert(backButton)
end

function scene:show(event)
	if event.phase == "did" then
		composer.removeScene("scenes.game")
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene

