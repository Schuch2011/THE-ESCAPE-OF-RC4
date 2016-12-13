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

	audio.reserveChannels(6)
	sfxButton = audio.loadSound("audios/button.wav")

	--TEXTO DE GAME OVER

	local gameOverText = display.newText({
		x = W * .52,
		y = H * .185,
		align = "center",
		text = "GAME OVER ",
		font = "airstrike.ttf",
		fontSize = 30,
	})
	gameOverText:setFillColor(.97, .95, 0)

	local background = display.newImageRect(sceneGroup, "images/background.jpg", display.actualContentWidth, H)
	background.x = W * .5
	background.y = H * .5

	-- BOTAO DE RETRY

	local retryButton = widget.newButton(
		{
			x = W/2,
			y = H*.425,
			width = 320,
			height = 50,
			shape = "roundedRect",
			cornerRadius = 15,
			fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
			label = "RETRY ",
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			font = "airstrike.ttf",
			fontSize = 35,
			onPress = function ()
				audio.play(sfxButton, {channel=6})
				composer.gotoScene("scenes.game", {time=500, effect="slideRight"})
			end
		}
	)

	-- BOTAO DE VOLTAR AO MENU

	local backButton = widget.newButton(
		{
			x = W/2,
			y = H*.7,
			width = 320,
			height = 50,
			shape = "roundedRect",
			cornerRadius = 15,
			fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
			label = "BACK TO MENU ",
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			font = "airstrike.ttf",
			fontSize = 35,
			onPress = function ()
				audio.play(sfxButton, {channel=6})
				composer.gotoScene("scenes.menu", {time=500, effect="slideRight"})
			end
		}
	)

	sceneGroup:insert(retryButton)
	sceneGroup:insert(backButton)
	sceneGroup:insert(gameOverText)
end

function scene:show(event)
	if event.phase == "did" then
		composer.removeScene("scenes.game")
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene

