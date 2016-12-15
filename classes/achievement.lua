local saveState = require("classes.preference")

local _M = {}

local _W = display.contentWidth
local _H = display.contentHeight

local achievements = {
	{ description = "Finish the last stage", image = "trophy_1.png", isUnlocked = false },
	{ description = "Unlock every character", image = "trophy_2.png", isUnlocked = false },
	{ description = "Collect all coins", image = "trophy_3.png", isUnlocked = false }
}

function _M.new()

	local achievement = display.newGroup()
	local background = display.newRoundedRect(achievement, 0, 0, _W * .5, _H * .2, 4)

	local values = saveState.getValue( "achievements" )

	if values then
		for i = 1, #values do
			achievements = values
		end
	else
		saveState.save{ achievements = achievements }
	end

	background.anchorY = 0
	background:setFillColor(0, 0, 0, .5)

	achievement.anchorY = 0
	achievement.x = _W * .5
	achievement.y = _H

	function achievement:unlock(index)
		if not achievements[index].isUnlocked then
			achievements[index].isUnlocked = true
			saveState.save{ achievements = achievements}
		end
	end

	function achievement:unlockAndShow(index)
		if not achievements[index].isUnlocked then
			achievements[index].isUnlocked = true
			saveState.save{ achievements = achievements}

			local overlayGroup = display.newGroup()
			overlayGroup.x = _W * .5
			overlayGroup.y = 0
			overlayGroup.anchorY = 1
			overlayGroup.anchorChildren = true

			local overlayBackground = display.newRoundedRect(overlayGroup, 0, 0, _W * .55, _H * .15, 4)
			overlayBackground:setFillColor(0, 0, 0, .85)

			local overlayTitle = display.newText({
				parent = overlayGroup,
				x = - overlayBackground.width * .5 + 60,
				y = - overlayBackground.height * .5 + 10,
				text = "Achievement Unlocked ",
				font = "airstrikebold.ttf",
				fontSize = 15,
				align = "left"
			})
			overlayTitle.anchorX = 0
			overlayTitle.anchorY = 0

			local description = display.newText({
				parent = overlayGroup,
				x = - overlayBackground.width * .5 + 60,
				y = 12,
				text = achievements[index].description,
				font = "airstrikebold.ttf",
				fontSize = 12,
				align = "left"
			})
			description.anchorX = 0

			local image = display.newImage(overlayGroup, "images/" .. achievements[index].image)
			image.xScale = .15
			image.yScale = .15

			image.x = - overlayBackground.width * .5 + 30

			transition.to(overlayGroup, {y = overlayGroup.height + 30, time = 250})

			timer.performWithDelay(3250, function()
				transition.to(overlayGroup, {y = 0, time = 250, onComplete = function()
						display.remove(overlayGroup)
					end})
			end, 1)
		end
	end

	function achievement:getAchievements()
		return achievements
	end

	return achievement
end

return _M