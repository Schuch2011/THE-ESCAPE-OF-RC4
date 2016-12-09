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
		{ image = "images/cutscene/1.jpg", description = "" },
		{ image = "images/cutscene/2.jpg", description = "" },
		{ image = "images/cutscene/3.jpg", description = "" },
		{ image = "images/cutscene/4.jpg", description = "" },
		{ image = "images/cutscene/5.jpg", description = "" }
	},
	final = {
		{ image = "images/cutscene/1.jpg", description = "" },
		{ image = "images/cutscene/2.jpg", description = "" },
		{ image = "images/cutscene/3.jpg", description = "" },
		{ image = "images/cutscene/4.jpg", description = "" }
	}
}
local currentImage
local imageIndex = 1
local background
local cutsceneType

local imageGroup = display.newGroup()

local sfxButton = audio.loadSound("audios/button.wav")

local function finishCutscene(param)
	if param == "intro" then
		saveState.save{["showIntroCutscene"] = false}
		audio.stop(1)
		composer.gotoScene("scenes.game")
	else
		saveState.save{["showFinalCutscene"] = false}
		composer.gotoScene("scenes.gameVictory",{params=coins, effect="slideLeft",time = 500})
	end
end

local function onScreenTouch(event)
	if event.phase == "began" then
		audio.play(sfxButton)

		if imageIndex <= #cutscene[cutsceneType] then
			currentImage = display.newImage(imageGroup, cutscene[cutsceneType][imageIndex].image)
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

	currentImage = display.newImage(imageGroup, cutscene[cutsceneType][imageIndex].image)

	description = display.newText({
		x = _W * .5,
		y = _H * .8,
		text = cutscene[cutsceneType][imageIndex].description,
		font = "airstrike.ttf",
		fontSize = 15,
	})
	description:setFillColor(1, 0, 0)

	imageIndex = imageIndex + 1

	imageGroup.x = _W * .5
	imageGroup.y = _H * .5

	sceneGroup:insert(imageGroup)
	sceneGroup:insert(btn.skip)
	sceneGroup:insert(description)
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