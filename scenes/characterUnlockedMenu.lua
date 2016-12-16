local composer = require("composer")
local widget = require("widget")

local W = display.contentWidth
local H = display.contentHeight

local parCharImageSize = .8

local scene = composer.newScene()

local sfxButton

local characterThumbnail

local expandChar
local shrinkChar
local transitionTime = 750

function expandChar()
	transition.to(characterThumbnail, {time=transitionTime,
		--y = characterThumbnail.y -20,
		xScale=1, 
		yScale=1, 
		onComplete=shrinkChar})
end

function shrinkChar()
	transition.to(characterThumbnail, {time=transitionTime, 
		--y = characterThumbnail.y +20,
		xScale=.95, 
		yScale=.95, 
		onComplete=expandChar})
end


function scene:create(event)
	local sceneGroup = self.view

	local characterUnlocked = event.params

	sfxButton = audio.loadSound("audios/button.wav")
	
	local background = display.newRect(sceneGroup, W*.5, H*.5, display.actualContentWidth, display.actualContentHeight)
	background:setFillColor(0, 0, 0, .9)

	local titleText = display.newText(sceneGroup,"CHARACTER UNLOCKED! ", W*.5,H*.08, "airstrikebold.ttf", 32)
	
	local charName 
	local charDescription

	if characterUnlocked == 1 then
		charName = "RC4-101 "
		charDescription = "Nothing Special About "
	elseif characterUnlocked == 2 then
		charName = "RC4-CRV1 "
		charDescription = "Toxic Gas Resistance "
	elseif characterUnlocked == 3 then
		charName = "RC4-FR53 "
		charDescription = "Fire Resistance "
	elseif characterUnlocked == 4 then
		charName = "RC4-SPY14 "
		charDescription = "Laser Resistance "

		_achievement:unlockAndShow(2)
	end

	local charNameText = display.newText(sceneGroup, charName, W*.75, H*.35, "airstrikebold.ttf", 38)

	local charDescriptionTitleText = display.newText(sceneGroup, "SPECIAL ABILITY ", W*.75, H*.55, "airstrike.ttf", 21)
	local charDescriptionText = display.newText(sceneGroup, charDescription, W*.75, H*.65, "airstrike.ttf", 21)

	characterThumbnail = display.newImage(sceneGroup, "images/characterSelection/character_"..characterUnlocked.."_true.png",
	 W*.25, H*.475)
	characterThumbnail.width = characterThumbnail.width*parCharImageSize
	characterThumbnail.height = characterThumbnail.height*parCharImageSize 
	shrinkChar()

	local continueButton = widget.newButton({
		x = W * .5,
		y = H * .875,
		width = 225,
		height = 40,
		shape = "roundedRect",
		cornerRadius = 15,
		fillColor = {default = {.76, .34, .29}, over = {.76, .34, .29}},
		label = "CONTINUE ",
		labelColor = {default = {1, 1, 1}, over = {1, 1, 1}},
		font = "airstrike.ttf",
		fontSize = 25,
		onRelease = function()
			audio.play(sfxButton)
			composer.hideOverlay("fade", 200)
		end
	})
	sceneGroup:insert(continueButton)
end

scene:addEventListener("create", scene)

return scene