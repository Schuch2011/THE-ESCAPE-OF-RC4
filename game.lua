display.setStatusBar( display.HiddenStatusBar )

local W = display.contentWidth
local H = display.contentHeight

local composer = require("composer")
local widget = require( "widget" )
local physics = require("physics")

local scene = composer.newScene()
local runtime = 0


local gameOver = false
--local player
local switchTime=false
local coins = 0

-- PARÂMETROS DE JOGABILIDADE

local parSpeed = 4
local parJumpForce = -17
local parGravity = 60



local function setPhysics() -- INICIAR E CONFIGURAR A SIMULAÇÃO DE FÍSICA
	physics.start(true)
	physics.setGravity(0,parGravity)
	--physics.setDrawMode("hybrid")
end

local function onJumpButtonTouch( event )
    if ( event.phase == "began" and player.canJump > 0) then
    jump()
    elseif ( event.phase == "ended") then
    return true
	end
end

local function onSwitchButtonTouch( event )
    if ( event.phase == "began") then
    switch()
    elseif ( event.phase == "ended") then
    return true
	end
end
 
local function getDeltaTime() -- CALCULAR O TEMPO DESDE O ÚLTIMO FRAME GERADO
    local temp = system.getTimer()
    local dt = (temp-runtime) / (1000/60)
    runtime = temp
    return dt
end

local function playerCollider( self,event ) 
	-- RECOMEÇA A CONTAGEM DE PULOS QUANDO O PERSONAGEM ESTÁ COM OS PÉS NO CHÃO
	if ( event.selfElement == 2 and event.other.objType == "ground" ) then
    	if ( event.phase == "began" ) then
        	self.canJump = 2
    	end
	end

	-- DETECTA SE O PERSONAGEM ALCANÇA O FIM DA FASE
	if ( event.selfElement == 1 and event.other.objType == "endStage" ) then
		if ( event.phase == "began" ) then
        	gameOver = true
			composer.gotoScene("gameVictory","slideLeft",500)
      	end
    end

    -- DETECTA A COLISÃO DO PERSONAGEM COM AS MOEDAS
    if ( event.selfElement == 1 and event.other.objType == "coin" ) then
		if ( event.phase == "began" ) then
			local coin = event.other
			display.remove(coin)
			coins = coins + 1
			coinsCounter.text="COINS: "..coins
      	end
    end
end


