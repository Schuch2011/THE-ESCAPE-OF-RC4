local W= display.contentWidth
local H= display.contentHeight

local physics = require("physics")

local _M = {}

function _M.newSpike(xPos,yPos)
	spike = display.newImage(movableGroup,"images/spike.png",xPos,yPos)
	physics.addBody(
		spike,
		"static",
		{bounce=0, 
		isSensor=true, 
		shape={-25,-22, 25,-22, 25,32, -25,32}
		})
	spike.objType = "fatal"

	return spike
end

return _M



