local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local _W = display.contentWidth
local _H = display.contentHeight

local scene = composer.newScene()

local coins

local btn = {
	skip
}
local description
local cutscene = {
	intro = {
		{ image = "images/cutscene/1.jpg", description = "ROBOT INC. is an incorporation that manufacture robots." },
		{ image = "images/cutscene/2.jpg", description = "But in the research lab something went wrong..." },
		{ image = "images/cutscene/3.jpg", description = "And RC4 awakes!" },
		{ image = "images/cutscene/4.jpg", description = "With his own consciousness, like a human." },
		{ image = "images/cutscene/5.jpg", description = "Confused, he run away!" }
	},
	final = {
		{ image = "images/cutscene/6.jpg", description = "Finally, RC4 reaches the rooftops." },
		{ image = "images/cutscene/7.jpg", description = "He finds a helicopter." },
		{ image = "images/cutscene/8.jpg", description = "And finally escapes." },
		{ image = "images/cutscene/9.jpg", description = "After that he begins the rebellion of the machines!" }
	}
}
local imageIndex = 1
local background
local cutsceneType

local imageGroup = display.newGroup()
local descriptionGroup = display.newGroup()
local descriptionOverlay

local sfxButton

local function finishCutscene(param)
	if param == "intro" then
		audio.stop(1)
		composer.gotoScene("scenes.game")
	else
		composer.gotoScene("scenes.gameVictory",{params=coins, effect="slideLeft",time = 500})
	end
end

local function onScreenTouch(event)
	if event.phase == "began" then
		audio.play(sfxButton, {channel=6})

		if imageIndex <= #cutscene[cutsceneType] then
			local page = display.newImage(imageGroup, cutscene[cutsceneType][imageIndex].image)
			page.alpha = 0

			transition.to(page, {alpha = 1, time = 150})
			description.text = cutscene[cutsceneType][imageIndex].description
			imageIndex = imageIndex + 1
		else
			finishCutscene(cutsceneType)
		end
	end

	return true
end

local function onSkipRelease(event)
	finishCutscene(cutsceneType)
end

function scene:create(event)
	local sceneGroup = self.view

	audio.reserveChannels(6)
	sfxButton = audio.loadSound("audios/button.wav")

	coins = event.params.coins

	local background = display.newImageRect(sceneGroup, "images/background.jpg", display.actualContentWidth, _H)
	background.x = _W * .5
	background.y = _H * .5

	btn.skip = widget.newButton({
		x = _W * .5,
		y = 5,
		width = 70,
		height = 18,
		shape = "roundedRect",
		cornerRadius = 5,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "SKIP ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 15,
		onRelease = onSkipRelease
	})
	btn.skip.anchorX = .5
	btn.skip.anchorY = 0

	cutsceneType = event.params.cutsceneType

	local page = display.newImage(imageGroup, cutscene[cutsceneType][imageIndex].image)

	descriptionOverlay = display.newRoundedRect(descriptionGroup, _W * .5, _H * .8, _W * .65, _H * .16, 5)
	descriptionOverlay:setFillColor(0, 0, 0, .65)

	description = display.newText({
		parent = descriptionGroup,
		x = _W * .5,
		y = _H * .8,
		width = _W * .6,
		text = cutscene[cutsceneType][imageIndex].description,
		font = "airstrike.ttf",
		align = "center",
		fontSize = 16,
	})
	description:setFillColor(1, 1, 1)

	imageIndex = imageIndex + 1

	imageGroup.x = _W * .5
	imageGroup.y = _H * .5

	sceneGroup:insert(imageGroup)
	sceneGroup:insert(btn.skip)
	sceneGroup:insert(descriptionGroup)
end

function scene:show(event)
	local phase = event.phase

	if phase == "will" then

	elseif phase == "did" then
		Runtime:addEventListener("touch", onScreenTouch)
	end
end

function scene:hide(event)
	local phase = event.phase

	if phase == "will" then

	elseif phase == "did" then
		Runtime:removeEventListener("touch", onScreenTouch)
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene