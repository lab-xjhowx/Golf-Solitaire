GameBoard=Class{}
local dragging=true

a=love.graphics.newFont(100)
love.graphics.setFont(a)

function GameBoard:init()
	self.aiMode=false
	self.deck=Deck()
	self.pile={}

	for i=1,7 do
		self.pile[i]=Pile(OFFSET_LEFT*i+(i-1)*(CARD_WIDTH+OFFSET_LEFT),OFFSET_GAP_VER+CARD_HEIGHT)
	end

	self.waste=Waste()

	--the dragging Card
	gDragCard=nil
end

function GameBoard:update(dt)
	if not GRules:isGameOver(self) then
		if GAnimation then GAnimation:update(dt) end
		local keyPressed=(GInput and GInput:getLastKey()) or love.keyboard.lastKeyPressed
		local lastClick=(GInput and GInput:getLastClick()) or love.mouse.lastClick
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
					GScoreSystem:recordMove('pile')
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
	for i=1,7 do
		local pile=self.pile[i]
		if pile.top then
			pile.top.highlight = GRules:checkLockWaste(pile.top,self.waste)
		end
		pile:render()
	end

	if gDragCard then gDragCard:render() end
	lovecc.setColor('black')
	lovecc.reset()
end

function fcursor.drag(x,y) end

function fcursor.click(x,y,btn)
	local board=GGameContext:getBoard() or gameBoard
	if btn==1 then board.deck.aiClicked=true end
	if GInput then
		GInput:setMousePressed(x,y,btn)
	else
		love.mouse.lastClick=btn
	end
end
