display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local physics = require("physics")
local widget = require( "widget" )
local tiles = require("classes.tiles")
local background = require("classes.background")
local saveState = require("classes.preference")
local loadsave = require("classes.loadsave")
local animation = require("classes.animation")
--local fpsCounter = require("classes.fpsCounter").newFpsCounter()

local scene = composer.newScene()
local runtime = 0
local currentLevel
local charID

local isPaused = true
local isGameFinished = false
local isFinishing
local isInTutorial = 0
local switchTime=false
local coins = 0
local totalCoins
local stageCoinsTable = {}
local score = 0

-- VARIÁVEIS DE SOM

local sfxCoin
local sfxJump1
local sfxJump2
local sfxJumpLanding
local sfxSwitch
local sfxPowerUp
local sfxGameOver
local sfxGameWin
local sfxButton
local sfxBGMusic

local bgMusic

-- PARÂMETROS DE JOGABILIDADE

local parPowerUp1Duration = 2000
local parPowerUp2Duration = 2000
local parPowerUp3Duration = 4000
local parPowerUp4Duration = 4000


local parDefaultSpeed = 3--10
local parPowerUpSpeed = 6
local parZeroChamberSpeed = 2
local parSpeed = parDefaultSpeed

local parDefaultJumpForce = -15---20
local parPowerUpJumpForce = -22---26
local parJumpForce = parDefaultJumpForce

local parDefaultScoreMultiplier = 1
local parPowerUpScoreMultiplier = 2
local parScoreMultiplier = 1

local player
local playerLocalX
local playerLocalY
local parPlayerYPosition = 0.55*H
local parPlayerXPosition = 0.25*W
local parVerticalFollowRate = 5  -- Frames necessários para a câmera alcançar a posição vertical padrão do personagem
local parHorizontalFollowRate = 15  -- Frames necessários para a câmera alcançar a posição horizontal padrão do personagem
local tempPosition
local xCompensation = W*0.4

local parGravity = 60
local parAccelerometerSensitivity = 30
local parIsZeroGravity=false

local playerProgression = {}
local levelEndPosition

local activePowerUpOverlay = {}
local activePowerUpTimer = 0
local activePowerUpTime

local canDie = true

local jumpButtonArea
local switchButtonArea
local leftButton
local rightButton
local pauseButton

local message1
local message2
local message3
local message4
local message5
local message6
local message7
local message8
local message9
local message10

local iconPU1
local iconPU2
local iconPU3
local iconPU4

local accelerometerInstruction

local function setPhysics() -- INICIAR E CONFIGURAR A SIMULAÇÃO DE FÍSICA
	physics.start(true)
	physics.setGravity(0,parGravity)
	--physics.setDrawMode("hybrid")
end

local function jump() -- AÇÃO DE PULO
	player:applyForce(0,parJumpForce,player.x,player.y)
	player:setLinearVelocity( 0,0 )
	player.canJump = player.canJump - 1
	
	if player.canJump == 0 then
		player:setSequence("doubleJump")
		player:play()
		audio.play(sfxJump2) 
	elseif player.canJump == 1 then
		audio.play(sfxJump1) 
		player:setSequence("jumping")
		player:play()
	end
end

local function switch() -- MECÂNICA DE INVERSÃO DOS ELEMENTOS DO CENÁRIO
	audio.play(sfxSwitch)
	if(switchTime == false) then
		for i=1, lightGroup.numChildren do
			lightGroup[i].alpha = 0.15
			lightGroup[i].isBodyActive = false
		end
		for i=1, darkGroup.numChildren do
			darkGroup[i].alpha = 1
			darkGroup[i].isBodyActive = true			
		end
		switchTime = true
	elseif (switchTime == true) then
		for i=1, lightGroup.numChildren do
			lightGroup[i].alpha = 1
			lightGroup[i].isBodyActive = true
		end
		for i=1, darkGroup.numChildren do
			darkGroup[i].alpha = 0.15
			darkGroup[i].isBodyActive = false			
		end
		switchTime = false
	end
end

local function stopGame()
	isPaused = true
	audio.stop(1)
    parIsZeroGravity = false
end

local function gameOver()
	stopGame()
	isPaused = true
	if not audio.isChannelActive(3) then
    	audio.play(sfxGameOver, {channel = 3})
    end
	composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
end

local function onJumpButtonTouch( event )
	if isInTutorial ~= 0 then
    	isPaused = false
		player:play()
		physics.start(true)
		parSpeed = parDefaultSpeed
		player.timeScale=1
		for i=1, movableGroup.numChildren do
				if movableGroup[i].isBarrier==true then			
				movableGroup[i]:play()
			end
		end
		message1.alpha=0
		message2.alpha=0
		transition.cancel("button")
		rightButton.alpha=.12
		
	end
	if not isPaused then
		if ( event.phase == "began" and player.canJump > 0) then
			jump()
		elseif ( event.phase == "ended") then
			return true
		end
	end
	if isInTutorial ~= 0 then
		if isInTutorial == 3 then
			jumpButtonArea.isHitTestable=false
			rightButton.alpha = 0
			timer.performWithDelay(150, function()
				isPaused = true
				physics.pause()
				player:pause()
				message2.alpha = 1
				for i=1, movableGroup.numChildren do
					if movableGroup[i].isBarrier==true then			
						movableGroup[i]:pause()
					end
				end
				timer.performWithDelay(500, function()
					jumpButtonArea.isHitTestable=true
					rightButton.alpha= .12
					glow(rightButton)
				end)				
			end)
			isInTutorial = 1
		else
			isInTutorial = 0
		end
	end
end

function fade(object)
	local object = object
	transition.to(object, {time=600, tag="button", alpha=.2, onComplete= function()
		glow(object)
	end})
end
function glow(object)
	local object = object
	transition.to(object, {time=600, tag="button",alpha=.45, onComplete=function()
		fade(object)
	end})
end


local function onSwitchButtonTouch( event )
	if isInTutorial == 4 or isInTutorial == 5 then
		isPaused = false
		player:play()
		physics.start(true)
		parSpeed = parDefaultSpeed
		player.timeScale=1
		for i=1, movableGroup.numChildren do
			if movableGroup[i].isBarrier==true then			
				movableGroup[i]:play()
			end
		end
		message3.alpha=0
		transition.cancel("button")
		leftButton.alpha=.12
	end
    if (not isPaused and event.phase == "began") then
    	switch()
    	if isInTutorial == 4 then
    		switchButtonArea.isHitTestable = false    
    		leftButton.alpha=0		
    	elseif isInTutorial == 5 then
			isInTutorial = 0
			jumpButtonArea.isHitTestable=true
			rightButton.alpha=.12
    	end
    elseif ( event.phase == "ended") then
    	return true
	end
end

local function onAccelerate( event )
	if (parIsZeroGravity==true) then
    	physics.setGravity(0,event.yInstant*-1*parAccelerometerSensitivity)
    	parSpeed = parZeroChamberSpeed
	end
end
 
local function getDeltaTime() -- CALCULAR O TEMPO DESDE O ÚLTIMO FRAME GERADO
    local temp = system.getTimer()
    local dt = (temp-runtime) / (1000/60)
    runtime = temp
    return dt
end

local function loadPowerUpOverlayImage(group, type)
	local powerUp = display.newImage(group, "images/powerUp" .. type .. ".png")
	powerUp.xScale = .3
	powerUp.yScale = .3
	powerUp.x = - activePowerUpOverlay.background.width * .5 - 20
	powerUp.isVisible = false
end

local function activatePowerUp(type)
	activePowerUpOverlayGroup.isVisible = true
	
	for i = 1, activePowerUpOverlay.images.numChildren do
		activePowerUpOverlay.images[i].isVisible = false
	end
	
	activePowerUpOverlay.images[type].isVisible = true
	
	activePowerUpOverlay.timerBar.width = activePowerUpOverlay.timerBar.totalWidth
	
	if (type == 1) then
		parSpeed = parPowerUpSpeed
		player.timeScale = 1.5
		activePowerUpTime = parPowerUp1Duration
		activePowerUpTimer = parPowerUp1Duration
		timer.performWithDelay(parPowerUp1Duration,
			function()
				parSpeed = parDefaultSpeed
				player.timeScale = 1
				activePowerUpOverlayGroup.isVisible = false
			end)
	end
	if (type == 2) then
		parJumpForce = parPowerUpJumpForce
		activePowerUpTime = parPowerUp2Duration
		activePowerUpTimer = parPowerUp2Duration
		timer.performWithDelay(parPowerUp2Duration,
			function()
				parJumpForce = parDefaultJumpForce
				activePowerUpOverlayGroup.isVisible = false
			end)
	end
	if (type == 3) then
		parScoreMultiplier = parPowerUpScoreMultiplier
		activePowerUpTime = parPowerUp3Duration
		activePowerUpTimer = parPowerUp3Duration
		timer.performWithDelay(parPowerUp3Duration,
			function()
				parScoreMultiplier = parDefaultScoreMultiplier
				activePowerUpOverlayGroup.isVisible = false
			end)
	end
	if (type == 4) then
		canDie = false
		activePowerUpTime = parPowerUp4Duration
		activePowerUpTimer = parPowerUp4Duration
		timer.performWithDelay(parPowerUp4Duration,
			function()
				canDie = true
				activePowerUpOverlayGroup.isVisible = false
			end)
	end

	return powerUp
end

local function onPaused()
	audio.pause(1)
	audio.play(sfxButton)

	isPaused = true
	
	physics.pause()

	for i=1, movableGroup.numChildren do
		if movableGroup[i].isBarrier==true then			
			movableGroup[i]:pause()
		end
	end
	
	jumpButtonArea.isHitTestable = false
	switchButtonArea.isHitTestable = false
	pauseButton.isVisible = false
	
	player:pause()
	accelerometerInstruction:pause()
	
	composer.showOverlay("scenes.pause", {effect = "fade", time = 200, isModal = true})
end

function scene:finishGame()
	isGameFinished = true
end

function scene:resumeGame()
	isPaused = false
	
	physics.start(true)
	
	jumpButtonArea.isHitTestable = true
	switchButtonArea.isHitTestable = true
	pauseButton.isVisible = true

	for i=1, movableGroup.numChildren do
		if movableGroup[i].isBarrier==true then			
			movableGroup[i]:play()
		end
	end
	
	player:play()
	accelerometerInstruction:play()
end

local function playerCollider( self,event ) 
    if (event.phase == "began") then
		-- RECOMEÇA A CONTAGEM DE PULOS QUANDO O PERSONAGEM ESTÁ COM OS PÉS NO CHÃO		
    	if ( event.selfElement == 2 and event.other.objType == "ground") then
        	audio.play(sfxJumpLanding, {channel = 2})
        	self.canJump = 2
    	end
    	-- DETECTA SE O PERSONAGEM ALCANÇA O FIM DA FASE

    	if ( event.selfElement == 1 and event.other.objType == "tutorial") then
    		if event.other.tutorialStep~=2 and event.other.tutorialStep~=0 then
    			isPaused = true
				player:pause()
				physics.pause()
				for i=1, movableGroup.numChildren do
					if movableGroup[i].isBarrier==true then			
						movableGroup[i]:pause()
					end
				end
			end
			if (event.other.tutorialStep==0) then
				parSpeed = parDefaultSpeed*.75
				player.timeScale=.75
			end
    		if (event.other.tutorialStep==1) then
    			message1.alpha=1
    			isInTutorial = 1
    			timer.performWithDelay(500, function()
					jumpButtonArea.isHitTestable = true
    				rightButton.alpha = 0.12
    				glow(rightButton)
    			end)
    		end
    		if (event.other.tutorialStep==2) then
    			jumpButtonArea.isHitTestable = true
    			rightButton.alpha = 0
    		end
    		if (event.other.tutorialStep==3) then
    			isInTutorial = 3
    			message1.alpha=1
    			timer.performWithDelay(500, function()
    				jumpButtonArea.isHitTestable = true
    				rightButton.alpha = 0.12
    				glow(rightButton)
    			end)    			
    		end
    		if (event.other.tutorialStep==4 or event.other.tutorialStep==5) then
    			isInTutorial = event.other.tutorialStep
    			switchButtonArea.isHitTestable = true
    			leftButton.alpha = 0.12
    			jumpButtonArea.isHitTestable = false
    			rightButton.alpha= 0
    			glow(leftButton)
    			message3.alpha=1
    		end
    		if (event.other.tutorialStep==6) then
    			switchButtonArea.isHitTestable = false
    			leftButton.alpha = 0
    			jumpButtonArea.isHitTestable = false
    			rightButton.alpha = 0

    			transition.to(message4, {time=100, alpha = 1, onComplete= function()
    				timer.performWithDelay(5000, function()
    					message4.alpha=0
    					message5.alpha=1
    					iconPU1.alpha=1
    					timer.performWithDelay(5000, function()
    						message5.alpha=0
    						message6.alpha=1
    						iconPU1.alpha=0
    						iconPU2.alpha=1
    					    timer.performWithDelay(5000, function()
    							message6.alpha=0
    							message7.alpha=1
    							iconPU2.alpha=0
    							iconPU3.alpha=1
    							timer.performWithDelay(5000, function()
    								message7.alpha=0
    								message8.alpha=1
    								iconPU3.alpha=0
    								iconPU4.alpha=1
    								timer.performWithDelay(5000, function()
    									message8.alpha=0
    									iconPU4.alpha=0
    									switchButtonArea.isHitTestable = true
    									leftButton.alpha = .12
    									jumpButtonArea.isHitTestable = true
    									rightButton.alpha = .12
    									isPaused = false
										player:play()
										physics.start(true)
										for i=1, movableGroup.numChildren do
												if movableGroup[i].isBarrier==true then			
												movableGroup[i]:play()
											end
										end							
    								end)
    							end)
    						end)
    					end)
    				end)
    			end})
    		end

    		if (event.other.tutorialStep==7) then
    			switchButtonArea.isHitTestable = false
    			leftButton.alpha = 0
    			jumpButtonArea.isHitTestable = false
    			rightButton.alpha = 0
    			message9.alpha=1
    			timer.performWithDelay(5000, function()    				
    				switchButtonArea.isHitTestable = true
    				leftButton.alpha = 0.12
    				jumpButtonArea.isHitTestable = true
    				rightButton.alpha = 0.12
    				message9.alpha=0
    				isPaused = false
					player:play()
					physics.start(true)
					for i=1, movableGroup.numChildren do
						if movableGroup[i].isBarrier==true then			
							movableGroup[i]:play()
						end
					end	
    			end)
    		end

    		if (event.other.tutorialStep==8) then
    			switchButtonArea.isHitTestable = false
    			leftButton.alpha = 0
    			jumpButtonArea.isHitTestable = false
    			rightButton.alpha = 0
    			message10.alpha=1
    			accelerometerInstruction.alpha=1
				accelerometerInstruction:play()
    			timer.performWithDelay(5000, function()    				
    				switchButtonArea.isHitTestable = true
    				leftButton.alpha = 0.12
    				jumpButtonArea.isHitTestable = true
    				rightButton.alpha = 0.12
    				message10.alpha=0
    				isPaused = false
					player:play()
					physics.start(true)
					for i=1, movableGroup.numChildren do
						if movableGroup[i].isBarrier==true then			
							movableGroup[i]:play()
						end
					end	
    			end)
    		end


    	end

		if ( event.selfElement == 1 and event.other.objType == "endStage") then
			
			isFinishing = true
			timer.performWithDelay(2500, function()
				print("oi")
				stopGame()
				audio.play(sfxGameWin)
				local tempScore = saveState.getValue("stage"..currentLevel.."Score") or 0
				score = (math.floor(score/10))*10

				if (score>tempScore) then
					saveState.save{["stage"..currentLevel.."Score"]=score}
				end

				saveState.save{["stage"..currentLevel.."Coins"]=coins}					

				loadsave.saveTable(stageCoinsTable, "stage"..currentLevel.."Coins.json")

				if currentLevel == 4 then
					composer.gotoScene("scenes.cutscene", {effect="slideLeft",time = 500, params = {coins = coins, cutsceneType = "final"}})
				else
					composer.gotoScene("scenes.gameVictory",{params=coins, effect="slideLeft",time = 500})
				end
			end)
    	end
    	    -- DETECTA A COLISÃO DO PERSONAGEM COM AS MOEDAS
    	if ( event.selfElement == 1 and event.other.objType == "coin") then
			local temp = event.other
			display.remove(temp)
			if event.other.collected == false then
				audio.play(sfxCoin, {channel=4})	
				stageCoinsTable[event.other.ID]=true
				coins = coins +1
				score = score + 250
				loadsave.saveTable(stageCoinsTable, "stage"..currentLevel.."Coins.json")
				if coinsCounter then coinsCounter.text = coins.." / "..totalCoins .. " " end				
			end
					
      	end
      	    -- COLISÃO COM BLOCOS FATAIS
		if ( event.selfElement == 1 and event.other.objType == "fatal" and canDie==true) then
			gameOver()
    	end

    		-- PORTAIS ESPECIAIS
    	if ( event.selfElement == 1 and event.other.objType == "portal1" and charId~=2) then
			gameOver()
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal2" and charId~=3) then
			gameOver()
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal3" and charId~=4) then
    		gameOver()
    	end

    	    -- COLISÃO COM POWERUP 1 -- AUMENTO TEMPORÁRIO NA VELOCIDADE DO JOGADOR
		if ( event.selfElement == 1 and event.other.objType == "powerUp1" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(1)
			audio.play(sfxPowerUp)
    	end
    	    -- COLISÃO COM POWERUP 2 -- AUMENTO TEMPORÁRIO DA ALTURA DO PULO
		if ( event.selfElement == 1 and event.other.objType == "powerUp2" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(2)
			audio.play(sfxPowerUp)
    	end
    	    -- COLISÃO COM POWERUP 3 -- AUMENTO NA TAXA DE SCORE GANHOS
		if ( event.selfElement == 1 and event.other.objType == "powerUp3" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(3)
			audio.play(sfxPowerUp)
    	end
    	    -- COLISÃO COM POWERUP 4 -- INVENCIBILIDADE A OBSTÁCULOS NORMAIS
		if ( event.selfElement == 1 and event.other.objType == "powerUp4" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(4)
			audio.play(sfxPowerUp)
    	end  
    	if ( event.selfElement == 1 and event.other.objType == "startZeroGravity" ) then
        	parIsZeroGravity=true
        	physics.setGravity(0,0)
        	jumpButtonArea.isHitTestable=false
			player:setSequence("zeroGravity")
			player:play()
			accelerometerInstruction.alpha=1
			accelerometerInstruction:play()
			rightButton.alpha = 0
    	end  
    	if ( event.selfElement == 1 and event.other.objType == "endZeroGravity" ) then
    		parSpeed = parDefaultSpeed
        	parIsZeroGravity=false
        	physics.setGravity(0,parGravity)
        	jumpButtonArea.isHitTestable=true
			player:setSequence("running")
			player:play()
			accelerometerInstruction.alpha=0
			accelerometerInstruction:pause()
			rightButton.alpha = 0.12
    	end  
    end
end

function scene:create(event)
	sceneGroup = self.view
	currentLevel = composer.getVariable("selectedStage")
	self.levelId = currentLevel
	self.level = require("levels." .. currentLevel)

	-- CARREGAR SONS

	audio.reserveChannels(4)

	sfxCoin = audio.loadSound("audios/coin.wav")
	sfxJump1 = audio.loadSound("audios/jump1.wav")
	sfxJump2 = audio.loadSound("audios/jump2.wav")
	sfxJumpLanding = audio.loadSound("audios/jumpLanding.wav")
	sfxSwitch = audio.loadSound("audios/switch.wav")
	sfxPowerUp = audio.loadSound("audios/powerUp.wav")
	sfxGameOver = audio.loadSound("audios/gameOver.wav")
	sfxGameWin = audio.loadSound("audios/gameWin.wav")
	sfxButton = audio.loadSound("audios/button.wav")
	sfxBGMusic = audio.loadStream("audios/music.wav")


	-- CRIAR GRUPOS

	backgroundGroup = display.newGroup()
	middleGroundGroup = display.newGroup()
	movableGroup = display.newGroup()
	darkGroup = display.newGroup()
	lightGroup = display.newGroup()
	activePowerUpOverlayGroup = display.newGroup()
	playerProgressionGroup = display.newGroup()
	HUDGroup = display.newGroup()
	
	-- ATIVAR E CONFIGURAR A FÍSICA

	setPhysics()
	switchTime=false

	-- INSTANCIAR BACKGROUND
	
	background.newBackground(self.levelId)

	--INSTANCIAR PERSONAGEM

	charId = composer.getVariable("selectedCharacter")

	playerGroup = display.newGroup()
	
	player = animation.newAnimation("images/" .. charId .. ".png", 140, 125, 21 + 23 + 5 + 21)
	player.x = parPlayerXPosition
	player.y = parPlayerYPosition
	player.width = W * .1
	player.height = player.width * (125 / 140)
	player.xScale = player.width / 140
	player.yScale = player.height / 125
	
	physics.addBody(player,"dynamic",
	{ shape={- player.width * .3 , - player.height * .4,
			   player.width * .35, - player.height * .4,
			   player.width * .35,   player.height * .5,
			 - player.width * .3 ,   player.height * .5}, bounce=0},
	{ shape={- player.width * .06, player.height * .5,
			   player.width * .11, player.height * .5,
			   player.width * .11, player.height * .7,
			 - player.width * .06, player.height * .7}, isSensor=true}
	)
	player.isFixedRotation = true
	player.canJump = 0
	player.collision = playerCollider
	player:addEventListener( "collision", player)
	player.isSleepingAllowed = false
	player.isBullet = true

	player:setSequence("running")
	player:play()

	playerGroup.x = 0
	playerGroup:insert(player)

	totalCoins = composer.getVariable("stage"..currentLevel.."TotalCoins")

	if not loadsave.loadTable("stage"..currentLevel.."Coins.json") then
		for i= 1, totalCoins do 
			table.insert(stageCoinsTable, i, false)
		end
		loadsave.saveTable(stageCoinsTable,"stage"..currentLevel.."Coins.json")
	else
		stageCoinsTable = loadsave.loadTable("stage"..currentLevel.."Coins.json")
	end

	local currentCoinID = 1

	for i = 1, #self.level.layers[1].objects do
		local t = self.level.layers[1].objects[i]
		if t.type == "EG" then
			levelEndPosition = t.x
		end
		
		if t.type ~= "Z" then
			if t.type == "C" then
				tiles.newTile(t.type,t.x,t.y,t.width,t.height, stageCoinsTable, currentCoinID)
				currentCoinID = currentCoinID +1
			elseif t.type == "T" then
				tiles.newTile(t.type,t.x,t.y,t.width,t.height, stageCoinsTable, currentCoinID, t.properties.tutorialStep)
			else
				tiles.newTile(t.type,t.x,t.y,t.width,t.height)
			end
		end
	end

	-- INSTANCIAR BOTÕES DE AÇÃO

	leftButton = widget.newButton({
		label = "SWITCH ",
		labelColor = {default={1}},
		labelXOffset = W*.13,
		labelYOffset = W*-.15,
		fontSize = 30,
		font = "airstrike.ttf",
		shape = "circle",
		radius=W*.4,
		x=W*-.05,
		y=H*1,
		fillColor = {default={0.8}, over={0.6}},
	})
	leftButton.alpha = 0.12
	leftButton.isHitTestable = false
	HUDGroup:insert(leftButton)


	rightButton = widget.newButton({
		label = "JUMP ",
		labelColor = {default={1}},
		labelXOffset = W*-.13,
		labelYOffset = W*-.15,
		fontSize = 30,
		font = "airstrike.ttf",
		shape = "circle",
		radius=W*.4,
		x=W*1.05,
		y=H*1,
		fillColor = {default={0.8}, over={0.6}},
	})
	rightButton.alpha = 0.12
	rightButton.isHitTestable = false
	HUDGroup:insert(rightButton)

	jumpButtonArea = display.newRect(HUDGroup, W * .5 , H * .5 , display.actualContentWidth * .5, display.actualContentHeight)
	jumpButtonArea.anchorX = 0
	jumpButtonArea.alpha = 0
	jumpButtonArea:addEventListener("touch",onJumpButtonTouch)
	jumpButtonArea.isHitTestable = true

	switchButtonArea = display.newRect(HUDGroup, W * .5, H * .5, display.actualContentWidth * .5, display.actualContentHeight)
	switchButtonArea.anchorX = 1
	switchButtonArea.alpha = 0
	switchButtonArea:addEventListener("touch",onSwitchButtonTouch)	
	switchButtonArea.isHitTestable = true

	if currentLevel == 0 then
		jumpButtonArea.isHitTestable=false
		switchButtonArea.isHitTestable = false
		leftButton.alpha = 0
		rightButton.alpha = 0

		message1 = display.newText(HUDGroup, "PRESS THE RIGHT SCREEN BUTTON TO JUMP ", W*.5, H*.3, "airstrike.ttf", 18)
		message1.alpha=0

		message2 = display.newText(HUDGroup, "JUMP WHILE IN THE AIR TO MAKE A DOUBLE JUMP ", W*.5, H*.3, "airstrike.ttf", 17)
		message2.alpha=0

		message3 = display.newText(HUDGroup, "PRESS THE LEFT SCREEN BUTTON TO SWITCH BETWEEN PLATFORMS ", W*.5, H*.3, "airstrike.ttf", 15)
		message3.alpha=0

		message4 = display.newText(HUDGroup, "POWERUPS GRANTS YOU TEMPORARILY POWERS ", W*.5, H*.3, "airstrike.ttf", 17)
		message4.alpha=0

		message5 = display.newText(HUDGroup, "THIS GIVES YOU A TEMPORARY INCREASE IN YOUR SPEED ", W*.5, H*.3, "airstrike.ttf", 16)
		message5.alpha=0

		message6 = display.newText(HUDGroup, "THIS GIVES YOU A TEMPORARY BOOST IN THE STRENGHTH OF YOUR JUMP ", W*.5, H*.3, "airstrike.ttf", 15)
		message6.alpha=0

		message7 = display.newText(HUDGroup, "THIS GIVES YOU A TEMPORARY INCREASE IN SCORE GAIN ", W*.5, H*.3, "airstrike.ttf", 15)
		message7.alpha=0

		message8 = display.newText(HUDGroup, "THIS TEMPORARILY PREVENTS YOU FROM DYING TO SPIKES ", W*.5, H*.3, "airstrike.ttf", 15)
		message8.alpha=0

		message9 = display.newText(HUDGroup, "COLLECT COINS TO UNLOCK NEW CHARACTERS ", W*.5, H*.3, "airstrike.ttf", 18)
		message9.alpha=0

		message10 = display.newText(HUDGroup, "ROTATE YOUR PHONE TO NAVIGATE IN ZERO GRAVITY ", W*.5, H*.3, "airstrike.ttf", 17)
		message10.alpha=0

		iconPU1 = display.newImage(HUDGroup, "images/powerUp1.png", W*.5, H*.17)
		iconPU1.xScale, iconPU1.yScale = .35, .35
		iconPU1.alpha = 0

		iconPU2 = display.newImage(HUDGroup, "images/powerUp2.png", W*.5, H*.17)
		iconPU2.xScale, iconPU2.yScale = .35, .35
		iconPU2.alpha = 0

		iconPU3 = display.newImage(HUDGroup, "images/powerUp3.png", W*.5, H*.17)
		iconPU3.xScale, iconPU3.yScale = .35, .35
		iconPU3.alpha = 0

		iconPU4 = display.newImage(HUDGroup, "images/powerUp4.png", W*.5, H*.17)
		iconPU4.xScale, iconPU4.yScale = .35, .35
		iconPU4.alpha = 0
	end

	local accelerometerSheetOptions = {
		width = 472/2,
		height = 216,
		numFrames = 2,
	}
	
	local accelerometerSheet = graphics.newImageSheet("images/accelerometerInstruction.png", accelerometerSheetOptions)
	
	accelerometerInstruction = display.newSprite(HUDGroup, accelerometerSheet, {name="default", start=1, count=2, loopCount=0, time = 1500, loopDirection="forward"})
	accelerometerInstruction.x= W*.1; accelerometerInstruction.y = H*.45
	accelerometerInstruction.xScale, accelerometerInstruction.yScale = .4, .4
	accelerometerInstruction.alpha=0

	pauseButton = widget.newButton({
		x = W * .15,
		y = H * .05,
		width = 50,
		height = 50,
		defaultFile = "images/pause.png",
		onPress = onPaused
	})
	
	pauseButton.anchorX, pauseButton.anchorY = 1, 0
	
	-- CONTADOR DE MOEDAS
	coinsCounter = nil
	for i,v in ipairs(stageCoinsTable) do
		if v then coins = coins +1 end
	end

	if currentLevel ~= 0 then	
		local scoreBackground = display.newRoundedRect(HUDGroup, W * 1.05, 10, 110, 25, 5)
		scoreBackground:setFillColor(0, 0, 0, .35)
		scoreBackground.anchorX, scoreBackground.anchorY = 1, 0
			
		local coinsBackground = display.newRoundedRect(HUDGroup, W * 1.05, 48, 110, 38, 5)
		coinsBackground:setFillColor(0, 0, 0, .35)
		coinsBackground.anchorX, coinsBackground.anchorY = 1, 0
			
		scoreCounter = display.newEmbossedText({
			parent = HUDGroup,
			text = score .. " ",
			x = W * 1.03,
			y = H * .0725,
			font = "airstrike.ttf",
			fontSize = 19,
			align = "right"
		})
			
		scoreCounter:setEmbossColor({
			highlight = {r = 1, g = 1, b = 1},
			shadow = {r = 1, g = 1, b = 1}
		})
			
		scoreCounter:setFillColor(1)
		scoreCounter.anchorX, scoreCounter.anchorY = 1, .5
		
		local coinIcon = display.newImageRect(HUDGroup, "images/coin.png", 25, 25)
		coinIcon.x = W * .87
		coinIcon.y = H * .2105
		
		coinsCounter = display.newEmbossedText({
			parent = HUDGroup,
			text = coins.." / "..totalCoins .. " ",
			x = W * 1.03,
			y = H * .21,
			font = "airstrike.ttf",
			fontSize = 16,
			align = "right"
		})
		
		coinsCounter:setEmbossColor({
			highlight = {r = 1, g = 1, b = 1},
			shadow = {r = 1, g = 1, b = 1}
		})
		
		coinsCounter:setFillColor(1)
		coinsCounter.anchorX, coinsCounter.anchorY = 1, .5
	end
	
	-- POWER UP ATIVO
	
	activePowerUpOverlay.background = display.newRect(activePowerUpOverlayGroup, 0, 0, W * .1, H * .05)
	activePowerUpOverlay.background:setFillColor(0)
	
	local totalTimerBarWidth = activePowerUpOverlay.background.width - 6
	
	activePowerUpOverlay.timerBar = display.newRect(activePowerUpOverlayGroup, 0, 0, totalTimerBarWidth, activePowerUpOverlay.background.height - 6)
	activePowerUpOverlay.timerBar.anchorX = 0
	activePowerUpOverlay.timerBar:setFillColor(1)
	
	activePowerUpOverlay.timerBar.totalWidth = totalTimerBarWidth
	
	activePowerUpOverlay.timerBar.x = - activePowerUpOverlay.timerBar.width * .5
	
	activePowerUpOverlay.images = display.newGroup()
	loadPowerUpOverlayImage(activePowerUpOverlay.images, 1)
	loadPowerUpOverlayImage(activePowerUpOverlay.images, 2)
	loadPowerUpOverlayImage(activePowerUpOverlay.images, 3)
	loadPowerUpOverlayImage(activePowerUpOverlay.images, 4)
	
	activePowerUpOverlayGroup:insert(activePowerUpOverlay.images)
	
	activePowerUpOverlayGroup.x = W * .175
	activePowerUpOverlayGroup.y = H * .35
	
	activePowerUpOverlayGroup.isVisible = false
	
	HUDGroup:insert(activePowerUpOverlayGroup)
	
	-- BARRA DE PROGRESSO
	
	playerProgression.background = display.newRoundedRect(playerProgressionGroup, 0, 0, W * .5, H * 0.01, 2)
	playerProgression.background.anchorX = 0
	playerProgression.background.strokeWidth = 3
	playerProgression.background:setStrokeColor(0)
	playerProgression.background:setFillColor(1)
	
	playerProgression.position = display.newImage(playerProgressionGroup, "images/char_" .. charId .. "_head.png")
	
	local hRatio = playerProgression.position.height / playerProgression.position.width
	local imageWidth
	
	if charId == 1 then
		imageWidth = 20
	elseif charId == 2 then
		imageWidth = 27
	elseif charId == 3 then
		imageWidth = 16
	elseif charId == 4 then
		imageWidth = 18
	end
	
	playerProgression.position.width = imageWidth
	playerProgression.position.height = imageWidth * hRatio

	playerProgressionGroup.x = W * .5 - playerProgression.background.width * .5
	playerProgressionGroup.y = H * .05
	
	HUDGroup:insert(playerProgressionGroup)
	
	HUDGroup:insert(pauseButton)

	-- INSERIR ELEMENTOS DENTRO DO GRUPO DO COMPOSER 

	sceneGroup:insert(backgroundGroup)
	sceneGroup:insert(middleGroundGroup)
	sceneGroup:insert(playerGroup)
	sceneGroup:insert(darkGroup)
	sceneGroup:insert(lightGroup)
	sceneGroup:insert(movableGroup)
	sceneGroup:insert(HUDGroup)
	--sceneGroup:insert(fpsCounter)
end

function scene:show( event )     
    local sceneGroup = self.view
    local phase = event.phase    
    if ( phase == "will" ) then
		Runtime:addEventListener("enterFrame",updateFrames)
   		Runtime:addEventListener( "accelerometer", onAccelerate)
   		system.activate('multitouch')
    elseif ( phase == "did" ) then
    	local previous = composer.getSceneName("previous")
		if previous ~= nil then
			composer.removeScene(composer.getSceneName("previous"))
		end
		isPaused = false
		isGameFinished = false
		isFinishing = false
    	local dt = getDeltaTime()

    	physics.setGravity(0,parGravity)

    	audio.setVolume(0.1, {channel = 1})
    	audio.setVolume(0.3, {channel = 2})
		audio.setVolume(0.5,{channel = 4})
    end
end

function scene:hide(event)
	local phase = event.phase
	
	if (phase == "will") then

	elseif (phase == "did") then
		Runtime:removeEventListener("enterFrame",updateFrames)
		Runtime:removeEventListener( "accelerometer", onAccelerate )
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

function updateFrames()
	local dt = getDeltaTime()
	--fpsCounter:updateCounter(dt)

	if not isPaused and isFinishing==true and isGameFinished == false then
		player.x = player.x + parSpeed*dt
		local vx, vy = player:getLinearVelocity() 		
		if vy == 0 then
			if player.sequence ~= "running" then
				player:setSequence("running")
				player:play()
			end
		end
	end
	
	if not isPaused and isFinishing==false and isGameFinished == false then
		if not audio.isChannelActive(1) then
    		bgMusic = audio.play(sfxBGMusic, {channel = 1, loops = -1})
		end
		if audio.isChannelPaused(1) then
			audio.resume(1)
		end

		score = score + 1*(parScoreMultiplier)
		if score%10 == 0 and scoreCounter then
			scoreCounter.text = score .. " "
		end
	
		local vx, vy = player:getLinearVelocity() 
		
		if not parIsZeroGravity then
			-- ANIMAÇÃO DO PERSONAGEM CAINDO
			if vy > 0 then
				if player.sequence ~= "falling" then
					--player:setSequence("falling")
					--player:play()
				end
			-- ANIMAÇÃO DO PERSONAGEM CORRENDO
			elseif vy == 0 then
				if player.sequence ~= "running" then
					player:setSequence("running")
					player:play()
				end
			end
		end
		
		-- MOVIMENTAR ELEMENTOS DE CENÁRIO

		for i = 1, backgroundGroup.numChildren do
			local bg = backgroundGroup[i]
 			if bg.speed then
 				bg.x = bg.x - (parSpeed * bg.speed.x) * dt
 				if bg.x < -bg.width then
 					bg.x = W*1+bg.width
 				end
 			end
 			if bg.x < -1* bg.width*bg.xScale-100 then
 				bg.x = 3* bg.width*bg.xScale-100
 			end 

 		end

 		moviment = parSpeed*dt
		
		movableGroup.x = movableGroup.x - moviment
		lightGroup.x = lightGroup.x - moviment
		darkGroup.x = darkGroup.x - moviment
		playerGroup.x = playerGroup.x - moviment
		player.x = player.x + moviment

		-- CÂMERA ACOMPANHAR PLAYER

		playerLocalX, playerLocalY = player:localToContent(0, 0)

		if (playerLocalY > parPlayerYPosition or playerLocalY<parPlayerYPosition) then
			local difY

			--TESTA SE A DIFERENÇA ENTRE A POSIÇÃO VERTICAL ATUAL E A PADRÃO É POUCA
			if ((playerLocalY-(playerLocalY-parPlayerYPosition)/parVerticalFollowRate+2)>parPlayerYPosition) and ((playerLocalY-(playerLocalY-parPlayerYPosition)/parVerticalFollowRate-2)<parPlayerYPosition) then
				difY = playerLocalY-parPlayerYPosition
				playerGroup.y = playerGroup.y - difY				
			else
				difY = (playerLocalY-parPlayerYPosition)/parVerticalFollowRate
				playerGroup.y = playerGroup.y - difY
			end

			for i = 1, backgroundGroup.numChildren do
				if backgroundGroup[i].speed then
					backgroundGroup[i].y = backgroundGroup[i].y - (difY * backgroundGroup[i].speed.y)
				end
 			end

			movableGroup.y = movableGroup.y - difY
			lightGroup.y = lightGroup.y - difY
			darkGroup.y = darkGroup.y - difY
		end

		--HORIZONTALMENTE, APÓS O FIM DA OBSTRUÇÃO


		if (playerLocalX < parPlayerXPosition or playerLocalX > parPlayerXPosition) then
			local difX
			if (playerLocalX == tempPosition) then

				if ((playerLocalX-(playerLocalX-parPlayerXPosition)/parHorizontalFollowRate+2)>parPlayerXPosition) and ((playerLocalX-(playerLocalX-parPlayerXPosition)/parHorizontalFollowRate-2)<parPlayerXPosition) then
					difX = playerLocalX-parPlayerXPosition
					playerGroup.x = playerGroup.x-difX
				else
					difX = (playerLocalX-parPlayerXPosition)/parHorizontalFollowRate
					playerGroup.x = playerGroup.x-difX
				end

				for i = 1, backgroundGroup.numChildren do
					if backgroundGroup[i].speed then
						backgroundGroup[i].x = backgroundGroup[i].x - (difX * backgroundGroup[i].speed.x)
					end
	 			end

					movableGroup.x = movableGroup.x - difX
					lightGroup.x = lightGroup.x - difX
					darkGroup.x = darkGroup.x - difX
			end
			playerLocalX, playerLocalY = player:localToContent(0, 0)
			tempPosition = playerLocalX
		end

		-- BARRA DE PROGRESSO
		playerProgression.position.x = (player.x / levelEndPosition) * playerProgression.background.width - 5
		
		-- MOSTRA TEMPO RESTANTE DO POWERUP ATIVO
		if activePowerUpOverlayGroup.isVisible then
			activePowerUpTimer = activePowerUpTimer - dt / 60 * 1000
			
			if activePowerUpTimer > 0 then
				activePowerUpOverlay.timerBar.width = activePowerUpTimer / activePowerUpTime * activePowerUpOverlay.timerBar.totalWidth
			else
				activePowerUpOverlay.timerBar.width = 0
			end
		end
		
		-- GAMEOVER QUANDO PERSONAGEM SAI PARA FORA DA TELA
		if ((playerLocalX) < -60) then
			gameOver()
		end
	end
end

return scene