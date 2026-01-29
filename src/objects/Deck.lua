Deck=Class{__includes=Stack}

--we are setting a deckTimer because we don't want user to sort of click infinitely and lose all
--the redeal so effectively we will respond to clicks only once in every 0.2 seconds

local deckTimer=0

function Deck:init()
	self.x,self.y=OFFSET_LEFT,OFFSET_TOP
	self.cards=getRandomCards(52-35,true,OFFSET_LEFT,OFFSET_TOP)
	self:resetTop()
	self.redeal=2
end

function Deck:update(dt)
	deckTimer=deckTimer+dt	
	if deckTimer>0.2 and (regionClicked(self) or self.aiClicked)  then
		local board=GGameContext:getBoard() or gameBoard
		local animation=(GGameContext and GGameContext:getAnimationSystem()) or GAnimation
		local score=(GGameContext and GGameContext:getScoreSystem()) or GScoreSystem
		self.aiClicked=nil
		deckTimer=0
		if self.top then
			if GGameContext then GGameContext:pushSnapshot(board:snapshot()) end
			playCardSlideSound()
			if animation then
				animation:animateCard(self.top, board.waste.x, board.waste.y, self.top.animDuration)
			else
				self.top.animating=true
				self.top.animTime=0
				self.top.animStartX,self.top.animStartY=self.top.x,self.top.y
				self.top.animEndX,self.top.animEndY=board.waste.x,board.waste.y
			end
			-- ainda assim movemos logicamente a carta para o waste (posição será sobrescrita pela animação)
			self.top:move(board.waste)
			board.waste:pushFlip(self.top)
			table.insert(board.waste.undodata,self)
			if score then score:recordMove('deck') end
			if GGameContext then
				GGameContext:incrementMetric('deckDraws',1)
				GGameContext:incrementMetric('moves',1)
			end
			self:pop()
		else
			gameOver(board)
		end
	end
end

function Deck:render()
	for _,card in ipairs(self.cards) do
		card:render()
	end
end

function Deck:reStock()
	local board=GGameContext:getBoard() or gameBoard
	for i=#board.stock.cards,1,-1 do
		board.stock.cards[i]:move(self)
		self:pushFlip(board.stock.cards[i])
		board.waste:pop()
	end
end

--who said we only reset the top position in the function [THIS IS USEFUL FOR UNDO OPERATION]
function Deck:resetTopPosition()
	if not self.cards[#self.cards] then return end
	self.cards[#self.cards].back=true
end
