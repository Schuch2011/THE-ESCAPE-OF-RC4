local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local _W = display.contentWidth
local _H = display.contentHeight

local scene = composer.newScene()

local isClosing = false

-- AUDIOS

local sfxButton
local audioOn
local audioOff

local function audioHandler(invert)
	local isOn = saveState.getValue("isAudioOn") 
	if isOn == nil then isOn=true end
	if invert==true then
		if isOn==true then	isOn=false	else 	isOn=true 	end
	end
	if isOn then audio.setVolume(1) else audio.setVolume(0) end
	saveState.save{["isAudioOn"]=isOn}
end

local function audioButton(event)
	if (event.phase == "began") then
		audioOn.isVisible = not audioOn.isVisible
    	audioOff.isVisible = not audioOff.isVisible
    	audioHandler(true)
    	audio.play(sfxButton)    	
    end
    return true
end

function scene:create(event)
	local sceneGroup = self.view

	audio.reserveChannels(7)

	sfxButton = audio.loadSound("audios/button.wav")
	
	local background = display.newRect(_W * .5, _H * .5, display.actualContentWidth, display.actualContentHeight)
	background:setFillColor(0, 0, 0, .8)
	
	local resumeButton = widget.newButton({
		x = _W * .4,
		y = _H * .22,
		width = 320,
		height = 50,
		shape = "roundedRect",
		cornerRadius = 15,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "RESUME ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 35,
		onRelease = function()
			audio.play(sfxButton, {channel=6})
			composer.hideOverlay("fade", 200)
		end
	})

	local parent = composer.getScene("scenes.game")

	local restartButton = widget.newButton({
		x = _W * .4,
		y = _H * .485,
		width = 320,
		height = 50,
		shape = "roundedRect",
		cornerRadius = 15,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "RESTART ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 35,
		onRelease = function()
			parent:finishGame()
			audio.play(sfxButton, {channel=6})
			composer.gotoScene("scenes.retry")
		end
	})

	local backToMenuButton = widget.newButton({
		x = _W * .4,
		y = _H * .75,
		width = 320,
		height = 50,
		shape = "roundedRect",
		cornerRadius = 15,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "BACK TO MENU ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 35,
		onRelease = function()
			isClosing = true
			audio.play(sfxButton, {channel=6})
			audio.stop(1)
			composer.gotoScene("scenes.menu","slideRight",500)
		end
	})

	sceneGroup:insert(background)

	audioOn = display.newImage(sceneGroup, "images/audioOn.png", _W*.93, _H*.20)
	audioOn.width, audioOn.height = _W*.15, _W*.15
	
	audioOff = display.newImage(sceneGroup, "images/audioOff.png", _W*.93, _H*.20)
	audioOff.width, audioOff.height = _W*.15, _W*.15

	audioOn:addEventListener("touch", audioButton)
	audioOff:addEventListener("touch", audioButton)	

	sceneGroup:insert(resumeButton)
	sceneGroup:insert(restartButton)
	sceneGroup:insert(backToMenuButton)
end

function scene:show(event)
	if event.phase == "will" then
		if saveState.getValue("isAudioOn")==true then
			audioOn.isVisible = true
			audioOff.isVisible = false
		else
			audioOn.isVisible = false
			audioOff.isVisible = true
		end
	end
	if event.phase == "did" then
		if not audio.isChannelActive(1) then
    		audio.play(sfxMenuMusic, {channel = 1, loops = -1})
    		audio.setVolume(0.15,{channel =1})
		end
	end
end

function scene:hide(event)
	local phase = event.phase
	local parent = event.parent
	if phase == "did" and isClosing == false then
		parent:resumeGame()
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene