display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view

	backButton = display.newImageRect("images/backButton.png",H*.22, H*.22)
	backButton.x, backButton.y = W*0.1,H*0.85

	menuTitle = display.newText("STAGE SELECTION",W/2,H*.15,native.systemFontBold,30)
	menuTitle:setFillColor(1)

	character1Square = display.newRect(W/2,H*.55,W*.45,H*.35)
	character1Square:setFillColor(0,1,0)

	character1Text = display.newText("STAGE 1",W/2,H*.83,native.systemFont,25)
	character1Text:setFillColor(1)

	sceneGroup:insert(backButton)
	sceneGroup:insert(menuTitle)
	sceneGroup:insert(character1Square)
	sceneGroup:insert(character1Text)

	local function onBackButtonTouch( event )
    	if ( event.phase == "began" ) then
    		composer.gotoScene("menuCharacterSelection", {time=500, effect="slideRight"})
    	elseif ( event.phase == "ended" and canJump==true) then
    	end
    	return true
	end

	local function onButtonTouch( event )
    	if ( event.phase == "began" ) then
    		composer.gotoScene("game", {time=500, effect="slideLeft"})
    	elseif ( event.phase == "ended" and canJump==true) then

    	end
    	return true
	end

	character1Square:addEventListener("touch",onButtonTouch)
	backButton:addEventListener("touch",onBackButtonTouch)
end

scene:addEventListener("create",scene)

return scene

