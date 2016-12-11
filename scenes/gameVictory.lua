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
	local coinsTaken = event.params or 0
	sfxButton = audio.loadSound("audios/button.wav")

	local background = display.newImageRect(sceneGroup, "images/background-3.jpg", display.actualContentWidth, H)
	background.x = W * .5
	background.y = H * .5

	--DESBLOQUEAR PRÓXIMA FASE

	if composer.getVariable("isStage"..(currentLevel+1).."Unlocked_") ~= true then
		composer.setVariable("isStage"..(currentLevel+1).."Unlocked_", true)
		saveState.save{["isStage"..(currentLevel+1).."Unlocked"] = true}
	end

	--TEXTO DE VICTORY

	local victoryText = display.newText({
		x = W * .52,
		y = H * .15,
		width = W * .4,
		align = "center",
		text = currentLevel == 0 and "TRAINNING COMPLETE! " or ("STAGE " .. currentLevel .. " COMPLETE! "),
		font = "airstrike.ttf",
		fontSize = 30,
	})
	victoryText:setFillColor(.97, .95, 0)

	if currentLevel ~= 0 then
		local temp = saveState.getValue("stage"..currentLevel.."Score") or 0

		local coinsTakenText = display.newText(sceneGroup,"COINS: "..coinsTaken.." / "..totalCoins .. " ",W/4,H*.34,"airstrikebold.ttf",25)
		local scoreText = display.newText(sceneGroup,"SCORE: ".. (temp or 0) .. " ",(W/4)*3,H*.34,"airstrikebold.ttf",25)
	end

	if currentLevel ~= 4 then
		local nextStageButton = widget.newButton(
			{
				x = W/2,
				y = H*.55,
				width = 320,
				height = 55,
				shape = "roundedRect",
				cornerRadius = 15,
				fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
				label = "NEXT STAGE ",
				labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
				font = "airstrike.ttf",
				fontSize = 35,
				onPress = function ()
					audio.play(sfxButton)
					composer.setVariable("selectedStage",currentLevel+1)
					if currentLevel + 1 == 1 then
						composer.gotoScene("scenes.cutscene", {effect="slideLeft",time = 500, params = {cutsceneType = "intro"}})
					else
						composer.gotoScene("scenes.game", {time=500, effect="slideRight"})
					end
				end
			}
		)
		sceneGroup:insert(nextStageButton)
	end

	-- BOTAO DE VOLTAR AO MENU

	local backButton = widget.newButton(
		{
			x = W/2,
			y = currentLevel == 4 and H * .55 or H*.80,
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
				audio.play(sfxButton)
				composer.gotoScene("scenes.menu", {time=500, effect="slideRight"})
			end
		}
	)


	sceneGroup:insert(backButton)
	sceneGroup:insert(victoryText)
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
					local tempTotalCoins = composer.getVariable("stage"..j.."TotalCoins") or 0
					coinsRemaining = coinsRemaining + tempTotalCoins
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