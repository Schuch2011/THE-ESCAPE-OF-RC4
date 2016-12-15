local composer = require("composer")
local widget = require("widget")

local _W = display.contentWidth
local _H = display.contentHeight

local scene = composer.newScene()

local sfxButton

local achievementsGroup = display.newGroup()

local function createFrame(x, y, achievement)
	local contentGroup = display.newGroup()
	contentGroup.anchorChildren = true
	contentGroup.x = x
	contentGroup.y = y

	local frame = display.newRoundedRect(contentGroup, 0, 0, _W * .6, _H * .15, 4)
	local image = display.newImage(contentGroup, "images/" .. achievement.image)
	local text = display.newText({
		parent =  contentGroup,
		x = - frame.width * .5 + 60,
		y = 0,
		text = achievement.description,
		font = "airstrike.ttf",
		fontSize = 14,
		align = "left"
	})

	frame:setFillColor(0, 0, 0, .75)
	image.x = - frame.width * .5 + 35
	text.anchorX = 0

	image.xScale = .15
	image.yScale = .15

	contentGroup.alpha = achievement.isUnlocked and 1 or .35

	achievementsGroup:insert(contentGroup)
end

function scene:create(event)
	local sceneGroup = self.view

	sfxButton = audio.loadSound("audios/button.wav")
	
	local menuTitle = display.newText({
		x = _W * .52,
		y = _H * .185,
		align = "center",
		text = "ACHIEVEMENTS ",
		font = "airstrike.ttf",
		fontSize = 26,
	})
	menuTitle:setFillColor(.97, .95, 0)

	local background = display.newImageRect(sceneGroup, "images/background.jpg", display.actualContentWidth, _H)
	background.x = _W * .5
	background.y = _H * .5

	createFrame(_W * .5, _H * .36, _achievement.getAchievements()[1])
	createFrame(_W * .5, _H * .56, _achievement.getAchievements()[2])
	createFrame(_W * .5, _H * .76, _achievement.getAchievements()[3])

	local backButton = widget.newButton({
		defaultFile = "images/arrow-right.png",
		x = _W * 0.9,
		y = _H * 0.85,
		onRelease = function()
			audio.play(sfxButton)
			composer.gotoScene("scenes.menu", {time = 500, effect = "slideLeft"})
		end
	})

	sceneGroup:insert(achievementsGroup)
	sceneGroup:insert(backButton)
	sceneGroup:insert(menuTitle)
end

function scene:show(event)
	if event.phase == "did" then
		local previous = composer.getSceneName("previous")

		if previous ~= nil then
			composer.removeScene(composer.getSceneName("previous"))
		end
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)

return scene