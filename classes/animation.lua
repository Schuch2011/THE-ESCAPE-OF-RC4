local _M = {}

function _M.newAnimation(imagePath, width, height, numFrames, sequences)
	local sheetOptions = {
		width = width,
		height = height,
		numFrames = numFrames
	}
	
	local sheet = graphics.newImageSheet(imagePath, sheetOptions)
	
	return display.newSprite(sheet, sequences)
end

return _M