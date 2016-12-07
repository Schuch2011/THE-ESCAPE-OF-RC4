local composer = require("composer")
local widget = require("widget")
local saveState = require("classes.preference")

local _W = display.contentWidth
local _H = display.contentHeight

local scene = composer.newScene()

local text = {
	page
}
local buttons = {
	skip, next, previous, start
}
local images = {
	intro = {
		"images/cutscene/1.jpg",
		"images/cutscene/2.jpg",
		"images/cutscene/3.jpg",
		"images/cutscene/4.jpg",
		"images/cutscene/5.jpg"
	}
}
local currentPage
local currentPageIndex = 1
local background

local sfxButton = audio.loadSound("audios/button.wav")

local pageGroup = display.newGroup()
local topGroup = display.newGroup()
local bottomGroup = display.newGroup()

local function onNextRelease()
	audio.play(sfxButton)

	currentPage:removeSelf()
	currentPageIndex = currentPageIndex + 1
	currentPage = display.newImage(pageGroup, images.intro[currentPageIndex])
	text.page.text = currentPageIndex .. " / " .. #images.intro

	buttons.previous.isVisible = true

	if currentPageIndex == #images.intro then
		buttons.next.isVisible = false
		buttons.start.isVisible = true
		buttons.skip.isVisible = false
	end
end

local function onPrevRelease()
	audio.play(sfxButton)

	currentPage:removeSelf()
	currentPageIndex = currentPageIndex - 1
	currentPage = display.newImage(pageGroup, images.intro[currentPageIndex])
	text.page.text = currentPageIndex .. " / " .. #images.intro

	buttons.next.isVisible = true
	buttons.start.isVisible = false
	buttons.skip.isVisible = true

	if currentPageIndex == 1 then
		buttons.previous.isVisible = false
	end
end

local function start()
	audio.play(sfxButton)

	saveState.save{["isCutscene"] = false}

	composer.gotoScene("scenes.game")
end

local function onSkipRelease()
	start()
end

local function onStartRelease()
	start()
end

function scene:create(event)
	local sceneGroup = self.view

	local background = display.newImageRect(sceneGroup, "images/background.jpg", display.actualContentWidth, _H)
	background.x = _W * .5
	background.y = _H * .5

	--[[
	currentPage = display.newImage(pageGroup, images.intro[currentPageIndex])

	pageGroup.x = _W * .5
	pageGroup.y = _H * .465

	buttons.skip = widget.newButton({
		x = _W * .5,
		y = 0 + 5,
		defaultFile = "images/skip-button.png",
		onRelease = onSkipRelease
	})

	buttons.next = widget.newButton({
		x = _W - 5,
		y = 0,
		defaultFile = "images/arrow-right-small.png",
		onRelease = onNextRelease
	})

	buttons.next.anchorX = 1

	buttons.previous = widget.newButton({
		x = 0 + 5,
		y = 0,
		defaultFile = "images/arrow-left-small.png",
		onRelease = onPrevRelease
	})

	buttons.previous.anchorX = 0
	buttons.previous.isVisible = false

	buttons.start = widget.newButton({
		x = _W - 5,
		y = 0 + 5,
		defaultFile = "images/start-button.png",
		onRelease = onStartRelease
	})

	buttons.start.anchorX = 1
	buttons.start.isVisible = false

	text.page = display.newText({
		parent = topGroup,
		x = _W * .5,
		y = 0,
		text = currentPageIndex .. " / " .. #images.intro,
		font = native.systemFontBold,
		fontSize = 11,
		align = "center",
	})

	text.page:setFillColor(0, 0, 0)

	topGroup.y = _H * .0315
	bottomGroup.y = _H * .925

	bottomGroup:insert(buttons.skip)
	bottomGroup:insert(buttons.next)
	bottomGroup:insert(buttons.previous)
	bottomGroup:insert(buttons.start)

	sceneGroup:insert(background)
	sceneGroup:insert(pageGroup)
	sceneGroup:insert(topGroup)
	sceneGroup:insert(bottomGroup)
	]]
end

function scene:show(event)
	local phase = event.phase

	if phase == "will" then

	elseif phase == "did" then

	end
end

function scene:hide(event)
	local phase = event.phase

	if phase == "will" then

	elseif phase == "did" then

	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

return scene