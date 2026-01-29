GameBoard=Class{}
local dragging=true

a=love.graphics.newFont(100)
love.graphics.setFont(a)

function GameBoard:init()
	self.aiMode=false
	self.deck=Deck()
	self.pile={}
	self.uiFont=love.graphics.newFont("assets/fonts/arial.ttf",16)
	self.musicButton={x=VIRTUAL_WIDTH-62,y=12,width=44,height=32}

	for i=1,7 do
		self.pile[i]=Pile(OFFSET_LEFT*i+(i-1)*(CARD_WIDTH+OFFSET_LEFT),OFFSET_GAP_VER+CARD_HEIGHT)
	end

	self.waste=Waste()

	--the dragging Card
	gDragCard=nil
end

function GameBoard:update(dt)
	local rules=(GGameContext and GGameContext:getRuleSystem()) or GRules
	local animation=(GGameContext and GGameContext:getAnimationSystem()) or GAnimation
	local input=(GGameContext and GGameContext:getInputSystem()) or GInput
	local score=(GGameContext and GGameContext:getScoreSystem()) or GScoreSystem
	if not rules:isGameOver(self) then
		if animation then animation:update(dt) end
		local keyPressed=(input and input:getLastKey()) or love.keyboard.lastKeyPressed
		local lastClick=(input and input:getLastClick()) or love.mouse.lastClick
		local mx,my=love.mouse.x,love.mouse.y
		self.musicHovered=mx>=self.musicButton.x and mx<=self.musicButton.x+self.musicButton.width and my>=self.musicButton.y and my<=self.musicButton.y+self.musicButton.height
		if lastClick==1 then
			if mx>=self.musicButton.x and mx<=self.musicButton.x+self.musicButton.width and my>=self.musicButton.y and my<=self.musicButton.y+self.musicButton.height then
				toggleMusic()
			end
		end
		if keyPressed=='e' and GGameContext then
			GGameContext:toggleEndlessMode()
		elseif keyPressed=='a' then 
			self.aiMode=not self.aiMode
			self.aiMoves={}
			makeDecision(table.copy(self.waste),table.copy(self.deck),table.copy(self.pile),self.aiMoves)
			-- for i=1,#self.aiMoves do print(self.aiMoves[i].toX,self.aiMoves[i].toY) end
		elseif keyPressed=='h' then
			local piles,waste=self.pile,self.waste
			for i,pile in ipairs(piles) do
				if #pile.cards>0 and waste.cards[#waste.cards] and ((waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value+1>13 and 1 or pile.cards[#pile.cards].value+1)) or (waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value-1<1 and 13 or pile.cards[#pile.cards].value-1)))  then
					print('Move '..getCardInfo(pile.cards[#pile.cards])..' to the waste!')
					break
				end
			end
		elseif keyPressed=='m' then
			toggleMusic()
		end
		if self.aiMode then fcursor.updateT(self.aiMoves,dt) end
		self.deck:update(dt)
		self.waste:update(dt)
		for i=1,7 do
			if lastClick~=2 then
				self.pile[i]:update(dt)
			else
				if self.pile[i].top and cardIsHovered(self.pile[i].top) then
					playCardPlaceSound()
					self.pile[i].top:move(self.waste)
					self.waste:push(self.pile[i].top)
					table.insert(self.waste.undodata,self.pile[i])
					if score then score:recordMove('pile') end
					self.pile[i]:pop()
					break
				end
			end
		end
		if gDragCard then gDragCard:update() end
		--donot drag the card when mouse is released or not pressed
		if not love.mouse.isDown(1) and gDragCard  then gDragCard=nil end
	else
		gameOver(self)
	end
end

function GameBoard:render()
	drawBackground()
	self.deck:render()
	self.waste:render()

	-- antes de desenhar as pilhas, marca quais cartas do topo são jogáveis
	local rules=(GGameContext and GGameContext:getRuleSystem()) or GRules
	for i=1,7 do
		local pile=self.pile[i]
		if pile.top then
			pile.top.highlight = rules:checkLockWaste(pile.top,self.waste)
		end
		pile:render()
	end

	if gDragCard then gDragCard:render() end
	if self.musicHovered then
		love.graphics.setColor(0.2,0.2,0.2,0.9)
	else
		love.graphics.setColor(0.1,0.1,0.1,0.8)
	end
	love.graphics.rectangle('fill',self.musicButton.x,self.musicButton.y,self.musicButton.width,self.musicButton.height,10,10)
	love.graphics.setColor(1,1,1,0.85)
	love.graphics.rectangle('line',self.musicButton.x,self.musicButton.y,self.musicButton.width,self.musicButton.height,10,10)
	love.graphics.setColor(1,1,1,1)
	local music=getMusicRef()
	local muted=not (music and music:isPlaying())
	drawMusicIcon(self.musicButton.x+8,self.musicButton.y+6,20,muted)
	lovecc.setColor('black')
	lovecc.reset()
end

function fcursor.drag(x,y) end

function fcursor.click(x,y,btn)
	local board=GGameContext:getBoard() or gameBoard
	if btn==1 then board.deck.aiClicked=true end
	local input=(GGameContext and GGameContext:getInputSystem()) or GInput
	if input then
		input:setMousePressed(x,y,btn)
	else
		love.mouse.lastClick=btn
	end
end
