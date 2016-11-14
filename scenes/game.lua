display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local physics = require("physics")
local widget = require( "widget" )
local tiles = require("classes.tiles")
local background = require("classes.background")
local saveState = require("classes.preference")
local animation = require("classes.animation")
local fpsCounter = require("classes.fpsCounter").newFpsCounter()

local scene = composer.newScene()
local runtime = 0
local currentLevel
local charID

local isPaused = true
local switchTime=false
local coins = 0
local totalCoins
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
local pauseButton

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
			lightGroup[i].alpha = 0.1
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
			darkGroup[i].alpha = 0.1
			darkGroup[i].isBodyActive = false			
		end
		switchTime = false
	end
end

local function gameOver()
	audio.stop(1)
	audio.play(sfxGameOver)
    Runtime:removeEventListener( "accelerometer", onAccelerate )
    parIsZeroGravity = false
	composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
end

local function onJumpButtonTouch( event )
	if not isPaused then
		if ( event.phase == "began" and player.canJump > 0) then
			jump()
		elseif ( event.phase == "ended") then
			return true
		end
	end
end

local function onSwitchButtonTouch( event )
    if ( event.phase == "began") then
    switch()
    elseif ( event.phase == "ended") then
    return true
	end
end

local function onAccelerate( event )
	if (parIsZeroGravity==true) then
    	physics.setGravity(0,event.zInstant*1*parAccelerometerSensitivity)
    	parSpeed = parZeroChamberSpeed
		
		print("zero gravity")
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
	
	for i = 1, #activePowerUpOverlay.images do
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
	
	jumpButtonArea.isHitTestable = false
	switchButtonArea.isHitTestable = false
	pauseButton.isVisible = false
	
	player:pause()
	
	composer.showOverlay("scenes.pause", {effect = "fade", time = 200, isModal = true})
end

function scene:resumeGame()
	isPaused = false
	
	physics.start(true)
	
	jumpButtonArea.isHitTestable = true
	switchButtonArea.isHitTestable = true
	pauseButton.isVisible = true
	
	player:play()
end

local function playerCollider( self,event ) 
    if (event.phase == "began") then
		-- RECOMEÇA A CONTAGEM DE PULOS QUANDO O PERSONAGEM ESTÁ COM OS PÉS NO CHÃO
		
    	if ( event.selfElement == 2 and event.other.objType == "ground") then
        	audio.play(sfxJumpLanding, {channel = 2})
        	self.canJump = 2
    	end
    	-- DETECTA SE O PERSONAGEM ALCANÇA O FIM DA FASE
		if ( event.selfElement == 1 and event.other.objType == "endStage") then
			audio.stop(1)
			audio.play(sfxGameWin)

			local tempScore = saveState.getValue("stage"..currentLevel.."Score") or 0
			local tempCoins = saveState.getValue("stage"..currentLevel.."Coins") or 0
			score = (math.floor(score/10))*10			
			if (score>tempScore) then
				saveState.save{["stage"..currentLevel.."Score"]=score}
			end
			if (coins > tempCoins) then
				saveState.save{["stage"..currentLevel.."Coins"]=coins}
			end			
			Runtime:removeEventListener( "accelerometer", onAccelerate )			
			parIsZeroGravity = false
			composer.gotoScene("scenes.gameVictory",{params=coins, effect="slideLeft",time = 500})
    	end
    	    -- DETECTA A COLISÃO DO PERSONAGEM COM AS MOEDAS
    	if ( event.selfElement == 1 and event.other.objType == "coin" ) then
			local temp = event.other
			display.remove(temp)
			coins = coins +1
			score = score + 250
			coinsCounter.text = "COINS: "..coins.." / "..totalCoins
			audio.play(sfxCoin)
      	end
      	    -- COLISÃO COM BLOCOS FATAIS
		if ( event.selfElement == 1 and event.other.objType == "fatal" and canDie==true) then
			gameOver()
    	end

    		-- PORTAIS ESPECIAIS
    	if ( event.selfElement == 1 and event.other.objType == "portal1" and charId~=1) then
			gameOver()
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal2" and charId~=2) then
			gameOver()
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal3" and charId~=3) then
    		gameOver()
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal4" and charId~=4) then
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
			
			print("start")
    	end  
    	if ( event.selfElement == 1 and event.other.objType == "endZeroGravity" ) then
        	parIsZeroGravity=false
        	physics.setGravity(0,parGravity)
        	jumpButtonArea.isHitTestable=true
			player:setSequence("running")
			player:play()
			
			print("finnish")
    	end  
    end
