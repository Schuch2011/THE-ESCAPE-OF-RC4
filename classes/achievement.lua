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
	achievement.x = _W * .5
	achievement.y = 0
	achievement.anchorY = 1
	achievement.anchorChildren = true

	local overlayBackground = display.newRoundedRect(achievement, 0, 0, _W * .55, _H * .15, 4)
	overlayBackground:setFillColor(0, 0, 0, .85)

	local title = display.newText({
		parent = achievement,
		x = - overlayBackground.width * .5 + 60,
		y = - overlayBackground.height * .5 + 10,
		text = "Achievement Unlocked ",
		font = "airstrikebold.ttf",
		fontSize = 15,
		align = "left"
	})
	title.anchorX = 0
	title.anchorY = 0

	local description = display.newText({
		parent = achievement,
		x = - overlayBackground.width * .5 + 60,
		y = 12,
		text = "",
		font = "airstrikebold.ttf",
		fontSize = 12,
		align = "left"
	})
	description.anchorX = 0

	local values = saveState.getValue( "achievements" )

	if values then
		for i = 1, #values do
			achievements = values
		end
	else
		saveState.save{ achievements = achievements }
	end

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

			description.text = achievements[index].description

			local image = display.newImage(achievement, "images/" .. achievements[index].image)
			image.xScale = .15
			image.yScale = .15

			image.x = - overlayBackground.width * .5 + 30

			transition.to(achievement, {y = achievement.height + 30, time = 250})

			timer.performWithDelay(3250, function()
				transition.to(achievement, {y = 0, time = 250, onComplete = function()
						description.text = ""
						display.remove(image)
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