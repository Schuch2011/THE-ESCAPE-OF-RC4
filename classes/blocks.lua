local W= display.contentWidth
local H= display.contentHeight

local physics = require("physics")

local _M = {}

function _M.newBlock(type,xPos,yPos,width,height)
	box = display.newRect(xPos,yPos,width,height)
	box:setFillColor(0)
	physics.addBody(box,"static",{bounce=0})
	box.objType = "ground"

	if (type == "neutral") then
		movableGroup:insert(box)
	elseif (type == "light") then
		lightGroup:insert(box)
	elseif (type == "dark") then
		darkGroup:insert(box)
		box.isBodyActive = false
		box.alpha = 0.1 
	elseif (type == "endGame") then
		movableGroup:insert(box)
		box.isSensor=true
		box.alpha=0
		box.objType="endStage"
	elseif (type == "fatal") then
		box:setFillColor(1,0,0)
		box.alpha=0
		movableGroup:insert(box)
		box.isSensor=true
		box.objType = "fatal"
	end

	return box
end

return _M



