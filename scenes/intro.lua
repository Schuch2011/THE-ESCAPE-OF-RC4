display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")

local scene = composer.newScene()

local sfxMenuMusic

function scene:create(event)
	local sceneGroup = self.view

	audio.reserveChannels(1)

	sfxMenuMusic=audio.loadStream("audios/musicMenu.wav")
	audio.play(sfxMenuMusic, {channel = 1, loops = -1})
    audio.setVolume(0.1,{channel =1})

	local bg = display.newRect(sceneGroup, W/2, H/2, W*1.2, H)
	bg:setFillColor(1)

	local logo= display.newImage(sceneGroup, "images/intro.png",W/2, H/2)
	logo.xScale = .17
	logo.yScale = logo.xScale
	logo.alpha = 0
	transition.to(logo, {time=1500, alpha=1, onComplete= function()
		timer.performWithDelay(1200, function()
			transition.to(logo, {time=1000, alpha=0, onComplete = function()
				composer.gotoScene("scenes.menu", {time=400, effect="slideDown"})
			end})
		end)		
	end})
end

scene:addEventListener("create",scene)

return scene

