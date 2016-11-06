display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()

local function onLevelButtonRelease(event)
	composer.gotoScene("scenes.game", {params = event.target.id})
end

function scene:create(event)
	local sceneGroup = self.view
	local buttonGroup = display.newGroup()

	local backButton = widget.newButton({
		defaultFile = "images/backButton.png",
		width = H*.22, height = H*.22,
		x = W*0.1, y = H*0.85,
		onRelease = function() 
			composer.gotoScene("scenes.menuCharacterSelection", {time=500, effect="slideRight"})
		end
	})
	buttonGroup:insert(backButton)

	saveState.save({["stage1".."totalCoins"] = 7})
	saveState.save({["stage2".."totalCoins"] = 7})
	saveState.save({["stage3".."totalCoins"] = 7})
	saveState.save({["stage4".."totalCoins"] = 7})

	for i = 1, 4 do
		if saveState.getValue("stage"..i.."Coins")==nil then
			saveState.save({["stage"..i.."Coins"] = 0})
		end
		if saveState.getValue("stage"..i.."Score")==nil then
			saveState.save({["stage"..i.."Score"] = 0})
		end
		local maxCoinsTaken = saveState.getValue("stage"..i.."Coins")
		local maxHighscore = saveState.getValue("stage"..i.."Score")
		local button = widget.newButton({
			id = i,			
			label = "STAGE "..i.."\nCOINS: "..maxCoinsTaken.." / "..saveState.getValue("stage"..i.."totalCoins").."\nHIGHSCORE: "..maxHighscore,
			labelColor = {default = {1}, over = {1}},
			font = native.systemFontBold,
			fontSize = 25,
			labelYOffset = 110,
			shape = "roundedRect",
			cornerRadius = 10,
			width = W*.45, height = H*.35,
			x = (W/2)*i, y = H*.6,
			onRelease = onLevelButtonRelease
		})
		buttonGroup:insert(button)
	end

	local menuTitle = display.newText("STAGE SELECTION",W/2,H*.15,native.systemFontBold,30)
	menuTitle:setFillColor(1)

	-- score.load()
	-- local stage1BestScore = score.get() or 0

	-- bestScoreText = display.newText(sceneGroup,"BEST SCORE: "..stage1BestScore.." / 7", W/2,H*0.7,native.systemFontBold,20)
	-- bestScoreText:setFillColor(1)

	--sceneGroup:insert(backButton)
	sceneGroup:insert(menuTitle)
	sceneGroup:insert(buttonGroup)
end

scene:addEventListener("create",scene)

return scene

