local W= display.contentWidth
local H= display.contentHeight

local _M = {}

function _M.newBackground(stageID)
	if (stageID == 0) then
		local background = display.newRect(backgroundGroup,W/2,H/2, W*1.2,H*1.2)
		background:setFillColor(0.6)
	elseif (stageID == 1) then

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
			background.speed = {x = 0.045, y=0.05}
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
	 	backgroundBottonColor:setFillColor(96/255, 93/255, 39/255)
		
	 	local backgroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 	backgroundUpperFill.anchorY = 1
		backgroundUpperFill:setFillColor(38/255, 37/255, 22/255)
	 	backgroundUpperFill.speed = {x = 0, y = 0.05}
	
	 	for i = 1, 5 do
	 		local temp = i - math.floor(i/2)*2 + 1
			local background = display.newImage(backgroundGroup, "images/background/stage_3/background_"..temp..".png",0, 0)
			background.anchorX, background.anchorY = 0,0
			background.xScale, background.yScale = 0.5,0.5
			background.x = (i-1)*background.width*background.xScale-100-(i-2)*1
			background.speed = {x = 0.03, y=0.05}
		end
	
		-- local middleGroundUpperFill = display.newRect(backgroundGroup,W/2,-10, W*1.2,H*3)
	 -- 	middleGroundUpperFill.anchorY = 1
		-- middleGroundUpperFill:setFillColor(121/255, 23/255, 24/255)
	 -- 	middleGroundUpperFill.speed = {x = 0, y = 0.05}
	
		for i = 1, 5 do
			local temp = i - math.floor(i/2)*2 + 1
			local middleGround = display.newImage(backgroundGroup, "images/background/stage_3/middleGround_"..temp..".png",0, -20)
			middleGround.anchorX, middleGround.anchorY = 0,0
			middleGround.xScale, middleGround.yScale = 0.5,0.5
			middleGround.x = (i-1)*middleGround.width*middleGround.xScale-100-(i-1)*2
			middleGround.speed = {x = 0.07, y=0.05}
		end
	
		local foreGroundUpperFill = display.newRect(backgroundGroup,W/2,0, W*1.2,H*3)
	 		foreGroundUpperFill.anchorY = 1
			foreGroundUpperFill:setFillColor(172/255, 173/255, 133/255)
	 		foreGroundUpperFill.speed = {x = 0, y = 0.1}
	
		for i = 1, 4 do
			local temp = i - math.floor(i/2)*2 + 1
			local foreGround = display.newImage(backgroundGroup, "images/background/stage_3/foreGround_"..temp..".png",0, 0)
			foreGround.anchorX, foreGround.anchorY = 0,0
			foreGround.xScale, foreGround.yScale = 0.5,0.5
			foreGround.x = (i-1)*foreGround.width*foreGround.xScale-100-(i-1)*2
			foreGround.speed = {x = 0.15, y=0.1}
		end	

	
	elseif(stageID == 4) then

		-- local backgroundBottonColor = display.newRect(backgroundGroup,W/2,H/2, W*1.2,H*1.2)
	 -- 	backgroundBottonColor:setFillColor(62/255, 19/255, 18/255)
		
	 -- 	local backgroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 -- 	backgroundUpperFill.anchorY = 1
		-- backgroundUpperFill:setFillColor(63/255, 20/255, 19/255)
	 -- 	backgroundUpperFill.speed = {x = 0, y = 0.05}
	
	 	for i = 1, 5 do
			local background = display.newImage(backgroundGroup, "images/background/stage_4/background_"..math.random(3)..".png",0, 0)
			background.anchorX, background.anchorY = 0,0
			background.xScale, background.yScale = 0.5,0.5
			background.x = (i-1)*background.width*background.xScale-100-(i-2)*1
			background.speed = {x = 0.03, y=0.05}
		end
	
		local middleGroundBottonFill = display.newRect(backgroundGroup,W/2,H+10, W*1.2,H*.455)
	 	middleGroundBottonFill.anchorY = 1
		middleGroundBottonFill:setFillColor(49/255, 96/255, 49/255)
	 	middleGroundBottonFill.speed = {x = 0, y = 0.05}
	
		for i = 1, 10 do
			local tempI
			if i <= 5 then
				tempI = i
			else 
				tempI = i-5
			end 
			local middleGround = display.newImage(backgroundGroup, "images/background/stage_4/middleGround_"..tempI..".png",0, 25)
			middleGround.anchorX, middleGround.anchorY = 0,0
			middleGround.xScale, middleGround.yScale = 0.5,0.5
			middleGround.x = (i-1)*middleGround.width/2*middleGround.xScale-100-(i-1)*2
			middleGround.speed = {x = 0.07, y=0.05}
		end
	
		local foreGroundUpperFill = display.newRect(backgroundGroup,W/2,10, W*1.2,H*3)
	 		foreGroundUpperFill.anchorY = 1
			foreGroundUpperFill:setFillColor(89/255, 167/255, 92/255)
	 		foreGroundUpperFill.speed = {x = 0, y = 0.1}

	    local foreGroundBottonFill = display.newRect(backgroundGroup,W/2,H*.75, W*1.2,H*3)
	 	foreGroundBottonFill.anchorY = -1
		foreGroundBottonFill:setFillColor(3/255, 100/255, 1/255)
	 	foreGroundBottonFill.speed = {x = 0, y = 0.1}
	
		for i = 1, 5 do
			local foreGround = display.newImage(backgroundGroup, "images/background/stage_4/foreGround_".."1"..".png",0, 0)
			foreGround.anchorX, foreGround.anchorY = 0,0
			foreGround.xScale, foreGround.yScale = 0.5,0.5
			foreGround.x = (i-1)*foreGround.width*foreGround.xScale-100-(i-1)*2
			foreGround.speed = {x = 0.15, y=0.1}
		end	


	end
end

return _M



