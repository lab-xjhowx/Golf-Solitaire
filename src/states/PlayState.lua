PlayState=State()

function PlayState:enter()
	--this cards is going to be global but its shortlived (only use is in init functions) and not constant
	local score=(GGameContext and GGameContext:getScoreSystem()) or GScoreSystem
	if score then score:reset() end
	if GGameContext then
		GGameContext:setStateName('play')
		GGameContext:resetMetrics()
		GGameContext:clearSnapshots()
	end
	local seedOverride = GGameContext and GGameContext:getSeedOverride()
	initSeed(seedOverride)
	if GGameContext and seedOverride ~= nil then
		GGameContext:setSeedOverride(nil)
	end
	gCards=initCards()
	GGameContext:setCards(gCards)
	gameBoard=GameBoard()
	GGameContext:setBoard(gameBoard)
	if GGameContext then GGameContext:pushSnapshot(gameBoard:snapshot()) end
end

function PlayState:update(dt)
	local board=GGameContext:getBoard() or gameBoard
	if board then board:update(dt) end
end

function PlayState:render()
	local board=GGameContext:getBoard() or gameBoard
	if board then board:render() end
end
