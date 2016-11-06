display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local physics = require("physics")
local widget = require( "widget" )
local coin = require("classes.coins")
local blocks = require("classes.blocks")
local spike = require("classes.spike")
local saveState = require("classes.preference")
local powerUp = require("classes.powerUps")
local animation = require("classes.animation")

local scene = composer.newScene()
local runtime = 0
local currentLevel
local charID

--local gameOver = false
local isPaused = true
local switchTime=false
local coins = 0
local totalCoins
local score = 0

-- PARÂMETROS DE JOGABILIDADE

local parPowerUp1Duration = 2000
local parPowerUp2Duration = 2000
local parPowerUp3Duration = 4000
local parPowerUp4Duration = 4000


local parDefaultSpeed = 4--4--10
local parPowerUpSpeed = 6
local parZeroChamberSpeed = 2
local parSpeed = parDefaultSpeed

local parDefaultJumpForce = -17---20
local parPowerUpJumpForce = -25---26
local parJumpForce = parDefaultJumpForce

local parDefaultScoreMultiplier = 1
local parPowerUpScoreMultiplier = 2
local parScoreMultiplier = 1

local parPlayerYPosition = 0.55*H
local parPlayerXPosition = 0.25*W
local parVerticalFollowRate = 5  -- Frames necessários para a câmera alcançar a posição vertical padrão do personagem
local parHorizontalFollowRate = 120  -- Frames necessários para a câmera alcançar a posição horizontal padrão do personagem
local tempPosition

local parGravity = 60
local parAccelerometerSensitivity = 25
local parIsZeroGravity=false


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
	
	--player:setSequence("jumping")
	--player:play()
end

local function switch() -- MECÂNICA DE INVERSÃO DOS ELEMENTOS DO CENÁRIO
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
	end
end
 
local function getDeltaTime() -- CALCULAR O TEMPO DESDE O ÚLTIMO FRAME GERADO
    local temp = system.getTimer()
    local dt = (temp-runtime) / (1000/60)
    runtime = temp
    return dt
end

local function activatePowerUp(type)
	if (type == 1) then
		parSpeed = parPowerUpSpeed
		timer.performWithDelay(parPowerUp1Duration,function ()	parSpeed=parDefaultSpeed end)
	end
	if (type == 2) then
		parJumpForce = parPowerUpJumpForce
		timer.performWithDelay(parPowerUp2Duration,function ()	parJumpForce=parDefaultJumpForce end)
	end
	if (type == 3) then
		parScoreMultiplier = parPowerUpScoreMultiplier
		timer.performWithDelay(parPowerUp3Duration,function ()	parScoreMultiplier= parDefaultScoreMultiplier end)
	end
	if (type == 4) then
		canDie = false
		timer.performWithDelay(parPowerUp4Duration,function ()	canDie=true end)
	end

	return powerUp
end

