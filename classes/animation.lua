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
		frames = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36},
		time = 300,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "doubleJump",
		frames = {50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60},
		time = 500,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "zeroGravity",
		frames = {62},
		time = 250,
		loopCount = 1,
		loopDirection = "forward"
	}
	--[[
	{
		name = "falling",
		frames = {},
		loopCount = 1,
		loopDirection = "forward"
	}
	--]]
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