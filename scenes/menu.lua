display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local scene = composer.newScene()

local sfxButton
local sfxMenuMusic

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

local function audioButton(self, event)
	audioOn.isVisible = not audioOn.isVisible
    audioOff.isVisible = not audioOff.isVisible
    audioHandler(true)
    audio.play(sfxButton,{channel=6})
    return true
end

function scene:create(event)
	local sceneGroup = self.view

	audio.reserveChannels(6)

	sfxButton = audio.loadSound("audios/button.wav")
	sfxMenuMusic = audio.loadStream("audios/musicMenu.wav")

	local background = display.newImageRect(sceneGroup, "images/main-menu.jpg", display.actualContentWidth, H)
	background.x = W * .5
	background.y = H * .5

	local startButton = widget.newButton(
		{
			x = W/2,
			y = H*.5,
			width = 250,
			height = 50,
			shape = "roundedRect",
			cornerRadius = 15,
			fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
			label = "PLAY ",
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			font = "airstrike.ttf",
			fontSize = 40,
			onPress = function ()
				audio.play(sfxButton,{channel=6})
				composer.gotoScene("scenes.menuCharacterSelection", {time=500, effect="slideLeft"})
			end
		}
	)
	
	local creditsButton = widget.newButton(
		{
			x = W/2,
			y = H*.79,
			width = 160,
			height = 30,
			shape = "roundedRect",
			cornerRadius = 12,
			fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
			label = "CREDITS ",
			labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
			font = "airstrike.ttf",
			fontSize = 22,
			onPress = function ()
				audio.play(sfxButton,{channel=6})
				composer.gotoScene("scenes.credits", {time=500, effect="slideRight"})
			end
		}
	)

	audioOn = display.newImage(sceneGroup, "images/audioOn.png", W*.95, H*.80)
	audioOn.width, audioOn.height = W*.15, W*.15
	
	audioOff = display.newImage(sceneGroup, "images/audioOff.png", W*.95, H*.80)
	audioOff.width, audioOff.height = W*.15, W*.15

	audioOn:addEventListener("tap", audioButton)
	audioOff:addEventListener("tap", audioButton)

	sceneGroup:insert(startButton)
	sceneGroup:insert(creditsButton)
end

function scene:show(event)
	if event.phase == "will" then
		system.deactivate('multitouch')
		audio.setVolume(0.15,{channel =1})

		if saveState.getValue("isAudioOn")==true then
			audioOn.isVisible = true
			audioOff.isVisible = false
		else
			audioOn.isVisible = false
			audioOff.isVisible = true
		end

		audioHandler()		
	elseif event.phase == "did" then
		
		local previous = composer.getSceneName("previous")
		if previous ~= nil then
			composer.removeScene(composer.getSceneName("previous"))
		end
		if not audio.isChannelActive(1) then
    		audio.play(sfxMenuMusic, {channel = 1, loops = -1})
    		audio.setVolume(0.15,{channel =1})
		end
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene

