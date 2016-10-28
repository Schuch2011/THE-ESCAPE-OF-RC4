display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local physics = require("physics")
local widget = require( "widget" )
local coin = require("classes.coins")
local blocks = require("classes.blocks")
local spike = require("classes.spike")
local score = require("classes.score")
local powerUp = require("classes.powerUps")

local scene = composer.newScene()
local runtime = 0

--local gameOver = false
local isPaused = true
local switchTime=false
local coins = 0

-- PARÂMETROS DE JOGABILIDADE

local parPowerUp1Duration = 2000
local parPowerUp2Duration = 2000
local parPowerUp3Duration = 4000
local parPowerUp4Duration = 4000


local parDefaultSpeed = 4--4--10
local parPowerUpSpeed = 6
local parZeroChamberSpeed = 2
local parSpeed = parDefaultSpeed

local parDefaultJumpForce = -17
local parPowerUpJumpForce = -22
local parJumpForce = parDefaultJumpForce

local parDefaultScoreMultiplier = 1
local parPowerUpScoreMultiplier = 2
local parScoreMultiplier = 1

local parPlayerYPosition = 0.45*H
local parPlayerXPosition = 0.25*W

local parGravity = 60
local parAccelerometerSensitivity = 25
local parIsZeroGravity=false


local canDie = true

local jumpButton
local switchButton
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

function activatePowerUp(type)
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
	
	jumpButton.isVisible = false
	switchButton.isVisible = false
	pauseButton.isVisible = false
	
	composer.showOverlay("pause", {effect = "fade", time = 200, isModal = true})
end

function scene:resumeGame()
	isPaused = false
	
	physics.start(true)
	
	jumpButton.isVisible = true
	switchButton.isVisible = true
	pauseButton.isVisible = true
end

local function playerCollider( self,event ) 
    if (event.phase == "began") then
    	-- RECOMEÇA A CONTAGEM DE PULOS QUANDO O PERSONAGEM ESTÁ COM OS PÉS NO CHÃO
    	if ( event.selfElement == 2 and event.other.objType == "ground" ) then
        	self.canJump = 2
    	end
    	-- DETECTA SE O PERSONAGEM ALCANÇA O FIM DA FASE
		if ( event.selfElement == 1 and event.other.objType == "endStage" ) then
			local currentScore = score.get()
			score.load()
			if (currentScore>score.get()) then
				score.set(currentScore)
				score.save()
			end
			
			Runtime:removeEventListener( "accelerometer", onAccelerate )
        	--gameOver = true
			
			parIsZeroGravity = false

			composer.gotoScene("gameVictory","slideLeft",500)
    	end
    	    -- DETECTA A COLISÃO DO PERSONAGEM COM AS MOEDAS
    	if ( event.selfElement == 1 and event.other.objType == "coin" ) then
			local temp = event.other
			display.remove(temp)
			score.add(1)
      	end
      	    -- COLISÃO COM BLOCOS FATAIS
		if ( event.selfElement == 1 and event.other.objType == "fatal" and canDie==true) then
        	--gameOver = true
        	Runtime:removeEventListener( "accelerometer", onAccelerate )

        	parIsZeroGravity = false

			composer.gotoScene("gameOver","slideLeft",500)
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
        	jumpButton:setEnabled(false)
        	jumpButton.alpha = 0
    	end  
 	
    end
end

function scene:create(event)
	sceneGroup = self.view

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

	totalCoins = 0

	-- INSTANCIAR BACKGROUND

	local backgroundColor = display.newRect(sceneGroup,W/2,H/2, W*1.2,H*1.2)
	backgroundColor:setFillColor(0.41,0.59,1)

	local sky = display.newImage(backgroundGroup, "images/sky.png", 0, 0)
 	sky.anchorX, sky.anchorY = 0, 0
	
    local farClouds = display.newImage(backgroundGroup, "images/farClouds.png", 0, -90)
	farClouds.anchorX, farClouds.anchorY = 0, 0
	farClouds.speed = .1

	local nearClouds = display.newImage(backgroundGroup, "images/nearClouds.png", 0, -90)
	nearClouds.anchorX, nearClouds.anchorY = 0, 0
	nearClouds.speed = .4
	
	--INSTANCIAR PERSONAGEM

	player = display.newRect(parPlayerXPosition,parPlayerYPosition,W*.05,H*.15)
	player:setFillColor(0)
	physics.addBody(player,"dynamic",
	{ bounce=0},
	{ shape={W*.010,H*0, W*.010,H*0.08, W*-.010,H*0.08, W*-.010,H*0}, isSensor=true}
	)
	player.isFixedRotation=true
	player.canJump = 0
	player.collision = playerCollider
	player:addEventListener( "collision", player)
	player.isSleepingAllowed = false

	-- INSTANCIAR ELEMENTOS DE CENÁRIO

	blocks.newBlock("neutral",W*1.5,H*(0.8275),(W*3.5),H*.6) --chao
	blocks.newBlock("neutral",W*1.9,H*(0.4775),W*.1,H*.10)
	blocks.newBlock("neutral",W*3.05,H*(0.425),W*.4,H*.25)
	--GAP
	blocks.newBlock("neutral",W*3.60,H*(0.125),W*.20,H*.05)
	--GAP
	blocks.newBlock("neutral",W*3.9,H*(.125),W*.20,H*.05)
	--GAP
	blocks.newBlock("neutral",(W*5.55),H*(1.275),W*2.6,H*1.5) -- chao
	blocks.newBlock("light",W*4.675,H*(0.175),W*0.05,H) -- parede
	blocks.newBlock("dark",W*5.275,H*(0.175),W*0.05,H) -- parede
	spike.newSpike(W*5.875,H*(0.525)-25) 
	spike.newSpike(W*5.875+64,H*(0.525)-25)
	blocks.newBlock("dark",W*7.15,H*(0.25),W*0.2,H*0.05)
	blocks.newBlock("light",W*7.65,H*(0.10),W*0.2,H*0.05)
	blocks.newBlock("dark",W*8.15,H*(-0.05),W*0.2,H*0.05)
	blocks.newBlock("neutral",(W*14.58),H*(-0.15),W*12,H*.3) -- chao
	blocks.newBlock("neutral",W*9.7,H*-.4, W*0.15,H*0.2)
	blocks.newBlock("neutral",W*10.4,H*-.4,W*0.15,H*0.2)
	blocks.newBlock("neutral",W*11.8,H*-.5,W*0.15,H*0.4)
	blocks.newBlock("neutral",W*12.5,H*-.4,W*0.15,H*0.2)
	spike.newSpike(W*14.6,H*-.35)


	blocks.newBlock("fatal",(W*15),H*(1.15),W*30,H*.3)
	blocks.newBlock("neutral",(W*15),H*(-1.4),W*30,H*.3) -- teto

	blocks.newBlock("startZeroGravity",(W*15.5),H*-.35,W*0.2,2*H)

	blocks.newBlock("neutral",W*16.5,H*-0.5,W*0.15,H*0.4)
	blocks.newBlock("neutral",W*17,H*-0.65,W*0.15,H*0.7)

	blocks.newBlock("endGame",W*19.58,H*-.5,W*.20,2*H)

	coin.newCoin(2.45*W,0.4*H)
	coin.newCoin(3.75*W,-0.23*H)
	coin.newCoin(4.975*W,0.25*H)
	coin.newCoin(5.875*W+32,0.05*H)
	coin.newCoin(7.35*W,0.0*H)
	coin.newCoin(12.15*W,-1*H)
	coin.newCoin(16.75*W,-1.2*H)


	powerUp.newPowerUp(1, 9, -0.42)
	powerUp.newPowerUp(2, 11.1, -0.42)
	powerUp.newPowerUp(3, 13.2, -0.42)
	powerUp.newPowerUp(4, 13.9, -0.42)


	-- INSTANCIAR BOTÕES DE AÇÃO

	jumpButton = widget.newButton(
		{
			x = W*0.9,
			y = H*0.85,
			shape = "circle",
			radius = H*.1,
			fillColor = { default={1}, over={0.9} },
			strokeWidth = 3,
			strokeColor = { default={0}, over={0} },
			onPress = onJumpButtonTouch
		}
	)
	jumpButton.alpha = 0.8

	switchButton = widget.newButton(
		{
			x = W*0.1,
			y = H*0.85,
			shape = "circle",
			radius = H*.1,
			fillColor = { default={1}, over={0.9} },
			strokeWidth = 3,
			strokeColor = { default={0}, over={0} },
			onPress = onSwitchButtonTouch
		}
	)
	switchButton.alpha = 0.8

	pauseButton = widget.newButton({
		x = W - W * .05,
		y = H * .05,
		width = 50,
		height = 50,
		defaultFile = "images/pause.png",
		onPress = onPaused
	})
	
	pauseButton.anchorX, pauseButton.anchorY = 1, 0
	
	-- CONTADOR DE MOEDAS

	scoreCounter = score.init({
		fontSize = 20,
		font = native.systemFontBold,
		x = W * .5,
		y = H*.11,
		maxDigits = 2,
		leadingZeros = false,
		filename = "scorefile.txt",
		varMaxCoins = totalCoins,
	})


	HUDGroup:insert(scoreCounter)
	HUDGroup:insert(jumpButton)
	HUDGroup:insert(switchButton)
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
    	Runtime:addEventListener( "accelerometer", onAccelerate )
    	score.set(0)
    	physics.setGravity(0,parGravity)
    end
end

function scene:hide(event)
	local phase = event.phase
	
	if (phase == "will") then
		
	elseif (phase == "did") then
	
		--physics.pause()
	
		Runtime:removeEventListener("enterFrame",updateFrames)
	end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)




function updateFrames()
	local dt = getDeltaTime()

	if not isPaused then
		-- MOVIMENTAR ELEMENTOS DE CENÁRIO

		for i = 1, backgroundGroup.numChildren do
 			if backgroundGroup[i].speed then
 				backgroundGroup[i].x = backgroundGroup[i].x - (parSpeed * backgroundGroup[i].speed) * dt
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
			local difY = player.y-parPlayerYPosition
			player.y = parPlayerYPosition

			for i = 1, backgroundGroup.numChildren do
 				backgroundGroup[i].y = backgroundGroup[i].y - difY
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

		-- GAMEOVER QUANDO PERSONAGEM SAI PARA FORA DA TELA

		if ((player.x + player.width / 2) < 0) then
			--gameOver = true
			parIsZeroGravity = false

			composer.gotoScene("gameOver","slideLeft",500)
		end

		-- if (player.y >= H+(player.height/2)) then
		-- 	gameOver = true
		-- 	composer.gotoScene("gameOver","slideLeft",500)
		-- end
	end
end







return scene




