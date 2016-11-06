display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()

local function onCharacterButtonRelease(event)
	scrollView:removeSelf()
	scrollView=nil
	saveState.save({["selectedCharacter"]= event.target.id})
	composer.gotoScene("scenes.menuStageSelection", {effect = "slideLeft", time = 500})
end

local function scrollListener(event)
	local phase = event.phase
	if ( phase == "ended" ) then
		local xView, yView = scrollView:getContentPosition()
		xView = -1*(xView)
		local temp = math.floor(xView/(W/2))
		if (temp <= 0) then
			scrollView:scrollToPosition
			{
   				x = 0*W,
   				time = 200,
			}			
		elseif (temp == 1 or temp == 2) then
			scrollView:scrollToPosition
			{
   				x = -1*W,
   				time = 200,
			}	
		elseif (temp == 3 or temp == 4) then
			scrollView:scrollToPosition
			{
   				x = -2*W,
   				time = 200,
			}	
		elseif (temp >= 5) then
			scrollView:scrollToPosition
			{
   				x = -3*W,
   				time = 200,
			}	
		end
	end
	return true
end


function scene:create(event)
	local sceneGroup = self.view
	local buttonGroup = display.newGroup()

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
			scrollView:removeSelf()
			scrollView=nil
			composer.gotoScene("scenes.menu", {time=500, effect="slideRight"})
		end
	})
	buttonGroup:insert(backButton)

	for i = 1, 4 do
		local c1 = 1
		local c2 = 1
		local c3 = 1
		

		if i==1 then
			c1 = 1
			c2 = 0.5
			c3 = 0
		elseif i==2 then
			c1 = 0
			c2 = 1
			c3 = 0
		elseif i==3 then
			c1 = 1
			c2 = 0
			c3 = 0
		elseif i==4 then
			c1 = 1
			c2 = 1
			c3 = 0
		end

		local button = widget.newButton({
			id = i,			
			shape = "roundedRect",
			cornerRadius = 10,
			width = W*.15, height = H*.5,
			x = W*0.5+(i-1)*W, y = H*.55,
			onRelease = onCharacterButtonRelease,
			fillColor = { default={c1,c2,c3}, over={c1,c2,c3} }
		})

		local text = display.newText(
			{
				parent = sceneGroup,
				text = "CHARACTER "..i,
				x = W*0.5+(i-1)*W, 
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



