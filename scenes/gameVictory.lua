display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")
local loadsave = require("classes.loadsave")

local scene = composer.newScene()
local currentLevel

local totalCoins

local sfxButton

function scene:create(event)
	local sceneGroup = self.view
	currentLevel = composer.getVariable("selectedStage") or 1
	totalCoins = composer.getVariable("stage"..currentLevel.."TotalCoins") or 0
	local coinsTaken = event.params
	sfxButton = audio.loadSound("audios/button.wav")

	--DESBLOQUEAR PRÓXIMA FASE

	if composer.getVariable("isStage"..(currentLevel+1).."Unlocked_") ~= true then
		composer.setVariable("isStage"..(currentLevel+1).."Unlocked_", true)
		saveState.save{["isStage"..(currentLevel+1).."Unlocked"] = true}
	end

	--TEXTO DE VICTORY

	local victoryText = display.newText(sceneGroup,"YOU DID IT!",W/2,H*.25,native.systemFontBold,40)
	victoryText:setFillColor(0,1,0)
	if currentLevel == 4 then
		victoryText.text = "YOU FINALLY ESCAPE!"
	end


	if currentLevel ~= 0 then
		local coinsTakenText = display.newText(sceneGroup,"COINS: "..coinsTaken.." / "..totalCoins,W/4,H*.32,native.systemFontBold,25)
		local scoreText = display.newText(sceneGroup,"SCORE: "..saveState.getValue("stage"..currentLevel.."Score"),(W/4)*3,H*.32,native.systemFontBold,25)
		victoryText.y = H*.15
	end

	-- BOTAO DE RETRY

	if currentLevel ~= 4 then
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
		sceneGroup:insert(nextStageButton)
	end

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


	sceneGroup:insert(backButton)
end

function scene:show(event)
	if event.phase=="did" then
		composer.removeScene("scenes.game")
	--DESBLOQUEAR PERSONAGEM
		local gameTotalCoins = 0
		local totalCoinsCollected = 0

		for i=1, 4 do
			local stageCoinsCollected = saveState.getValue("stage"..i.."Coins") or 0
			totalCoinsCollected = totalCoinsCollected + stageCoinsCollected
		end

		local tempTable = {}

		tempTable = loadsave.loadTable("isCharUnlocked.json")

		for i=1, 4 do
			local coinsRemaining = 0
			for j=i-1, 1, -1 do
				if j~=0 then
					coinsRemaining = coinsRemaining + composer.getVariable("stage"..j.."TotalCoins")
				end
			end
			if totalCoinsCollected >= coinsRemaining and composer.getVariable("isChar"..i.."Unlocked_")~=true then
				tempTable[i] = true
				loadsave.saveTable(tempTable,"isCharUnlocked.json")
				composer.setVariable("isChar"..i.."Unlocked_",true)
				composer.showOverlay("scenes.characterUnlockedMenu", {effect = "fade", time = 200, isModal = true, params = i})			
			end
		end
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)


return scene

