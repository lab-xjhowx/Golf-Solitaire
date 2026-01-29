MainMenuState=State()

function MainMenuState:enter()
	self.timer=0
	
	-- fonte para texto de corpo
	self.orbitonFont=love.graphics.newFont("assets/fonts/arial.ttf",16)
	-- fonte para títulos e chamadas
	self.arialFont=love.graphics.newFont("assets/fonts/Orbitron Medium.otf",28)
	self.titleFont=love.graphics.newFont("assets/fonts/Orbitron Medium.otf",42)
	self.uiFont=love.graphics.newFont("assets/fonts/arial.ttf",16)
	self.backImage=love.graphics.newImage('assets/images/mainBackground.png')
	self.boxW=560
	self.boxH=340
	self.boxX=(1280-self.boxW)/2
	self.boxY=VIRTUAL_HEIGHT*0.22
	self.headerY=190
	self.headerH=50
	self.playButton={x=(1280-260)/2,y=self.boxY+self.boxH-50,width=260,height=40}
	self.musicButton={x=1280-62,y=18,width=44,height=32}
	self.infoScroll=0
end

function MainMenuState:update(dt)
	self.timer=self.timer+dt
	if self.timer>1 then self.timer=0 end
	local mx,my=love.mouse.x,love.mouse.y
	self.playHovered=mx>=self.playButton.x and mx<=self.playButton.x+self.playButton.width and my>=self.playButton.y and my<=self.playButton.y+self.playButton.height
	self.musicHovered=mx>=self.musicButton.x and mx<=self.musicButton.x+self.musicButton.width and my>=self.musicButton.y and my<=self.musicButton.y+self.musicButton.height
end

function MainMenuState:render()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(self.backImage)
	self:renderOtherStuff()
end

function MainMenuState:mousePressed(_,_,btn)
	if btn==1 then
		if self.playHovered then
			gStateMachine:switch('play')
		elseif self.musicHovered then
			toggleMusic()
		end
	end
end

function MainMenuState:wheelMoved(_,dy)
	if not (self.infoVisibleHeight and self.infoTextHeight) then return end
	if self.infoTextHeight<=self.infoVisibleHeight then return end
	local mx,my=love.mouse.x,love.mouse.y
	local inBox=mx>=self.boxX and mx<=self.boxX+self.boxW and my>=self.boxY and my<=self.boxY+self.boxH
	if inBox then
		self.infoScroll=self.infoScroll-dy*24
	end
end

local function drawShadowedText(text,x,y,width,align,shadowOffset,shadowAlpha,mainAlpha)
	local r,g,b,a=love.graphics.getColor()
	love.graphics.setColor(0,0,0,shadowAlpha)
	love.graphics.printf(text,x+shadowOffset,y+shadowOffset,width,align)
	love.graphics.setColor(r,g,b,mainAlpha or a)
	love.graphics.printf(text,x,y,width,align)
end

local function drawWrappedShadowed(text,x,y,width,lineHeight)
	local font=love.graphics.getFont()
	local _,lines=font:getWrap(text,width)
	for i=1,#lines do
		local ly=y+(i-1)*lineHeight
		love.graphics.setColor(0,0,0,0.7)
		love.graphics.print(lines[i],x+1,ly+1)
		love.graphics.setColor(1,1,1,1)
		love.graphics.print(lines[i],x,ly)
	end
end

local function drawMusicIcon(x,y,size,muted)
	local s=size
	love.graphics.setLineWidth(2)
	love.graphics.rectangle('fill',x,y+s*0.35,s*0.18,s*0.3)
	love.graphics.polygon('fill',
		x+s*0.18,y+s*0.25,
		x+s*0.48,y+s*0.1,
		x+s*0.48,y+s*0.9,
		x+s*0.18,y+s*0.75
	)
	if muted then
		love.graphics.setLineWidth(2)
		love.graphics.line(x+s*0.62,y+s*0.25,x+s*0.92,y+s*0.75)
		love.graphics.line(x+s*0.92,y+s*0.25,x+s*0.62,y+s*0.75)
	else
		love.graphics.setLineWidth(2)
		love.graphics.arc('line',x+s*0.58,y+s*0.5,s*0.32,-0.6,0.6)
		love.graphics.arc('line',x+s*0.62,y+s*0.5,s*0.44,-0.6,0.6)
	end
	love.graphics.setLineWidth(1)
end