local function onPaused()
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
		
    	if ( event.selfElement == 2 and event.other.objType == "ground" ) then
        	self.canJump = 2
    	end
    	-- DETECTA SE O PERSONAGEM ALCANÇA O FIM DA FASE
		if ( event.selfElement == 1 and event.other.objType == "endStage") then
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
        	--gameOver = true
			
			parIsZeroGravity = false

			composer.gotoScene("scenes.gameVictory",{params = currentLevel, effect="slideLeft",time = 500})
    	end
    	    -- DETECTA A COLISÃO DO PERSONAGEM COM AS MOEDAS
    	if ( event.selfElement == 1 and event.other.objType == "coin" ) then
			local temp = event.other
			display.remove(temp)
			coins = coins +1
			score = score + 250
			coinsCounter.text = "COINS: "..coins.." / "..totalCoins
      	end
      	    -- COLISÃO COM BLOCOS FATAIS
		if ( event.selfElement == 1 and event.other.objType == "fatal" and canDie==true) then
        	--gameOver = true
        	Runtime:removeEventListener( "accelerometer", onAccelerate )

        	parIsZeroGravity = false

			composer.gotoScene("scenes.gameOver",{params = currentLevel, effect="slideLeft",time = 500})
    	end
    	    -- COLISÃO COM POWERUP 1 -- AUMENTO TEMPORÁRIO NA VELOCIDADE DO JOGADOR
		if ( event.selfElement == 1 and event.other.objType == "powerUp1" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(1)
    	end
    	    -- COLISÃO COM POWERUP 2 -- AUMENTO TEMPORÁRIO DA ALTURA DO PULO
		if ( event.selfElement == 1 and event.other.objType == "powerUp2" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(2)
    	end
    	    -- COLISÃO COM POWERUP 3 -- AUMENTO NA TAXA DE SCORE GANHOS
		if ( event.selfElement == 1 and event.other.objType == "powerUp3" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(3)
    	end
    	    -- COLISÃO COM POWERUP 4 -- INVENCIBILIDADE A OBSTÁCULOS NORMAIS
		if ( event.selfElement == 1 and event.other.objType == "powerUp4" ) then
        	local temp = event.other
			display.remove(temp)
			activatePowerUp(4)
    	end  
    	if ( event.selfElement == 1 and event.other.objType == "startZeroGravity" ) then
        	parIsZeroGravity=true
        	jumpButtonArea.isHitTestable=false
    	end  
    end
end

function scene:create(event)
	sceneGroup = self.view
	currentLevel = event.params
	self.levelId = event.params
	self.level = require("levels." .. self.levelId)

	-- CRIAR GRUPOS

	backgroundGroup = display.newGroup()
	middleGroundGroup = display.newGroup()
	movableGroup = display.newGroup()
	darkGroup = display.newGroup()
	lightGroup = display.newGroup()
	HUDGroup = display.newGroup()
	
	-- ATIVAR E CONFIGURAR A FÍSICA

	setPhysics()
	switchTime=false

	-- INSTANCIAR BACKGROUND
	
	local backgroundColor = display.newRect(sceneGroup,W/2,H/2, W*1.2,H*1.2)
 	backgroundColor:setFillColor(0.41,0.59,1)

	local sky = display.newImage(backgroundGroup, "images/sky.png", 0, 0)
 	sky.anchorX, sky.anchorY = 0, 0

    local farClouds = display.newImage(backgroundGroup, "images/farClouds.png", 0, -90)
	farClouds.anchorX, farClouds.anchorY = 0, 0
	farClouds.speed = {x = .015, y = .0075}

	local nearClouds = display.newImage(backgroundGroup, "images/nearClouds.png", 0, -90)
	nearClouds.anchorX, nearClouds.anchorY = 0, 0
	nearClouds.speed = {x = .15, y = .05}
	
	--INSTANCIAR PERSONAGEM

	local charId= saveState.getValue("selectedCharacter")
	
	player = animation.newAnimation("images/" .. charId .. ".png", 140, 125, 21)
	player.x = parPlayerXPosition
	player.y = parPlayerYPosition
	player.width = W*.09
	player.height = H*.15
	player.xScale = player.width / 140
	player.yScale = player.height / 125
	
	physics.addBody(player,"dynamic",
	{ shape={- player.width * .3 , - player.height * .4,
			   player.width * .35, - player.height * .4,
			   player.width * .35,   player.height * .5,
			 - player.width * .3 ,   player.height * .5}, bounce=0},
	{ shape={- player.width * .1, 0,
			   player.width * .1, 0,
			   player.width * .1, player.height * .5,
			 - player.width * .1, player.height * .5}, isSensor=true}
	)
	player.isFixedRotation=true
	player.canJump = 0
	player.collision = playerCollider
	player:addEventListener( "collision", player)
	player.isSleepingAllowed = false

	player:setSequence("running")
	player:play()

	self.blocks = {}
	for i = 1, #self.level.blocks do
		local b = self.level.blocks[i]
		table.insert(self.blocks, blocks.newBlock(b.type,b.x,b.y,b.w,b.h))
	end

	self.spikes = {}
	for i = 1, #self.level.spikes do
		local s = self.level.spikes[i]
		table.insert(self.spikes, spike.newSpike(s.x,s.y))
	end

	self.coins = {}
	for i = 1, #self.level.coins do
		local c = self.level.coins[i]
		table.insert(self.coins, coin.newCoin(c.x,c.y))
	end

	self.powerUps = {}
	for i = 1, #self.level.powerUps do
		local p = self.level.powerUps[i]
		table.insert(self.powerUps, powerUp.newPowerUp(p.type,p.x,p.y))
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
	scoreCounter:setFillColor(0)

	totalCoins = saveState.getValue("stage"..currentLevel.."totalCoins")
	coinsCounter = display.newText(HUDGroup,"COINS: "..coins.." / "..totalCoins,W*.8,H*.11,native.systemFontBold,25)
	coinsCounter:setFillColor(0)

	HUDGroup:insert(pauseButton)

	-- INSERIR ELEMENTOS DENTRO DO GRUPO DO COMPOSER 

	sceneGroup:insert(backgroundGroup)
	sceneGroup:insert(middleGroundGroup)
	sceneGroup:insert(player)
	sceneGroup:insert(darkGroup)
	sceneGroup:insert(lightGroup)
	sceneGroup:insert(movableGroup)
	sceneGroup:insert(HUDGroup)

end

function scene:show( event )
     
    local sceneGroup = self.view
    local phase = event.phase


    

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    	--gameOver = false
		isPaused = false
    	local dt = getDeltaTime()
    	Runtime:addEventListener("enterFrame",updateFrames)
    	Runtime:addEventListener( "accelerometer", onAccelerate)
    	physics.setGravity(0,parGravity)
    end
end

function scene:hide(event)
	local phase = event.phase
	
	if (phase == "will") then
		Runtime:removeEventListener("enterFrame",updateFrames)
	elseif (phase == "did") then
		
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)

function updateFrames()
	local dt = getDeltaTime()

	if not isPaused then

		score = score + 1*(parScoreMultiplier)
		if score%10 == 0 then
			scoreCounter.text= "SCORE: "..score
		end

		local vx, vy = player:getLinearVelocity()
		
		-- ANIMAÇÃO DO PERSONAGEM CAINDO
		if vy > 0 then
			if player.sequence ~= "falling" then
				--player:setSequence("falling")
				--player:play()
			end
		-- ANIMAÇÃO DO PERSONAGEM CORRENDO
		elseif vy == 0 then
			if player.sequence ~= "running" then
				--player:setSequence("running")
				--player:play()
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

 		end
		for i=1, movableGroup.numChildren do
			movableGroup[i].x = movableGroup[i].x - parSpeed*dt
		end

		for i=1, lightGroup.numChildren do
			lightGroup[i].x = lightGroup[i].x - parSpeed*dt
		end

		for i=1, darkGroup.numChildren do
			darkGroup[i].x = darkGroup[i].x - parSpeed*dt
		end

		-- CÂMERA ACOMPANHAR PLAYER

		if (player.y > parPlayerYPosition or player.y<parPlayerYPosition) then
			local difY = (player.y-parPlayerYPosition)/parVerticalFollowRate
			player.y = player.y-(player.y-parPlayerYPosition)/parVerticalFollowRate

			for i = 1, backgroundGroup.numChildren do
				if backgroundGroup[i].speed then
					backgroundGroup[i].y = backgroundGroup[i].y - (difY * backgroundGroup[i].speed.y)
				end
 			end
			for i=1, movableGroup.numChildren do
				movableGroup[i].y = movableGroup[i].y - difY
			end	
			
			for i=1, lightGroup.numChildren do
				lightGroup[i].y = lightGroup[i].y - difY
			end
	
			for i=1, darkGroup.numChildren do
				darkGroup[i].y = darkGroup[i].y - difY
			end
		end

		--HORIZONTALMENTE, APÓS O FIM DA OBSTRUÇÃO

		if (player.x < parPlayerXPosition) then

			if (player.x == tempPosition) then

				local difX = (player.x-parPlayerXPosition)/parHorizontalFollowRate
				player.x = player.x+parPlayerXPosition/parHorizontalFollowRate

	
				for i = 1, backgroundGroup.numChildren do
					if backgroundGroup[i].speed then
						backgroundGroup[i].x = backgroundGroup[i].x - (difX * backgroundGroup[i].speed.x)
					end
	 			end
				for i=1, movableGroup.numChildren do
					movableGroup[i].x = movableGroup[i].x - difX
				end	
					
				for i=1, lightGroup.numChildren do
					lightGroup[i].x = lightGroup[i].x - difX
				end
			
				for i=1, darkGroup.numChildren do
					darkGroup[i].x = darkGroup[i].x - difX
				end
			end
			tempPosition = player.x
		end

		-- GAMEOVER QUANDO PERSONAGEM SAI PARA FORA DA TELA

		if ((player.x + player.width / 2) < 0) then
			--gameOver = true
			parIsZeroGravity = false

			composer.gotoScene("scenes.gameOver",{params = currentLevel, effect="slideLeft",time = 500})
		end
	end
end







return scene