end

function scene:create(event)
	sceneGroup = self.view
	currentLevel = composer.getVariable("selectedStage")
	self.levelId = currentLevel
	self.level = require("levels." .. currentLevel)

	-- CARREGAR SONS

	audio.reserveChannels(2)

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

	for i = 1, #self.level.layers[1].objects do
		local t = self.level.layers[1].objects[i]
		if t.type == "EG" then
			levelEndPosition = t.x
		end
		
		if t.type ~= "Z" then
			tiles.newTile(t.type,t.x,t.y,t.width,t.height)
		end
	end

	-- INSTANCIAR BOTÕES DE AÇÃO

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

	scoreCounter = display.newText(HUDGroup,"SCORE: "..score,W*.4,H*.11,native.systemFontBold,25)
	scoreCounter:setFillColor(1,1,0)

	totalCoins = saveState.getValue("stage"..currentLevel.."totalCoins")
	coinsCounter = display.newText(HUDGroup,"COINS: "..coins.." / "..totalCoins,W*.8,H*.11,native.systemFontBold,25)
	coinsCounter:setFillColor(1,1,0)

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
	
	activePowerUpOverlayGroup.x = W * .1
	activePowerUpOverlayGroup.y = H * .35
	
	activePowerUpOverlayGroup.isVisible = false
	
	HUDGroup:insert(activePowerUpOverlayGroup)
	
	-- BARRA DE PROGRESSO
	
	playerProgression.background = display.newRoundedRect(playerProgressionGroup, 0, 0, W * .5, H * 0.01, 2)
	playerProgression.background.anchorX = 0
	playerProgression.background.strokeWidth = 3
	playerProgression.background:setStrokeColor(0)
	playerProgression.background:setFillColor(1)
	
	playerProgression.position = display.newRoundedRect(playerProgressionGroup, 0, 0, H * 0.03, H * 0.03, H * 0.03)
	
	local playerColor = {}
	
	if charId == 1 then
		playerColor.red = .97
		playerColor.green = .58
		playerColor.blue = .35
	elseif charId == 2 then
		playerColor.red = 0
		playerColor.green = .32
		playerColor.blue = .16
	elseif charId == 3 then
		playerColor.red = .92
		playerColor.green = .19
		playerColor.blue = .22
	elseif charId == 4 then
		playerColor.red = .43
		playerColor.green = .39
		playerColor.blue = .3
	end
	
	playerProgression.position:setFillColor(playerColor.red, playerColor.green, playerColor.blue)
	
	playerProgressionGroup.x = W * .5 - playerProgression.background.width * .5
	playerProgressionGroup.y = H * .95
	
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
	sceneGroup:insert(fpsCounter)

end

function scene:show( event )     
    local sceneGroup = self.view
    local phase = event.phase    
    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
		isPaused = false
    	local dt = getDeltaTime()
    	Runtime:addEventListener("enterFrame",updateFrames)
    	Runtime:addEventListener( "accelerometer", onAccelerate)
    	physics.setGravity(0,parGravity)

    	audio.setVolume(0.05, {channel = 1})
    	audio.setVolume(0.3, {channel = 2})
    end
end

function scene:hide(event)
	local phase = event.phase
	
	if (phase == "will") then
		Runtime:removeEventListener("enterFrame",updateFrames)
		Runtime:removeEventListener( "accelerometer", onAccelerate )
	elseif (phase == "did") then
		
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

function updateFrames()
	local dt = getDeltaTime()
	fpsCounter:updateCounter(dt)
	
	if not isPaused then
		if not audio.isChannelActive(1) then
    		bgMusic = audio.play(sfxBGMusic, {channel = 1, loops = -1})
		end
		if audio.isChannelPaused(1) then
			audio.resume(1)
		end

		score = score + 1*(parScoreMultiplier)
		if score%10 == 0 then
			scoreCounter.text= "SCORE: "..score
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
 			if backgroundGroup[i].speed then
 				backgroundGroup[i].x = backgroundGroup[i].x - (parSpeed * backgroundGroup[i].speed.x) * dt
 				if backgroundGroup[i].x < -backgroundGroup[i].width then
 					backgroundGroup[i].x = W*1+backgroundGroup[i].width
 				end
 			end
 			if backgroundGroup[i].x < -1* backgroundGroup[i].width*backgroundGroup[i].xScale-100 then
 				backgroundGroup[i].x = 3* backgroundGroup[i].width*backgroundGroup[i].xScale-100
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
		if ((playerLocalX) < 0) then
			gameOver()
		end
	end
end

return scene