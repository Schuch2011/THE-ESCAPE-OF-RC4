local composer = require("composer")

local scene = composer.newScene()

function scene:show(event)
	if (event.phase == "will") then
		composer.removeScene("scenes.game")
	elseif (event.phase == "did") then
		composer.gotoScene("scenes.game")
	end
end

scene:addEventListener("show", scene)

return scene