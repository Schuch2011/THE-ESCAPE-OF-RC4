local composer = require("composer")
local widget = require("widget")

local _W = display.contentWidth
local _H = display.contentHeight

local scene = composer.newScene()

function scene:create()
	local sceneGroup = self.view
	
	local background = display.newRect(_W * .5, _H * .5, display.actualContentWidth, display.actualContentHeight)
	background:setFillColor(0, 0, 0, .8)
	
	local resumeButton = widget.newButton({
		x = _W * .5,
		y = _H * .5,
		width = _W * .35,
		height = _H * .2,
		shape = "roundedRect",
		fillColor = {default = {0, 1, 0}, over = {0, 1, 0}},
		cornerRadius = 10,
		label = "RESUME",
		labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
		fontSize = 25,
		onRelease = function()
			composer.hideOverlay("fade", 200)
		end
	})
	
	sceneGroup:insert(background)
	sceneGroup:insert(resumeButton)
end

function scene:show()
end

function scene:hide(event)
	local phase = event.phase
	local parent = event.parent

	if phase == "did" then
		parent:resumeGame()
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene