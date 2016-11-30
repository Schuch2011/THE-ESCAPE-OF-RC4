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

local isChar1Unlocked
local isChar2Unlocked
local isChar3Unlocked
local isChar4Unlocked

local parDistance = W*.5

local sfxButton
local sfxSwipe

local function onCharacterButtonTouch(event)
	local phase = event.phase
    if ( phase == "moved" ) then
        local dx = math.abs( ( event.x - event.xStart ) )
        if ( dx > 10 ) then
            scrollView:takeFocus( event )
        end
    elseif ( phase == "ended" ) then
    	print(composer.getVariable("isChar"..event.target.id.."Unlocked_"))
    	if (composer.getVariable("isChar"..event.target.id.."Unlocked_") == true) then
			audio.play(sfxButton)
			scrollView:removeSelf()
			scrollView=nil
			composer.setVariable("selectedCharacter" , event.target.id)
			composer.gotoScene("scenes.menuStageSelection", {effect = "slideLeft", time = 500})
		end
    end
    return true
end

local function scrollListener(event) -- CONTROLA O SCROLL DA SELEÇÃO DOS PERSONAGENS 
	local phase = event.phase

	if ( phase == "began" ) then
		initXPos = scrollView:getContentPosition()
	end
	if ( phase == "ended" ) then
		xView = scrollView:getContentPosition()
		difX = initXPos-xView

		if (difX > 20) then
			if (slotSelected<4) then
				audio.play(sfxSwipe)
				slotSelected = slotSelected +1 
				scrollView:scrollToPosition			
				{
   					x = (slotSelected-1)*-parDistance,
   					time = 200,
				}
			else
				scrollView:scrollToPosition			
				{
   					x = (slotSelected-1)*-parDistance,
   					time = 200,
				}
			end
		elseif (difX < -20) then
			if (slotSelected>1) then
				slotSelected = slotSelected - 1 
				audio.play(sfxSwipe)
				scrollView:scrollToPosition			
				{
   					x = (slotSelected-1)*-parDistance,
   					time = 200,
				}
			else
				scrollView:scrollToPosition			
				{
   					x = (slotSelected-1)*-parDistance,
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

	local background = display.newRect(sceneGroup, W/2, H/2, W*1.2, H)
	background:setFillColor(67/255, 107/255, 149/255) 

	scrollView = widget.newScrollView({
		x = W/2,
		y = H/2,
		width = W*1.2,
		height = H,
		verticalScrollDisabled = true,		
		horizontalScrollDisabled = false,
		listener = scrollListener,
		hideBackground = true,
	})

	local backButton = widget.newButton({
		defaultFile = "images/backButton.png",
		width = H*.22, height = H*.22,
		x = W*0.1, y = H*0.85,
		onRelease = function() 
			audio.play(sfxButton)
			scrollView:removeSelf()
			scrollView=nil
			composer.gotoScene("scenes.menu", {time=500, effect="slideRight"})
		end
	})
	buttonGroup:insert(backButton)

	for i = 1, 4 do
		local cWidth = 1
		local cHeight = 1

		local isCharUnlocked

		local charName
		if i == 1 then
			charName = "RC4-101"
			isCharUnlocked = saveState.getValue("isChar"..i.."Unlocked") or true
			composer.setVariable("isChar"..i.."Unlocked_",isCharUnlocked)
		elseif i == 2 then
			charName = "RC4-CRV1"
			isCharUnlocked = saveState.getValue("isChar"..i.."Unlocked") or false
			composer.setVariable("isChar"..i.."Unlocked_",isCharUnlocked)
		elseif i == 3 then
			charName = "RC4-FR53"
			isCharUnlocked = saveState.getValue("isChar"..i.."Unlocked") or false
			composer.setVariable("isChar"..i.."Unlocked_",isCharUnlocked)
		elseif i == 4 then
			charName = "RC4-SPY14"
			isCharUnlocked = saveState.getValue("isChar"..i.."Unlocked") or false
			composer.setVariable("isChar"..i.."Unlocked_",isCharUnlocked)
		end
		

		if i==1 then
			cWidth, cHeight = W*.15, H*.5
		elseif i==2 then
			cWidth, cHeight = W*.23, H*.5
		elseif i==3 then
			cWidth, cHeight = W*.15, H*.5
		elseif i==4 then
			cWidth, cHeight = W*.15, H*.5
		end



		local button = widget.newButton({
			id = i,			
			defaultFile = "images/characterSelection/character_"..i.."_"..tostring(isCharUnlocked)..".png",
			width = cWidth, height = cHeight,
			x = W*0.64+(i-1)*parDistance, y = H*.55,
			onEvent = onCharacterButtonTouch,
		})

		local text = display.newText(
		{
			parent = sceneGroup,
			text = charName,
			x = W*0.64+(i-1)*parDistance, 
			y = H*.9, 
			font = native.systemFontBold, 
			fontSize = 25,
			align = "center"
		})
		if isCharUnlocked == false then
			text.text = "LOCKED"
			text:setFillColor(230/255,43/255,30/255)
		else
			text:setFillColor(1)
		end



		scrollView:insert(text)
		scrollView:insert(button)
	end

	local menuTitle = display.newText("CHARACTER SELECTION",W/2,H*.15,native.systemFontBold,30)
	menuTitle:setFillColor(1)

	sceneGroup:insert(menuTitle)
	sceneGroup:insert(scrollView)
	sceneGroup:insert(buttonGroup)
end

scene:addEventListener("create",scene)

return scene



