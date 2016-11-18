local W= display.contentWidth
local H= display.contentHeight

local _M = {}

function _M.newBackground(stageID)
	if (stageID == 1) then

		local backgroundBottonColor = display.newRect(backgroundGroup,W/2,H/2, W*1.2,H*1.2)
	 	backgroundBottonColor:setFillColor(96/255, 146/255, 196/255)
		
	 	local backgroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 	backgroundUpperFill.anchorY = 1
		backgroundUpperFill:setFillColor(168/255, 222/255, 237/255)
	 	backgroundUpperFill.speed = {x = 0, y = 0.05}
	
	 	for i = 1, 5 do
			local background = display.newImage(backgroundGroup, "images/background/stage_1/background_"..math.random(3)..".png",0, 0)
			background.anchorX, background.anchorY = 0,0
			background.xScale, background.yScale = 0.5,0.5
			background.x = (i-1)*background.width*background.xScale-100-(i-2)*1
			background.speed = {x = 0.03, y=0.05}
		end
	
		local middleGroundUpperFill = display.newRect(backgroundGroup,W/2,-10, W*1.2,H*3)
	 	middleGroundUpperFill.anchorY = 1
		middleGroundUpperFill:setFillColor(97/255, 203/255, 232/255)
	 	middleGroundUpperFill.speed = {x = 0, y = 0.05}
	
		for i = 1, 5 do
			local middleGround = display.newImage(backgroundGroup, "images/background/stage_1/middleGround_"..math.random(5)..".png",0, -20)
			middleGround.anchorX, middleGround.anchorY = 0,0
			middleGround.xScale, middleGround.yScale = 0.5,0.5
			middleGround.x = (i-1)*middleGround.width*middleGround.xScale-100-(i-1)*2
			middleGround.speed = {x = 0.07, y=0.05}
		end
	
		local foreGroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 		foreGroundUpperFill.anchorY = 1
			foreGroundUpperFill:setFillColor(24/255, 127/255, 152/255)
	 		foreGroundUpperFill.speed = {x = 0, y = 0.1}
	
		for i = 1, 5 do
			local foreGround = display.newImage(backgroundGroup, "images/background/stage_1/foreGround_"..math.random(3)..".png",0, 0)
			foreGround.anchorX, foreGround.anchorY = 0,0
			foreGround.xScale, foreGround.yScale = 0.5,0.5
			foreGround.x = (i-1)*foreGround.width*foreGround.xScale-100-(i-1)*2
			foreGround.speed = {x = 0.15, y=0.1}
		end

	elseif(stageID == 2) then

		local backgroundBottonColor = display.newRect(backgroundGroup,W/2,H/2, W*1.2,H*1.2)
	 	backgroundBottonColor:setFillColor(62/255, 19/255, 18/255)
		
	 	local backgroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 	backgroundUpperFill.anchorY = 1
		backgroundUpperFill:setFillColor(63/255, 20/255, 19/255)
	 	backgroundUpperFill.speed = {x = 0, y = 0.05}
	
	 	for i = 1, 5 do
			local background = display.newImage(backgroundGroup, "images/background/stage_2/background_"..math.random(2)..".png",0, 0)
			background.anchorX, background.anchorY = 0,0
			background.xScale, background.yScale = 0.5,0.5
			background.x = (i-1)*background.width*background.xScale-100-(i-2)*1
			background.speed = {x = 0.03, y=0.05}
		end
	
		local middleGroundUpperFill = display.newRect(backgroundGroup,W/2,-10, W*1.2,H*3)
	 	middleGroundUpperFill.anchorY = 1
		middleGroundUpperFill:setFillColor(121/255, 23/255, 24/255)
	 	middleGroundUpperFill.speed = {x = 0, y = 0.05}
	
		for i = 1, 5 do
			local middleGround = display.newImage(backgroundGroup, "images/background/stage_2/middleGround_"..math.random(2)..".png",0, -20)
			middleGround.anchorX, middleGround.anchorY = 0,0
			middleGround.xScale, middleGround.yScale = 0.5,0.5
			middleGround.x = (i-1)*middleGround.width*middleGround.xScale-100-(i-1)*2
			middleGround.speed = {x = 0.07, y=0.05}
		end
	
		local foreGroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 		foreGroundUpperFill.anchorY = 1
			foreGroundUpperFill:setFillColor(62/255, 17/255, 16/255)
	 		foreGroundUpperFill.speed = {x = 0, y = 0.1}
	
		for i = 1, 5 do
			local foreGround = display.newImage(backgroundGroup, "images/background/stage_2/foreGround_"..math.random(3)..".png",0, 0)
			foreGround.anchorX, foreGround.anchorY = 0,0
			foreGround.xScale, foreGround.yScale = 0.5,0.5
			foreGround.x = (i-1)*foreGround.width*foreGround.xScale-100-(i-1)*2
			foreGround.speed = {x = 0.15, y=0.1}
		end	

	elseif(stageID == 3) then

		local backgroundBottonColor = display.newRect(backgroundGroup,W/2,H/2, W*1.2,H*1.2)
	 	backgroundBottonColor:setFillColor(62/255, 19/255, 18/255)
		
	 	local backgroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 	backgroundUpperFill.anchorY = 1
		backgroundUpperFill:setFillColor(63/255, 20/255, 19/255)
	 	backgroundUpperFill.speed = {x = 0, y = 0.05}
	
	 	for i = 1, 5 do
			local background = display.newImage(backgroundGroup, "images/background/stage_2/background_"..math.random(2)..".png",0, 0)
			background.anchorX, background.anchorY = 0,0
			background.xScale, background.yScale = 0.5,0.5
			background.x = (i-1)*background.width*background.xScale-100-(i-2)*1
			background.speed = {x = 0.03, y=0.05}
		end
	
		local middleGroundUpperFill = display.newRect(backgroundGroup,W/2,-10, W*1.2,H*3)
	 	middleGroundUpperFill.anchorY = 1
		middleGroundUpperFill:setFillColor(121/255, 23/255, 24/255)
	 	middleGroundUpperFill.speed = {x = 0, y = 0.05}
	
		for i = 1, 5 do
			local middleGround = display.newImage(backgroundGroup, "images/background/stage_2/middleGround_"..math.random(2)..".png",0, -20)
			middleGround.anchorX, middleGround.anchorY = 0,0
			middleGround.xScale, middleGround.yScale = 0.5,0.5
			middleGround.x = (i-1)*middleGround.width*middleGround.xScale-100-(i-1)*2
			middleGround.speed = {x = 0.07, y=0.05}
		end
	
		local foreGroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 		foreGroundUpperFill.anchorY = 1
			foreGroundUpperFill:setFillColor(62/255, 17/255, 16/255)
	 		foreGroundUpperFill.speed = {x = 0, y = 0.1}
	
		for i = 1, 5 do
			local foreGround = display.newImage(backgroundGroup, "images/background/stage_2/foreGround_"..math.random(3)..".png",0, 0)
			foreGround.anchorX, foreGround.anchorY = 0,0
			foreGround.xScale, foreGround.yScale = 0.5,0.5
			foreGround.x = (i-1)*foreGround.width*foreGround.xScale-100-(i-1)*2
			foreGround.speed = {x = 0.15, y=0.1}
		end	

	
	elseif(stageID == 4) then

		local backgroundBottonColor = display.newRect(backgroundGroup,W/2,H/2, W*1.2,H*1.2)
	 	backgroundBottonColor:setFillColor(62/255, 19/255, 18/255)
		
	 	local backgroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 	backgroundUpperFill.anchorY = 1
		backgroundUpperFill:setFillColor(63/255, 20/255, 19/255)
	 	backgroundUpperFill.speed = {x = 0, y = 0.05}
	
	 	for i = 1, 5 do
			local background = display.newImage(backgroundGroup, "images/background/stage_2/background_"..math.random(2)..".png",0, 0)
			background.anchorX, background.anchorY = 0,0
			background.xScale, background.yScale = 0.5,0.5
			background.x = (i-1)*background.width*background.xScale-100-(i-2)*1
			background.speed = {x = 0.03, y=0.05}
		end
	
		local middleGroundUpperFill = display.newRect(backgroundGroup,W/2,-10, W*1.2,H*3)
	 	middleGroundUpperFill.anchorY = 1
		middleGroundUpperFill:setFillColor(121/255, 23/255, 24/255)
	 	middleGroundUpperFill.speed = {x = 0, y = 0.05}
	
		for i = 1, 5 do
			local middleGround = display.newImage(backgroundGroup, "images/background/stage_2/middleGround_"..math.random(2)..".png",0, -20)
			middleGround.anchorX, middleGround.anchorY = 0,0
			middleGround.xScale, middleGround.yScale = 0.5,0.5
			middleGround.x = (i-1)*middleGround.width*middleGround.xScale-100-(i-1)*2
			middleGround.speed = {x = 0.07, y=0.05}
		end
	
		local foreGroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 		foreGroundUpperFill.anchorY = 1
			foreGroundUpperFill:setFillColor(62/255, 17/255, 16/255)
	 		foreGroundUpperFill.speed = {x = 0, y = 0.1}
	
		for i = 1, 5 do
			local foreGround = display.newImage(backgroundGroup, "images/background/stage_2/foreGround_"..math.random(3)..".png",0, 0)
			foreGround.anchorX, foreGround.anchorY = 0,0
			foreGround.xScale, foreGround.yScale = 0.5,0.5
			foreGround.x = (i-1)*foreGround.width*foreGround.xScale-100-(i-1)*2
			foreGround.speed = {x = 0.15, y=0.1}
		end	


	end
end

return _M



