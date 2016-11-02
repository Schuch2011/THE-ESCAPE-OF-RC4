local _M = {}

function _M.newAnimation(imageSheet, width, height, numFrames, sequences)
	local sheetOptions = {
		width = width,
		height = height,
		numFrames = numFrames
	}
	
	local sheet = graphics.newImageSheet("/images/" .. imageSheet, sheetOptions)
	
	return display.newSprite(sheet, sequences)
end

return _M