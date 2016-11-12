display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local physics = require("physics")
local widget = require( "widget" )
local tiles = require("classes.tiles")
local saveState = require("classes.preference")
local animation = require("classes.animation")
local fpsCounter = require("classes.fpsCounter").newFpsCounter()

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
local parAccelerometerSensitivity = 500
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
		player.timeScale = 1.5
		timer.performWithDelay(parPowerUp1Duration,function ()	parSpeed=parDefaultSpeed; player.timeScale = 1 end)
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

			composer.gotoScene("scenes.gameVictory",{params=coins, effect="slideLeft",time = 500})
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

			composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
    	end

    		-- PORTAIS ESPECIAIS
    	if ( event.selfElement == 1 and event.other.objType == "portal1" and charId~=1) then
       		Runtime:removeEventListener( "accelerometer", onAccelerate )
        	parIsZeroGravity = false
			composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal2" and charId~=2) then
       		Runtime:removeEventListener( "accelerometer", onAccelerate )
        	parIsZeroGravity = false
			composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal3" and charId~=3) then
       		Runtime:removeEventListener( "accelerometer", onAccelerate )
        	parIsZeroGravity = false
			composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
    	end
    	if ( event.selfElement == 1 and event.other.objType == "portal4" and charId~=4) then
       		Runtime:removeEventListener( "accelerometer", onAccelerate )
        	parIsZeroGravity = false
			composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
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
        	physics.setGravity(0,0)
        	jumpButtonArea.isHitTestable=false
    	end  
    end
end

function scene:create(event)
	sceneGroup = self.view
	currentLevel = composer.getVariable("selectedStage")
	self.levelId = currentLevel
	self.level = require("levels." .. currentLevel)

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
 	backgroundColor:setFillColor(0.3764705882352941,0.5725490196078431,0.7686274509803922)

 	for i = 1, 4 do
		local background = display.newImage(backgroundGroup, "images/background/background_"..math.random(3)..".png",0, 0)
		background.anchorX, background.anchorY = 0,0
		background.xScale, background.yScale = 0.5,0.5
		background.x = (i-1)*background.width*background.xScale-(i-1)*1-100
		background.speed = {x = 0.03, y=0.05}
	end
	for i = 1, 4 do
		local middleGround = display.newImage(backgroundGroup, "images/background/middleGround_"..math.random(5)..".png",0, 0)
		middleGround.anchorX, middleGround.anchorY = 0,0
		middleGround.xScale, middleGround.yScale = 0.5,0.5
		middleGround.x = (i-1)*middleGround.width*middleGround.xScale-(i-1)*1-100
		middleGround.speed = {x = 0.07, y=0.1}
	end
	for i = 1, 4 do
		local foreGround = display.newImage(backgroundGroup, "images/background/foreGround_"..math.random(3)..".png",0, 0)
		foreGround.anchorX, foreGround.anchorY = 0,0
		foreGround.xScale, foreGround.yScale = 0.5,0.5
		foreGround.x = (i-1)*foreGround.width*foreGround.xScale-(i-1)*1-100
		foreGround.speed = {x = 0.15, y=0.2}
	end

	--INSTANCIAR PERSONAGEM

	charId = composer.getVariable("selectedCharacter")

	playerGroup = display.newGroup()
	
	player = animation.newAnimation("images/" .. charId .. ".png", 140, 125, 21)
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
			   player.width * .11, player.height * .3,
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

		-- GAMEOVER QUANDO PERSONAGEM SAI PARA FORA DA TELA
		if ((playerLocalX) < 0) then
			--gameOver = true
			parIsZeroGravity = false

			composer.gotoScene("scenes.gameOver",{effect="slideLeft",time = 500})
		end
	end

end







return scene




