display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()

local character 

local function onLevelButtonRelease(event)
	scrollView:removeSelf()
	scrollView=nil
	composer.gotoScene("scenes.game", {params = event.target.id})
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

	character = event.params

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



