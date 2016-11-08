local W= display.contentWidth
local H= display.contentHeight

local physics = require("physics")

local _M = {}

function _M.newTile(type,xPos,yPos)
	yPos = yPos - 16
	if (type ~= "Z") then
		if (type == "C") then
			box = display.newImageRect(movableGroup, "images/coin.png", 32, 32)
			box.x = 25*xPos
			box.y = 25*yPos
			box.objType = "coin"
			physics.addBody(box,"static",{bounce=0, isSensor=true})
		elseif (type == "S") then
			box = display.newImageRect(movableGroup,"images/spike.png",25,25)
			box.anchorX, box.anchorY = 0,0
			box.x, box.y = box.width*xPos, box.height*yPos
			physics.addBody(box,"static",{bounce=0,isSensor=true, 
				shape={-12,-12, 12,-12, 12,17, -12,17}})
			box.objType = "fatal"
		elseif (type == "PU1") then
			box = display.newImageRect(movableGroup, "images/powerUp1.png", 32, 32)
			box.x = xPos*25
			box.y = yPos*25
			box.objType = "powerUp1"
			physics.addBody(box,"static",{bounce=0, isSensor=true})
		elseif (type == "PU2") then
			box = display.newImageRect(movableGroup, "images/powerUp2.png", 32, 32)
			box.x = xPos*25
			box.y = yPos*25
			box.objType = "powerUp2"
			physics.addBody(box,"static",{bounce=0, isSensor=true})
		elseif (type == "PU3") then
			box = display.newImageRect(movableGroup, "images/powerUp3.png", 32, 32)
			box.x = xPos*25
			box.y = yPos*25
			box.objType = "powerUp3"
			physics.addBody(box,"static",{bounce=0, isSensor=true})
		elseif (type == "PU4") then
			box = display.newImageRect(movableGroup, "images/powerUp4.png", 32, 32)
			box.x = xPos*25
			box.y = yPos*25
			box.objType = "powerUp4"
			physics.addBody(box,"static",{bounce=0, isSensor=true})
		else
			box = display.newRect(0,0,25,25)
			box.anchorX, box.anchorY = 0,0
			box.x = box.width*xPos
			box.y = box.width*yPos		
			box:setFillColor(0)
			physics.addBody(box,"static",{bounce=0})
			if (type == "G") then
				box.objType="ground"
				movableGroup:insert(box)
			elseif (type == "L") then
				lightGroup:insert(box)
			elseif (type == "D") then
				darkGroup:insert(box)
				box.isBodyActive = false
				box.alpha = 0.1 
			elseif (type == "EG") then
				movableGroup:insert(box)
				box.isSensor=true
				box.alpha=0
				box.objType="endStage"
			elseif (type == "F") then
				box:setFillColor(1,0,0)
				box.alpha=0
				movableGroup:insert(box)
				box.isSensor=true
				box.objType = "fatal"
			elseif (type == "P1") then
				box:setFillColor(1,0.5,0)
				box.alpha=0.5
				movableGroup:insert(box)
				box.isSensor=true
				box.objType = "portal1"
			elseif (type == "P2") then
				box:setFillColor(0,1,0)
				box.alpha=0.5
				movableGroup:insert(box)
				box.isSensor=true
				box.objType = "portal2"
			elseif (type == "P3") then
				box:setFillColor(1,0,0)
				box.alpha=0.5
				movableGroup:insert(box)
				box.isSensor=true
				box.objType = "portal3"
			elseif (type == "P4") then
				box:setFillColor(1,1,0)
				box.alpha=0.5
				movableGroup:insert(box)
				box.isSensor=true
				box.objType = "portal4"
			elseif (type == "SZG") then
				movableGroup:insert(box)
				box.isSensor=true
				box.alpha=0
				box.objType="startZeroGravity"
			end
		end
		return box
	end
end

return _M


