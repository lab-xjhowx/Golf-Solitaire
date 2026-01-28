PlayState=State()

function PlayState:enter()
	--this cards is going to be global but its shortlived (only use is in init functions) and not constant
	GScoreSystem:reset()
	local seedOverride = GGameContext and GGameContext:getSeedOverride()
	initSeed(seedOverride)
	if GGameContext and seedOverride ~= nil then
		GGameContext:setSeedOverride(nil)
	end
	gCards=initCards()
	gameBoard=GameBoard()
	GGameContext:setCards(gCards)
	GGameContext:setBoard(gameBoard)
end

function PlayState:update(dt)
	local board=GGameContext:getBoard() or gameBoard
	if board then board:update(dt) end
end

function PlayState:render()
	local board=GGameContext:getBoard() or gameBoard
	if board then board:render() end
end
