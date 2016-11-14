display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()
local scrollView

local slotSelected = 1
local initXPos = 0
local xView = 0
local difX = 0

local sfxButton

local function onLevelButtonRelease(event)
	audio.play(sfxButton)
	scrollView:removeSelf()
	scrollView=nil
	composer.setVariable("selectedStage", event.target.id)
	composer.gotoScene("scenes.game")
end

local function scrollListener(event)
	local phase = event.phase
	
	if ( phase == "began" ) then
		initXPos = scrollView:getContentPosition()
	end
	
	if ( phase == "ended" ) then
		xView = scrollView:getContentPosition()
		difX = initXPos-xView

		if (difX > 40) then
			if (slotSelected<4) then
				scrollView:scrollToPosition			
				{
   					x = -W+initXPos,
   					time = 200,
				}
				slotSelected = slotSelected +1 
			else
				scrollView:scrollToPosition			
				{
   					x = initXPos,
   					time = 200,
				}
			end
		elseif (difX < -40) then
			if (slotSelected>1) then
				scrollView:scrollToPosition			
				{
   					x = initXPos+W,
   					time = 200,
				}
				slotSelected = slotSelected - 1 
			else
				scrollView:scrollToPosition			
				{
   					x = initXPos,
   					time = 200,
				}
			end
		else
			scrollView:scrollToPosition			
			{
   				x = initXPos,
   				time = 200,
			}
		end
	end
	return true
end


function scene:create(event)
	local sceneGroup = self.view
	local buttonGroup = display.newGroup()

	sfxButton = audio.loadSound("audios/button.wav")

	scrollView = widget.newScrollView({
		left = 0,
		top = 0,
		width = W,
		height = H,
		verticalScrollDisabled = true,		
		horizontalScrollDisabled = false,
		listener = scrollListener,
		leftPadding = W*0,
		rightPadding = W*0.25,
		hideBackground = true
	})

	local backButton = widget.newButton({
		defaultFile = "images/backButton.png",
		width = H*.22, height = H*.22,
		x = W*0.1, y = H*0.85,
		onRelease = function()
			audio.play(sfxButton)
			scrollView:removeSelf()
			scrollView=nil
			composer.gotoScene("scenes.menuCharacterSelection", {time=500, effect="slideRight"})
		end
	})
	buttonGroup:insert(backButton)

	saveState.save({["stage1".."totalCoins"] = 8})
	saveState.save({["stage2".."totalCoins"] = 8})
	saveState.save({["stage3".."totalCoins"] = 8})
	saveState.save({["stage4".."totalCoins"] = 8})

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
			shape = "roundedRect",
			cornerRadius = 10,
			width = W*.45, height = H*.35,
			x = W*0.5+(i-1)*W, y = H*.45,
			onRelease = onLevelButtonRelease,
		})


		local text = display.newText({
				parent = sceneGroup,
				text = "STAGE "..i.."\nCOINS: "..maxCoinsTaken.." / "..saveState.getValue("stage"..i.."totalCoins").."\nHIGHSCORE: "..maxHighscore, 
				x = W*0.5+(i-1)*W, 
				y = H*.8, 
				font = native.systemFontBold, 
				fontSize = 25,
				align = "center"
			})
		text:setFillColor(1)

		scrollView:insert(text)
		scrollView:insert(button)
	end

	local menuTitle = display.newText("STAGE SELECTION",W/2,H*.15,native.systemFontBold,30)
	menuTitle:setFillColor(1)

	sceneGroup:insert(menuTitle)
	sceneGroup:insert(scrollView)
	sceneGroup:insert(buttonGroup)
end

scene:addEventListener("create",scene)

return scene



