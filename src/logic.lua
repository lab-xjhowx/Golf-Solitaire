-- algumas funções importantes relacionadas às cartas

function initCards()
	local cards={}
	for i=1,4 do
		cards[i]={}
		for j=1,13 do
			cards[i][j]=Card(i,j)
		end
	end
	return cards
end

function initSeed(seed)
	if seed == nil then
		seed = os.time()
	end
	math.randomseed(seed)
	if GGameContext then
		GGameContext:setSeed(seed)
	end
	return seed
end

local function getCardsRef()
	return (GGameContext and GGameContext:getCards()) or gCards
end

local function getBoardRef()
	return (GGameContext and GGameContext:getBoard()) or gameBoard
end

function getRandomCard()
	local cards=getCardsRef()
	local s=math.random(#cards)
    local v=math.random(#cards[s])
	local card=cards[s][v]
	table.remove(cards[s],v)
	if #cards[s]==0 then
		table.remove(cards,s)
	end
    return card
end

function getRandomCards(n,back,x,y,stepox,stepoy)
	-- obtém n cartas aleatórias com x e y fixos
	local cards={}
	for i=1,n do
		cards[i]=getRandomCard()
		cards[i].x=x
		x=x+(stepox and stepox or 0)				
		cards[i].y=y
		y=y+(stepoy and stepoy or 0)		
		cards[i].back=back
	end
	return cards
end
function getCardValue(value)
	if value==13 then return "Ace"
	elseif value==1 then return "King"
	elseif value==2 then return "Queen"
	elseif value==3 then return "Jack"
	else return 14-value
	end
end

function getCardSuit(suit)
	if suit==1 then return "Hearts"
	elseif suit==2 then return "Spades"
	elseif suit==3 then return "Diamonds"
	else return "Clubs"
	end
end

function getCardInfo(card)
	return getCardValue(card.value).." of "..getCardSuit(card.suit)
end

function aabbcollision(src,src_width,src_height,targetx,targety,target_width,target_height)
	if src.x+src_width<targetx or src.x>targetx+target_width or src.y+src_height<targety or src.y>targety+target_height then
		return false
	end
	return true
end

function dragCard(card)
	-- função responsável por arrastar a carta com o mouse
	if not card then return end
	card.x,card.y=love.mouse.getPosition()
	card.x=card.x-CARD_WIDTH/2
	card.y=card.y-CARD_HEIGHT/2
end

function regionClicked(x,y)
	-- só considera clique na região se você NÃO estiver arrastando uma carta, estiver clicando com o botão esquerdo e o mouse estiver sobre a região
	return cardIsHovered(x,y) and love.mouse.isDown(1) and not gDragCard
end

function dragOnClicking(region,x,y)
	if region.top and regionClicked(x or region,y) and not region.top.back  then
		gDragCard=DraggingCard(region.top)
		region:pop()
		gDragCard.parent=region
	end
end

function cardIsHovered(x,y)
	if y==nil then x,y=x.x,x.y end
	if love.mouse.x>x and love.mouse.x<x+CARD_WIDTH then
		if love.mouse.y>y and love.mouse.y<y+CARD_HEIGHT then
			return true
		end
	end
	return false
end

function cardInRegion(card,region)
	return aabbcollision(card,CARD_WIDTH,CARD_HEIGHT,region.x,region.y,CARD_WIDTH,CARD_HEIGHT)
end

function lockToRegion(card,region)
	-- se uma carta estiver em uma região "ativa", trava a carta nessa região	
	if cardInRegion(card,region) then
		card:move(region)
		return true
	else
		return false
	end
end

function gameOver(background)
	local board=getBoardRef()
	local remaining=0
	for i=1,#board.pile do
		for j=1,#board.pile[i].cards do
			remaining=remaining+1
		end
	end
	GScoreSystem:setRemainingCards(remaining)
	local score=GScoreSystem:getScore()
	GScoreSystem:addRanking(score)
	if GGameContext and GGameContext:isEndlessMode() then
		gStateMachine:switch('play')
		return
	end
	gStateMachine:switch('prompt',{
		background=background,
		msg=("Your Score: %d!\n\nDo you want to restart?"):format(score),
		width=400,height=150,
		onYesClick=function() gStateMachine:switch('play') end,
		onNoClick=function() gStateMachine:switch('main-menu') end
	})
end

 
gMoves={}
notg=0

function getHint()
	local board=getBoardRef()
	for _,pile in ipairs(board.pile) do
		if GRules:checkLockWaste(pile.top,board.waste) then
			return("Mova o "..getCardInfo(pile.top).." para o "..getCardInfo(board.waste.top))
		end
	end
	return "Compre outra carta"
end

recursionspace=""

function makeDecision(waste,deck,piles,move)
	local pile_found=false
	for i,pile in ipairs(piles) do
		if #pile.cards>0 and waste.cards[#waste.cards] and ((waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value+1>13 and 1 or pile.cards[#pile.cards].value+1)) or (waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value-1<1 and 13 or pile.cards[#pile.cards].value-1)))  then
			pile_found=true
			-- print("Move "..getCardInfo(pile.cards[#pile.cards]).." to waste")			
			table.insert(move,{toX=pile.cards[#pile.cards].x+CARD_WIDTH/2,toY=pile.cards[#pile.cards].y+CARD_HEIGHT/2,clickOnDest=2})
			-- table.insert(move,{toX=waste.cards[#waste.cards].x+CARD_WIDTH/2,toY=waste.cards[#waste.cards].y+CARD_HEIGHT/2,clickOnDest=2})
			table.insert(waste.cards,pile.cards[#pile.cards])
			table.remove(pile.cards)
			makeDecision(waste,deck,piles,move)
			break
		end
	end
	if #deck.cards>0 and not pile_found then
		-- print("Redeal "..getCardInfo(deck.cards[#deck.cards]))
		table.insert(move,{toX=deck.cards[#deck.cards].x+CARD_WIDTH/2,toY=deck.cards[#deck.cards].y+CARD_HEIGHT/2,clickOnDest=1})
		table.insert(waste.cards,deck.cards[#deck.cards])
		table.remove(deck.cards)
		makeDecision(waste,deck,piles,move)		
	end
end

-- decisão inteligente: olha para todas as combinações [PRECISA DE MEMOIZAÇÃO E OUTRAS MUDANÇAS]
-- cada combinação será adicionada à tabela de movimentos (move)
-- se uma combinação levar a um score > 30, ela será adicionada à tabela Best_moves
-- depois a melhor combinação será escolhida de Best_moves e usada em AI_MOVES
function makeSmartDecision(waste,deck,piles,move)
	local pile_found=false
	for i,pile in ipairs(piles) do
		if #pile.cards<=0 then print("PILE CARDS IS EQUAL TO ZERO") goto continue end
		if waste.cards[#waste.cards] and ((waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value+1>13 and 1 or pile.cards[#pile.cards].value+1)) or (waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value-1<1 and 13 or pile.cards[#pile.cards].value-1)))  then
			pile_found=true
			print(recursionspace.."Move "..getCardInfo(pile.cards[#pile.cards]).." to waste")
			table.insert(waste.cards,pile.cards[#pile.cards])
			table.remove(pile.cards)
			recursionspace=recursionspace.." "
			makeSmartDecision(waste,deck,piles,move)
			recursionspace=recursionspace:sub(1,recursionspace:len()-1)
			table.insert(pile.cards,waste.cards[#waste.cards])
			table.remove(waste.cards)
			print(recursionspace.."BACKTRACKING MOVE:  "..getCardInfo(pile.cards[#pile.cards]))				
		end
		::continue::
	end
	
	print(recursionspace.."PILE_FOUND: "..tostring(pile_found))

	if #deck.cards<=0 then return end
	
	if #deck.cards>0 and not pile_found then
		print(recursionspace.."Redeal "..getCardInfo(deck.cards[#deck.cards]))
		table.insert(waste.cards,deck.cards[#deck.cards])
		table.remove(deck.cards)
		makeSmartDecision(waste,deck,piles,move)
		table.insert(deck.cards,waste.cards[#waste.cards])
		table.remove(waste.cards)
		print(recursionspace.."BACKTRACKING REDEAL:  "..getCardInfo(deck.cards[#deck.cards]))
	end
end
