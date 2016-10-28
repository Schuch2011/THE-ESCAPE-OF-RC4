local W= display.contentWidth
local H= display.contentHeight

local physics = require("physics")

local _M = {}

function _M.newCoin(xPos,yPos)
	coin = display.newImageRect(movableGroup, "images/coin.png", 32, 32)
	coin.x = xPos
	coin.y = yPos
	coin.objType = "coin"
	physics.addBody(coin,"static",{bounce=0, isSensor=true})
	totalCoins = totalCoins + 1
	return coin
end

return _M