function MainMenuState:renderOtherStuff()
	-- título principal
	love.graphics.setFont(self.titleFont)
	love.graphics.setColor(0,0,0)

	-- caixa de objetivos
	local infoText="O objetivo principal do jogo é mover todas as cartas para a pilha de descarte (o lixo), utilizando apenas as cartas disponíveis no tableau.\n\nRegras de movimentação:\nApenas Damas podem ser colocadas sobre Ases.\nNenhuma carta pode ser jogada sobre um Rei.\n\nPontuação e fluxo do jogo:\nAs cartas são compradas uma a uma do estoque para a pilha de descarte.\nNão há redistribuições (reinícios do baralho).\nCada carta movida do tableau para a pilha de descarte vale um ponto.\nTente chegar o mais perto possível de 35 pontos!\n\nComandos rápidos:\nVocê pode desfazer/refazer jogadas com Ctrl-Z / Ctrl-Y.\nPressione H para obter uma dica.\nPressione A para que a IA ajude nas jogadas."
	local padding=16
	local buttonGap=16
	local buttonArea=60
	love.graphics.setFont(self.orbitonFont)
	local lineHeight=self.orbitonFont:getHeight()*1.25
	local _,lines=self.orbitonFont:getWrap(infoText,self.boxW-32)
	local textHeight=#lines*lineHeight
	self.boxH=math.min(textHeight+padding+buttonGap+buttonArea,400)
	self.headerY=self.boxY-self.headerH
	self.playButton.y=self.boxY+self.boxH-50
	love.graphics.setColor(0,0,0,0.68)
	love.graphics.rectangle("fill",self.boxX,self.boxY,self.boxW,self.boxH,10,10)
	love.graphics.setColor(1,1,1,0.06)
	love.graphics.rectangle("fill",self.boxX+6,self.boxY+6,self.boxW-12,self.boxH-12,8,8)
	love.graphics.setColor(0.06,0.06,0.06,0.75)
	love.graphics.rectangle("fill",self.boxX,self.headerY,self.boxW,self.headerH,10,10)
	love.graphics.setColor(1,1,1,0.7)
	love.graphics.rectangle("line",self.boxX,self.boxY,self.boxW,self.boxH,10,10)
	love.graphics.rectangle('line',self.boxX, self.headerY, self.boxW,self.headerH,10,10)

	love.graphics.setFont(self.arialFont)
	love.graphics.setColor(0.95,0.88,0.5,1)
	drawShadowedText("SOBRE O JOGO:",self.boxX,self.headerY+13,self.boxW,'center',1,0.6,1)
	love.graphics.setFont(self.orbitonFont)
	love.graphics.setColor(1,1,1,1)
	local visibleTextHeight=self.boxH-padding-buttonGap-buttonArea
	local maxScroll=math.max(0,textHeight-visibleTextHeight)
	self.infoScroll=math.max(0,math.min(self.infoScroll,maxScroll))
	self.infoTextHeight=textHeight
	self.infoVisibleHeight=visibleTextHeight
	if textHeight>visibleTextHeight then
		love.graphics.setScissor(self.boxX+16,self.boxY+16,self.boxW-32,visibleTextHeight)
	end
	drawWrappedShadowed(infoText,self.boxX+16,self.boxY+16-self.infoScroll,self.boxW-32,lineHeight)
	if textHeight>visibleTextHeight then
		love.graphics.setScissor()
		love.graphics.setColor(0.5,0.5,0.5,0.7)
		love.graphics.rectangle("fill",self.boxX+self.boxW-10,self.boxY+16,6,visibleTextHeight,3,3)
		local scrollbarHeight=math.max(24,(visibleTextHeight*visibleTextHeight)/textHeight)
		local scrollbarY=self.boxY+16
		if maxScroll>0 then
			scrollbarY=self.boxY+16+(self.infoScroll/maxScroll)*(visibleTextHeight-scrollbarHeight)
		end
		love.graphics.setColor(0.85,0.85,0.85,0.9)
		love.graphics.rectangle("fill",self.boxX+self.boxW-10,scrollbarY,6,scrollbarHeight,3,3)
	end

	-- call-to-action visual na parte inferior
	local ctaX,ctaY,ctaWidth,ctaHeight=self.playButton.x,self.playButton.y,self.playButton.width,self.playButton.height
	if self.playHovered then
		love.graphics.setColor(0.1,0.7,0.1,0.95)
	else
		love.graphics.setColor(0.1,0.5,0.1,0.9)
	end
	love.graphics.rectangle('fill',ctaX,ctaY,ctaWidth,ctaHeight,10,10)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle('line',ctaX,ctaY,ctaWidth,ctaHeight,10,10)
	love.graphics.setFont(self.arialFont)
	love.graphics.printf("JOGAR AGORA",ctaX,ctaY+8,ctaWidth,'center')
	love.graphics.setFont(self.uiFont)
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
	love.graphics.setFont(self.uiFont)
	local creditText="© 2026 Jonathan (@xjhowx) | All rights reserved."
	local creditW=self.uiFont:getWidth(creditText)+16
	love.graphics.setColor(0,0,0,0.55)
	love.graphics.rectangle('fill',12,682,creditW,24,8,8)
	love.graphics.setColor(1,1,1,0.7)
	love.graphics.rectangle('line',12,682,creditW,24,8,8)
	love.graphics.setColor(1,1,1,0.9)
	drawShadowedText(creditText,20,686,creditW-16,'left',1,0.7,0.9)
end

function MainMenuState:exit()
	self.backImage:release()
	self.orbitonFont:release()
	self.arialFont:release()
	self.titleFont:release()
	self.uiFont:release()
end
