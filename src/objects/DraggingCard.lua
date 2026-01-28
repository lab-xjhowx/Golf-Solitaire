DraggingCard=Class{__includes=Card}
local locked

function DraggingCard:update(dt)
	local board=GGameContext:getBoard() or gameBoard
	if love.mouse.isDown(1) then
		self:highlightWaste()
	else
		self:lockToWaste()
		if not locked then
			self:moveBack()
			self.parent:push(self:toCard())
		else
			table.insert(board.waste.undodata,self.parent)
		end
	end
	dragCard(self)
	locked=false
end

--convert DC to non-DC
function DraggingCard:toCard()
	return Card(self.suit,self.value,self.x,self.y)
end

--convert non-DC to DC
function DraggingCard:init(card)
	self.suit=card.suit
	self.value=card.value
	self:move(card)
end

function DraggingCard:moveBack()
	self:move(self.parent)
end


function DraggingCard:highlightWaste()
	local board=GGameContext:getBoard() or gameBoard
	board.waste.highlighted=self.parent~=board.waste and cardInRegion(self,board.waste) and GRules:checkLockWaste(self,board.waste)
end

function DraggingCard:lockToWaste()
	local board=GGameContext:getBoard() or gameBoard
	if GRules:checkLockWaste(self,board.waste) then
		locked=lockToRegion(self,board.waste)
		if locked then
			playCardPlaceSound()
			board.waste:push(self:toCard())
			GScoreSystem:recordMove('pile')
		end
	end
	board.waste.highlighted=false
end
--
--
