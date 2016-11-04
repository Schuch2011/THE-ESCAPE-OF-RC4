display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view

	backButton = display.newImageRect("images/backButton.png",H*.22, H*.22)
	backButton.x, backButton.y = W*0.1,H*0.85

	menuTitle = display.newText("CHARACTER SELECTION",W/2,H*.1,native.systemFontBold,30)
	menuTitle:setFillColor(1)

	character1Square = display.newRect(W/2,H*.43,W*.08,H*.3)
	character1Square:setFillColor(0,1,0)

	character1Text = display.newText("CHARACTER 1",W/2,H*.75,native.systemFontBold,20)
	character1Text:setFillColor(1)

	sceneGroup:insert(backButton)
	sceneGroup:insert(menuTitle)
	sceneGroup:insert(character1Square)
	sceneGroup:insert(character1Text)

	local function onBackButtonTouch( event )
    	if ( event.phase == "began" ) then
    		composer.gotoScene("menu", {time=500, effect="slideRight"})
    	elseif ( event.phase == "ended" and canJump==true) then
    	end
    	return true
	end

	local function onCharacterTouch( event )
    	if ( event.phase == "began" ) then
    		composer.gotoScene("menuStageSelection", {time=500, effect="slideLeft"})
    	elseif ( event.phase == "ended" and canJump==true) then
    	end
    	return true
	end

	character1Square:addEventListener("touch",onCharacterTouch)
	backButton:addEventListener("touch",onBackButtonTouch)
end

scene:addEventListener("create",scene)

return scene

