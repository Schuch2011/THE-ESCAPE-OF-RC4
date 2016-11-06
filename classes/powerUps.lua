local W= display.contentWidth
local H= display.contentHeight

local physics = require("physics")

local _M = {}

function _M.newPowerUp(type,xPos,yPos)
	powerUp = display.newImageRect(movableGroup, "images/powerUp"..type..".png", 32, 32)
	powerUp.x = xPos
	powerUp.y = yPos
	powerUp.objType = "powerUp"..type
	physics.addBody(powerUp,"static",{bounce=0, isSensor=true})
	return powerUp
end

return _M


