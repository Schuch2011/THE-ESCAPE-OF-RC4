local _M = {}

local _W = display.contentWidth
local _H = display.contentHeight

function _M.newFpsCounter()
	local frames = 0
	local count = 0
	
	local options = {
		text = "",
		x = _W,
		y = _H,
		font = native.systemFont,
		fontSize = 12
	}
	
	local fpsCounter = display.newText(options)
	fpsCounter.anchorX, fpsCounter.anchorY = 1, 1
	fpsCounter:setFillColor(1, 1, 0)
	
	function fpsCounter:updateCounter(deltaTime)
		frames = frames + 1
		count = count + deltaTime
		
		if count >= 60 then
			fpsCounter.text = frames
			
			frames = 0
			count = count % 60
		end
	end
	
	return fpsCounter
end

return _M