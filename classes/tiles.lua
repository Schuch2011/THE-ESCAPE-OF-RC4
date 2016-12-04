local W= display.contentWidth
local H= display.contentHeight

local physics = require("physics")

local _M = {}

local toxicGasSequence = {
	{
		name = "default",
		start = 1,
		count = 24,
		time = 1000,
		loopCount = 0,
		loopDirection = "forward"
	}
}


local fireSequence = {
	{
		name = "default",
		start = 1,
		count = 21,
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	}
}


local laserSequence = {
	{
		name = "default",
		start = 1,
		count = 19,
		time = 1200,
		loopCount = 0,
		loopDirection = "forward"
	}
}

function _M.newTile(type,xPos,yPos,width,height, stageCoinsTable, coinID)
	local coinsTable = stageCoinsTable

	yPos = yPos - 300--420
	if (type == "C") then
		box = display.newImageRect(movableGroup, "images/coin.png", 25, 25)
		box.x = xPos+box.width/2
		box.y = yPos-box.width/2
		box.objType = "coin"
		physics.addBody(box,"static",{bounce=0, isSensor=true})
		box.ID = coinID
		if coinsTable[coinID] == true then
			box.collected = true
			box.alpha = .5
		else
			box.collected = false
		end
	elseif (type == "S") then
		box = display.newImageRect(movableGroup,"images/spike.png",35, 35)
		box.anchorX, box.anchorY = 0,1
		box.x, box.y = xPos, yPos
		physics.addBody(box,"static",{bounce=0,isSensor=true, 
			shape={-12,-12, 12,-12, 12,17, -12,17}})
		box.objType = "fatal"
	elseif (type == "PU1") then
		box = display.newImageRect(movableGroup, "images/powerUp1.png", 35, 35)
		box.x = xPos+12.5
		box.y = yPos-12.5
		box.objType = "powerUp1"
		physics.addBody(box,"static",{bounce=0, isSensor=true})
	elseif (type == "PU2") then
		box = display.newImageRect(movableGroup, "images/powerUp2.png", 35, 35)
		box.x = xPos+12.5
		box.y = yPos-12.5
		box.objType = "powerUp2"
		physics.addBody(box,"static",{bounce=0, isSensor=true})
	elseif (type == "PU3") then
		box = display.newImageRect(movableGroup, "images/powerUp3.png", 35, 35)
		box.x = xPos+12.5
		box.y = yPos-12.5
		box.objType = "powerUp3"
		physics.addBody(box,"static",{bounce=0, isSensor=true})
	elseif (type == "PU4") then
		box = display.newImageRect(movableGroup, "images/powerUp4.png", 35, 35)
		box.x = xPos+12.5
		box.y = yPos-12.5
		box.objType = "powerUp4"
		physics.addBody(box,"static",{bounce=0, isSensor=true})
	elseif (type == "P1") then
		local sheetOptions = {
			width = 104,
			height = 227,
			numFrames = 24
		}
		local sheet = graphics.newImageSheet("images/barriers/toxicGasBarrier.png", sheetOptions)
		box = display.newSprite(sheet, toxicGasSequence)
		box.anchorX, box.anchorY = 0,1
		box.x = xPos
		box.y = yPos
		box.isBarrier = true
		box.xScale = width/box.width; box.yScale = height/box.height	
		box.width = width; box.height = height
		movableGroup:insert(box)
		physics.addBody(box, "static", {bounce = 0, isSensor=true,
			chain={ box.width/-2,box.height*.5, box.width/2,box.height*.5, box.width/2,box.height*-.35, box.width/-2,box.height*-.35},
        	connectFirstAndLastChainVertex = true})
		box.objType = "portal1"
		box:play()
	elseif (type == "P2") then
		local sheetOptions = {
			width = 106.4,
			height = 253.55,
			numFrames = 29
		}
		local sheet = graphics.newImageSheet("images/barriers/fireBarrier.png", sheetOptions)
		box = display.newSprite(sheet, fireSequence)
		box.anchorX, box.anchorY = 0,1
		box.x = xPos
		box.y = yPos
		box.isBarrier = true
		box.xScale = width/box.width; box.yScale = height/box.height	
		box.width = width; box.height = height
		movableGroup:insert(box)
		physics.addBody(box, "static", {bounce = 0, isSensor=true,
			chain={ box.width/-2,box.height*.5, box.width/2,box.height*.5, box.width/2,box.height*-.35, box.width/-2,box.height*-.35},
        	connectFirstAndLastChainVertex = true})
		box.objType = "portal2"
		box:play()
	elseif (type == "P3") then
		local sheetOptions = {
			width = 94,
			height = 311,
			numFrames = 19
		}
		local sheet = graphics.newImageSheet("images/barriers/laserBarrier.png", sheetOptions)
		box = display.newSprite(sheet, laserSequence)
		box.anchorX, box.anchorY = 0,1
		box.x = xPos
		box.y = yPos+H*.014
		box.isBarrier = true
		box.xScale = width/box.width; box.yScale = height/box.height	
		box.width = width; box.height = height
		movableGroup:insert(box)
		physics.addBody(box, "static", {bounce = 0, isSensor=true,
			chain={ box.width/-2,box.height*.43, box.width/2,box.height*.43, box.width/2,box.height*-.42, box.width/-2,box.height*-.42},
        	connectFirstAndLastChainVertex = true})
		box.objType = "portal3"
		box:play()
	else
		box = display.newRect(0,0,width, height)
		box.anchorX, box.anchorY = 0,1
		box.x = xPos
		box.y = yPos		
		box:setFillColor(0)
		physics.addBody(box,"static",{bounce=0, friction=0})
		if (type == "G") then
			box.objType="ground"
			movableGroup:insert(box)
		elseif (type == "L") then
			box.objType="ground"
			box:setFillColor(106/255,47/255,238/255)
			lightGroup:insert(box)
		elseif (type == "D") then
			box.objType="ground"
			box:setFillColor(106/255,47/255,238/255)
			darkGroup:insert(box)
			box.isBodyActive = false
			box.alpha = 0.35 
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
		elseif (type == "SZG") then
			movableGroup:insert(box)
			box.isSensor=true
			box.alpha=0
			box.objType="startZeroGravity"
		elseif (type == "EZG") then
			movableGroup:insert(box)
			box.isSensor=true
			box.alpha=0
			box.objType="endZeroGravity"
		end
	end
	return box
end

return _M



