display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()
local scrollView

local slotSelected = 0
local initXPos = 0
local xView = 0
local difX = 0

local parDistance = W*.6

local sfxButton
local sfxSwipe

local function onLevelButtonTouch(event)
	local phase = event.phase
    if ( phase == "moved" ) then
        local dx = math.abs( ( event.x - event.xStart ) )
        if ( dx > 10 ) then
            scrollView:takeFocus( event )
        end
    elseif ( phase == "ended" ) then
    	audio.play(sfxButton)
		scrollView:removeSelf()
		scrollView=nil
		composer.setVariable("selectedStage", event.target.id)
		composer.gotoScene("scenes.game")
    end
    return true
end

local function scrollListener(event)
	local phase = event.phase
	
	if ( phase == "began" ) then
		initXPos = scrollView:getContentPosition()
	end
	
	if ( phase == "ended" ) then
		xView = scrollView:getContentPosition()
		difX = initXPos-xView

		if (difX > 20) then
			if (slotSelected<4) then
				slotSelected = slotSelected +1 
				audio.play(sfxSwipe)
				scrollView:scrollToPosition			
				{
   					x = slotSelected*-parDistance,
   					time = 200,
				}
			else
				scrollView:scrollToPosition			
				{
   					x = slotSelected*-parDistance,
   					time = 200,
				}
			end
		elseif (difX < -20) then
			if (slotSelected>0) then
				slotSelected = slotSelected - 1 
				audio.play(sfxSwipe)
				scrollView:scrollToPosition			
				{
   					x = slotSelected*-parDistance,
   					time = 200,
				}

			else
				scrollView:scrollToPosition			
				{
   					x = slotSelected*-parDistance,
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
	sfxSwipe = audio.loadSound("audios/swipe.wav")

	scrollView = widget.newScrollView({
		x = W/2,
		y = H/2,
		width = W*1.2,
		height = H,
		verticalScrollDisabled = true,		
		horizontalScrollDisabled = false,
		listener = scrollListener,
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

	for i = 0, 4 do
		local level = require("levels."..i)
		local totalCoins = 0

		for j = 1, #level.layers[1].objects do
			local t = level.layers[1].objects[j]
			if t.type == "C" then
				totalCoins = totalCoins +1
			end
		end

		composer.setVariable("stage"..i.."TotalCoins",totalCoins)

		local stageName
		if i == 1 then
			stageName = "WAREHOUSE"
		elseif i == 2 then
			stageName = "FACTORY"
		elseif i == 3 then
			stageName = "SERVER'S ROOM"
		elseif i == 4 then
			stageName = "OFFICE"
		end

		if i==0 then
			local button = widget.newButton({
					id = i,			
					defaultFile = "images/thumbnails/"..i..".png",
					width = W*.45, height = H*.35,
					x = W*0.63+(i)*parDistance, y = H*.45,
					onEvent = onLevelButtonTouch,
			})

			local text = display.newText({
				parent = sceneGroup,
				text = "TRAINING ROOM", 
				x = W*0.63+(i)*parDistance, 
				y = H*.7, 
				font = native.systemFontBold, 
				fontSize = 25,
				align = "center"
			})
			text:setFillColor(1)

			scrollView:insert(text)
			scrollView:insert(button)

		else
			local maxCoinsTaken = saveState.getValue("stage"..i.."Coins") or 0
			local maxHighscore = saveState.getValue("stage"..i.."Score") or 0	
	
			local button = widget.newButton({
				id = i,			
				defaultFile = "images/thumbnails/"..i..".png",
				width = W*.45, height = H*.35,
				x = W*0.63+(i)*parDistance, y = H*.45,
				onEvent = onLevelButtonTouch,
			})

			local nameText = display.newText({
				parent = sceneGroup,
				text = stageName, 
				x = W*0.63+(i)*parDistance, 
				y = H*.70, 
				font = native.systemFontBold, 
				fontSize = 25,
				align = "center"
			})
			nameText:setFillColor(1)
	
			local text = display.newText({
				parent = sceneGroup,
				text = "COINS: "..maxCoinsTaken.." / "..totalCoins.."\nHIGHSCORE: "..maxHighscore, 
				x = W*0.63+(i)*parDistance, 
				y = H*.82, 
				font = native.systemFontBold, 
				fontSize = 15,
				align = "center"
			})
			text:setFillColor(1)

			scrollView:insert(nameText)
			scrollView:insert(text)
			scrollView:insert(button)
		end
	end

	local menuTitle = display.newText("STAGE SELECTION",W/2,H*.15,native.systemFontBold,30)
	menuTitle:setFillColor(1)

	sceneGroup:insert(menuTitle)
	sceneGroup:insert(scrollView)
	sceneGroup:insert(buttonGroup)
end

scene:addEventListener("create",scene)

return scene



