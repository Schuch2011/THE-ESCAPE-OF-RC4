display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local sfxButton

function scene:create(event)
	local sceneGroup = self.view

	sfxButton = audio.loadSound("audios/button.wav")

	local background = display.newRect(sceneGroup, W/2, H/2, W*1.2, H)
	background:setFillColor(67/255, 107/255, 149/255) 

	local gameTitle = display.newText(sceneGroup,"THE ESCAPE OF RC4",W/2,H*.35,native.systemFontBold,40)
	gameTitle:setFillColor(1)

	local startButton = widget.newButton(
		{
			x = W/2,
			y = H*.65,
			shape = "roundedRect",
			width = W*.6,
			height = H*.20,
			cornerRadius = 15,
			label= "PLAY",
			font = native.systemFontBold,
			fontSize = 35,
			labelColor = { default={0}, over={0} },
			fillColor = { default={0,1,0}, over={0,1,0} },
			strokeWidth = 3,
			strokeColor = { default={0}, over={0} },
			onPress = function ()
				audio.play(sfxButton)
				composer.gotoScene("scenes.menuCharacterSelection", {time=500, effect="slideLeft"})
			end
		}
	)
	
	local creditsButton = widget.newButton(
		{
			x = W/2,
			y = H*.85,
			shape = "roundedRect",
			width = W*.3,
			height = H*.1,
			cornerRadius = 10,
			label= "CREDITS",
			font = native.systemFontBold,
			fontSize = 15,
			labelColor = { default={0}, over={0} },
			fillColor = { default={0,1,0}, over={0,1,0} },
			strokeWidth = 2,
			strokeColor = { default={0}, over={0} },
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
	if event.phase == "did" then
		local previous = composer.getSceneName("previous")
		if previous ~= nil then
			composer.removeScene(composer.getSceneName("previous"))
		end
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

return scene

