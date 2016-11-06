display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()
local currentLevel

local totalCoins

function scene:create(event)
	local sceneGroup = self.view
	currentLevel = event.params or 1
	totalCoins = saveState.getValue("stage"..currentLevel.."totalCoins")

	--TEXTO DE VICTORY

	victoryText = display.newText("YOU DID IT!",W/2,H*.15,native.systemFontBold,40)
	victoryText:setFillColor(0,1,0)

	coinsTakenText = display.newText(sceneGroup,"COINS: "..saveState.getValue("stage"..currentLevel.."Coins").." / "..totalCoins,W/4,H*.32,native.systemFontBold,25)
	scoreText = display.newText(sceneGroup,"SCORE: "..saveState.getValue("stage"..currentLevel.."Score"),(W/4)*3,H*.32,native.systemFontBold,25)


	-- BOTAO DE RETRY

	nextStageButton = widget.newButton(
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
				composer.gotoScene("scenes.game", {time=500, effect="slideRight", params=currentLevel+1})
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

