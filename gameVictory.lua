display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
	local sceneGroup = self.view

	--TEXTO DE GAME OVER

	gameOverText = display.newText("YOU DID IT!",W/2,H*.15,native.systemFontBold,40)
	gameOverText:setFillColor(1)

	-- BOTAO DE RETRY

	retryButtonSquare = display.newRect(W/2,H*.47,W*.6,H*.20)
	retryButtonSquare:setFillColor(0,1,0)

	retryText = display.newText("RETRY",W/2,H*.47,native.systemFontBold,30)
	retryText:setFillColor(0)

	-- BOTAO DE VOLTAR AO MENU

	backButtonSquare = display.newRect(W/2,H*.8,W*.6,H*.20)
	backButtonSquare:setFillColor(0,1,0)

	backText = display.newText("BACK TO MENU",W/2,H*.8,native.systemFontBold,30)
	backText:setFillColor(0)

	--

	sceneGroup:insert(gameOverText)
	sceneGroup:insert(retryButtonSquare)
	sceneGroup:insert(retryText)
	sceneGroup:insert(backButtonSquare)
	sceneGroup:insert(backText)

	local function onRetryButtonTouch( event )
    	if ( event.phase == "began" ) then

    		composer.gotoScene("game", {time=500, effect="slideRight"})

    	elseif ( event.phase == "ended") then
    	end
    	return true
	end

	local function onBackButtonTouch( event )
    	if ( event.phase == "began" ) then

    		composer.gotoScene("menu", {time=500, effect="slideRight"})

    	elseif ( event.phase == "ended") then
    	end
    	return true
	end

	retryButtonSquare:addEventListener("touch",onRetryButtonTouch)
	backButtonSquare:addEventListener("touch",onBackButtonTouch)
end

function scene:show( event )
     
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
    	composer.removeScene("game")
    	--print("removeu")
    end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene

