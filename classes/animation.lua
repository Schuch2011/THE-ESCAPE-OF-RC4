local _M = {}

local defaultSequences = {
	{
		name = "running",
		start = 1,
		count = 21,
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "jumping",
		start = 22,
		count = 1,
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "falling",
		start = 23,
		count = 1,
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	}
}

function _M.newAnimation(imagePath, width, height, numFrames, sequences)
	local sheetOptions = {
		width = width,
		height = height,
		numFrames = numFrames
	}
	
	local sheet = graphics.newImageSheet(imagePath, sheetOptions)
	
	return display.newSprite(sheet, sequences or defaultSequences)
end

return _M