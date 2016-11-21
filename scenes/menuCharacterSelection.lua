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

local parDistance = W*.6

local sfxButton
local sfxSwipe

local function onCharacterButtonRelease(event)
	audio.play(sfxButton)
	scrollView:removeSelf()
	scrollView=nil
	composer.setVariable("selectedCharacter" , event.target.id)
	composer.gotoScene("scenes.menuStageSelection", {effect = "slideLeft", time = 500})
end

local function scrollListener(event) -- CONTROLA O SCROLL DA SELEÇÃO DOS PERSONAGENS 
	local phase = event.phase

	if ( phase == "began" ) then
		initXPos = scrollView:getContentPosition()
	end
	if ( phase == "ended" ) then
		xView = scrollView:getContentPosition()
		difX = initXPos-xView

		if (difX > 40) then
			if (slotSelected<4) then
				audio.play(sfxSwipe)
				scrollView:scrollToPosition			
				{
   					x = -parDistance+initXPos,
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
				audio.play(sfxSwipe)
				scrollView:scrollToPosition			
				{
   					x = initXPos+parDistance,
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
	sfxSwipe = audio.loadSound("audios/swipe.wav")

	scrollView = widget.newScrollView({
		left = 0,
		top = 0,
		width = W*1.2,
		height = H,
		verticalScrollDisabled = true,		
		horizontalScrollDisabled = false,
		listener = scrollListener,
		leftPadding = W*0,
		rightPadding = W*0.25,
		hideBackground = true,
		--friction = 10, 
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
			defaultFile = "images/characterSelection/character_"..i..".png",
			width = cWidth, height = cHeight,
			x = W*0.5+(i-1)*parDistance, y = H*.55,
			onRelease = onCharacterButtonRelease,
		})

		local text = display.newText(
			{
				parent = sceneGroup,
				text = "CHARACTER "..i,
				x = W*0.5+(i-1)*parDistance, 
				y = H*.9, 
				font = native.systemFontBold, 
				fontSize = 25,
				align = "center"
			}
				)
		text:setFillColor(1)

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



