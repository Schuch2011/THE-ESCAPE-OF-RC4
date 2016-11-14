display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()
local currentLevel

local totalCoins

local sfxButton

function scene:create(event)
	local sceneGroup = self.view
	currentLevel = composer.getVariable("selectedStage") or 1
	totalCoins = saveState.getValue("stage"..currentLevel.."totalCoins")
	local coinsTaken = event.params
	sfxButton = audio.loadSound("audios/button.wav")

	--TEXTO DE VICTORY

	local victoryText = display.newText("YOU DID IT!",W/2,H*.15,native.systemFontBold,40)
	victoryText:setFillColor(0,1,0)

	local coinsTakenText = display.newText(sceneGroup,"COINS: "..coinsTaken.." / "..totalCoins,W/4,H*.32,native.systemFontBold,25)
	local scoreText = display.newText(sceneGroup,"SCORE: "..saveState.getValue("stage"..currentLevel.."Score"),(W/4)*3,H*.32,native.systemFontBold,25)


	-- BOTAO DE RETRY

	local nextStageButton = widget.newButton(
		{
			x = W/2,
			y = H*.53,
			shape = "roundedRect",
			width = W*.6,
			height = H*.20,
			cornerRadius = 15,
			label= "NEXT STAGE",
			font = native.systemFontBold,
			fontSize = 35,
			labelColor = { default={0}, over={0} },
			fillColor = { default={0,1,0}, over={0,1,0} },
			strokeWidth = 3,
			strokeColor = { default={0}, over={0} },
			onPress = function ()
				audio.play(sfxButton)
				composer.setVariable("selectedStage",currentLevel+1)
				composer.gotoScene("scenes.game", {time=500, effect="slideRight"})
			end
		}
	)

	-- BOTAO DE VOLTAR AO MENU

	local backButton = widget.newButton(
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
				audio.play(sfxButton)
				composer.gotoScene("scenes.menu", {time=500, effect="slideRight"})
			end
		}
	)

	sceneGroup:insert(victoryText)
	sceneGroup:insert(nextStageButton)
	sceneGroup:insert(backButton)
end

scene:addEventListener("create",scene)

return scene

