Card=Class{}
local locked

function Card:init(suit,value,x,y)
	self.suit=suit
	self.value=value
	self.back=x==nil
	if x==nil and suit>4 then x,y=suit,value end
	self.x,self.y=x or 0,y or 0
	self.highlight=false
	self.animating=false
	self.animTime=0
	self.animDuration=0.18
	self.animStartX,self.animStartY=nil,nil
	self.animEndX,self.animEndY=nil,nil
end

function Card:render()
	if self.back then
		drawBack(PATTERN_COLOR,PATTERN_VARIANT,self.x,self.y)
	else
		drawCard(self.suit,self.value,self.x,self.y)
		if self.highlight then
			-- desenha uma borda de destaque ao redor da carta jogável
			lovecc.setColor('lime',0.6)
			love.graphics.setLineWidth(3)
			love.graphics.rectangle('line',self.x-2,self.y-2,CARD_WIDTH+4,CARD_HEIGHT+4,6,6)
			love.graphics.setLineWidth(1)
			lovecc.reset()
		end
	end
end

function Card:update(dt)
	if self.animating and self.animStartX and self.animEndX then
		self.animTime=self.animTime+dt
		local t=math.min(self.animTime/self.animDuration,1)
		-- interpolação linear simples
		self.x=self.animStartX+(self.animEndX-self.animStartX)*t
		self.y=self.animStartY+(self.animEndY-self.animStartY)*t
		if t>=1 then
			self.animating=false
		end
	end
end

function Card:move(region)
	if not region then
		self.x,self.y=0,0
	else
		self.x,self.y=region.x,region.y
	end
end	

