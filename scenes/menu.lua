display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local sfxButton
local sfxMenuMusic

function scene:create(event)
	local sceneGroup = self.view

	audio.reserveChannels(1)

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
				audio.play(sfxButton)
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
				audio.play(sfxButton)
				composer.gotoScene("scenes.credits", {time=500, effect="slideRight"})
			end
		}
	)

	sceneGroup:insert(startButton)
	sceneGroup:insert(creditsButton)
end

function scene:show(event)
	if event.phase == "will" then
		system.deactivate('multitouch')
		audio.setVolume(0.15,{channel =1})
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