function scene:create(event)
	sceneGroup = self.view

	backGroundGroup = display.newGroup()
	middleGroundGroup = display.newGroup()

	movableGroup = display.newGroup()
	darkGroup = display.newGroup()
	lightGroup = display.newGroup()

	HUDGroup = display.newGroup()
	
	-- ATIVAR E CONFIGURAR A FÍSICA

	setPhysics()
	switchTime=false

	-- INSTANCIAR BACKGROUND

	background = display.newRect(backGroundGroup,W/2,H/2,W*1.2,H)
	background:setFillColor(.8)
	
	--INSTANCIAR PERSONAGEM

	player = display.newRect(W*.4,H*.65,W*.05,H*.15)
	player:setFillColor(0)
	physics.addBody(player,"dynamic",
	{ bounce=0},
	{ shape={W*.015,H*0,W*.015,H*0.08,W*-.015,H*0.08,W*-.015,H*0}, isSensor=true}
	)
	player.isFixedRotation=true
	player.canJump = 0
	player.collision = playerCollider
	player:addEventListener( "collision", player)

	-- INSTANCIAR ELEMENTOS DE CENÁRIO

	box1 = display.newRect(lightGroup,W*1.7,H*.75,W*.20,H*.25)
	box1:setFillColor(0)
	physics.addBody(box1,"static",{bounce=0})
	box1.objType = "ground"

	box2 = display.newRect(darkGroup,W*2.15,H*.45,W*.20,H*.05)
	box2:setFillColor(0)
	physics.addBody(box2,"static",{bounce=0})
	box2.objType = "ground"
	box2.alpha = 0.1
	box2.isBodyActive = false

	box3 = display.newRect(lightGroup,W*2.60,H*.45,W*.20,H*.05)
	box3:setFillColor(0)
	physics.addBody(box3,"static",{bounce=0})
	box3.objType = "ground"

	box4 = display.newRect(darkGroup,W*3.05,H*.45,W*.20,H*.05)
	box4:setFillColor(0)
	physics.addBody(box4,"static",{bounce=0})
	box4.objType = "ground"
	box4.alpha = 0.1
	box4.isBodyActive = false

	box5 = display.newRect(lightGroup,W*3.50,H*.45,W*.20,H*.05)
	box5:setFillColor(0)
	physics.addBody(box5,"static",{bounce=0})
	box5.objType = "ground"

	box6 = display.newRect(darkGroup,W*3.95,H*.45,W*.20,H*.05)
	box6:setFillColor(0)
	physics.addBody(box6,"static",{bounce=0})
	box6.objType = "ground"
	box6.alpha = 0.1
	box6.isBodyActive = false

	endGameBox = display.newRect(movableGroup,W*4.65,H*.5,W*.20,H)
	endGameBox:setFillColor(0)
	physics.addBody(endGameBox,"static",{bounce=0})
	endGameBox.objType = "endStage"
	endGameBox.alpha = 0

	coin1 = display.newImageRect(movableGroup, "images/coin.png", 32, 32)
	coin1.x= W*0.9
	coin1.y = H*0.75
	coin1.objType = "coin"
	physics.addBody(coin1,"static",{bounce=0, isSensor=true})

	coin2 = display.newImageRect(movableGroup, "images/coin.png", 32, 32)
	coin2.x= W*1.7
	coin2.y = H*0.5
	coin2.objType = "coin"
	physics.addBody(coin2,"static",{bounce=0, isSensor=true})

	coin3 = display.newImageRect(movableGroup, "images/coin.png", 32, 32)
	coin3.x= W*2.375
	coin3.y = H*0.1
	coin3.objType = "coin"
	physics.addBody(coin3,"static",{bounce=0, isSensor=true})

	-- INSTANCIAR CHÃO

	ground1 = display.newRect(movableGroup,W*.85,H,(W*1.7+box1.width),H*.3)
	ground1:setFillColor(0)
	physics.addBody(ground1,"static",{bounce=0})
	ground1.objType = "ground"

	ground2 = display.newRect(movableGroup,(W*4.65+box6.width),H,W*1,H*.3)
	ground2:setFillColor(0)
	physics.addBody(ground2,"static",{bounce=0})
	ground2.objType = "ground"

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

	HUDGroup:insert(jumpButton)
	HUDGroup:insert(switchButton)

	coinsCounter = display.newText(HUDGroup,"COINS: "..coins,W*0.80,H*.11,native.systemFontBold, 20)
	coinsCounter:setFillColor(0)

	-- INSERIR ELEMENTOS DENTRO DO GRUPO DO COMPOSER 

	sceneGroup:insert(backGroundGroup)
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
    	gameOver = false
    	local dt = getDeltaTime()
    	Runtime:addEventListener("enterFrame",updateFrames)
    end
end


scene:addEventListener("create",scene)
scene:addEventListener("show",scene)

function jump() -- AÇÃO DE PULO
	player:applyForce(0,parJumpForce,player.x,player.y)
	player:setLinearVelocity( 0,0 )
	player.canJump = player.canJump - 1
end

function switch() -- MECÂNICA DE INVERSÃO DOS ELEMENTOS DO CENÁRIO
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


function updateFrames()
	if gameOver == false then
		local dt = getDeltaTime()

		-- MOVIMENTAR ELEMENTOS DE CENÁRIO

		for i=1, movableGroup.numChildren do
			movableGroup[i].x = movableGroup[i].x - parSpeed*dt
		end

		for i=1, lightGroup.numChildren do
			lightGroup[i].x = lightGroup[i].x - parSpeed*dt
		end

		for i=1, darkGroup.numChildren do
			darkGroup[i].x = darkGroup[i].x - parSpeed*dt
		end

		-- GAMEOVER QUANDO PERSONAGEM SAI PARA FORA DA TELA

		if (player.x <= -(player.width/2)) then
			gameOver = true
			composer.gotoScene("gameOver","slideLeft",500)
		end

		if (player.y >= H+(player.height/2)) then
			gameOver = true
			composer.gotoScene("gameOver","slideLeft",500)
		end
	end
end

return scene




