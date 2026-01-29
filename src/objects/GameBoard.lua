GameBoard=Class{}
local dragging=true

a=love.graphics.newFont(100)
love.graphics.setFont(a)

local function serializeCards(cards)
	local list={}
	for i=1,#cards do
		local c=cards[i]
		list[i]={suit=c.suit,value=c.value,x=c.x,y=c.y,back=c.back}
	end
	return list
end

local function restoreCards(list)
	local cards={}
	for i=1,#list do
		local data=list[i]
		local card=Card(data.suit,data.value,data.x,data.y)
		card.back=data.back
		cards[i]=card
	end
	return cards
end

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

function GameBoard:snapshot()
	local piles={}
	for i=1,7 do
		local pile=self.pile[i]
		piles[i]={x=pile.x,y=pile.y,cards=serializeCards(pile.cards)}
	end
	return {
		deck={x=self.deck.x,y=self.deck.y,cards=serializeCards(self.deck.cards)},
		waste={x=self.waste.x,y=self.waste.y,cards=serializeCards(self.waste.cards)},
		piles=piles,
		aiMode=self.aiMode
	}
end

function GameBoard:applySnapshot(snapshot)
	if not snapshot then return end
	self.aiMode=snapshot.aiMode
	self.deck.cards=restoreCards(snapshot.deck.cards)
	self.deck.x,self.deck.y=snapshot.deck.x,snapshot.deck.y
	self.deck:resetTop()
	self.waste.cards=restoreCards(snapshot.waste.cards)
	self.waste.x,self.waste.y=snapshot.waste.x,snapshot.waste.y
	self.waste:resetTop()
	self.waste.undodata={}
	self.waste.redodata={}
	for i=1,7 do
		local pileData=snapshot.piles[i]
		local pile=self.pile[i]
		pile.cards=restoreCards(pileData.cards)
		pile:resetTop()
		pile.x,pile.y=pileData.x,pileData.y
	end
	gDragCard=nil
end

function GameBoard:update(dt)
	local rules=(GGameContext and GGameContext:getRuleSystem()) or GRules
	local animation=(GGameContext and GGameContext:getAnimationSystem()) or GAnimation
	local input=(GGameContext and GGameContext:getInputSystem()) or GInput
	local score=(GGameContext and GGameContext:getScoreSystem()) or GScoreSystem
	if GGameContext and GGameContext:isReplayActive() then
		local snapshot=GGameContext:updateReplay(dt)
		if snapshot then
			self:applySnapshot(snapshot)
		end
		if GGameContext:isReplayActive() then
			return
		end
	end
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
			local hint=getHint()
			if hint then
				print(hint)
				local hintCost=1
				if GGameContext then
					local config=GGameContext:getConfig()
					hintCost=config and config.hintCost or hintCost
					GGameContext:incrementMetric('hints',1)
				end
				if score then score:recordHint(hintCost) end
			end
		elseif keyPressed=='r' then
			if GGameContext then GGameContext:startReplay() end
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
					if GGameContext then GGameContext:pushSnapshot(self:snapshot()) end
					playCardPlaceSound()
					self.pile[i].top:move(self.waste)
					self.waste:push(self.pile[i].top)
					table.insert(self.waste.undodata,self.pile[i])
					if score then score:recordMove('pile') end
					if GGameContext then GGameContext:incrementMetric('moves',1) end
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
