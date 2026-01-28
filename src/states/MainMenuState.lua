MainMenuState=State()

function MainMenuState:enter()
	self.timer=0
	
	-- fonte para texto de corpo
	self.orbitonFont=love.graphics.newFont("assets/fonts/arial.ttf",20)
	-- fonte para títulos e chamadas
	self.arialFont=love.graphics.newFont("assets/fonts/Orbitron Medium.otf",28)
	self.titleFont=love.graphics.newFont("assets/fonts/Orbitron Medium.otf",42)
	self.backImage=love.graphics.newImage('assets/images/mainBackground.png')
end

function MainMenuState:update(dt)
	self.timer=self.timer+dt
	if self.timer>1 then self.timer=0 end
end

function MainMenuState:render()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(self.backImage)
	self:renderOtherStuff()
end

function MainMenuState:mousePressed(_,_,btn)
	if btn==1 then gStateMachine:switch('play') end
end

function MainMenuState:renderOtherStuff()
	-- título principal
	love.graphics.setFont(self.titleFont)
	love.graphics.setColor(0,0,0)
	love.graphics.printf("Golf Solitaire",0,80,1280,'center')

	-- caixa de objetivos
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line",40,330,482,242)
	love.graphics.rectangle('line',40, 280, 482,50)

	love.graphics.setFont(self.arialFont)
	love.graphics.printf("Objetivos do jogo:",42,293,482,'center')
	love.graphics.setFont(self.orbitonFont)
	love.graphics.printf("O objetivo principal do jogo é mover todas as cartas para a pilha de descarte (waste), usando apenas as cartas disponíveis no tableau. Apenas doses podem ser colocadas sobre ases e nenhuma carta pode ser jogada sobre um rei. As cartas são compradas uma a uma do estoque para a waste. Não há redistribuições. Cada carta movida do tableau para a waste vale um ponto. Tente chegar o mais perto possível de 35 pontos! Você pode desfazer/refazer com Ctrl-Z/Ctrl-Y. Pressione H para dica e A para a IA ajudar nas jogadas.",42,340,478,'justify')

	-- call-to-action visual na parte inferior
	local ctaY=640
	local ctaWidth=360
	local ctaHeight=40
	local ctaX=(1280-ctaWidth)/2

	if self.timer>.3 and self.timer<1 then
		love.graphics.setColor(0.1,0.6,0.1,0.9)
	else
		love.graphics.setColor(0.1,0.4,0.1,0.8)
	end
	love.graphics.rectangle('fill',ctaX,ctaY,ctaWidth,ctaHeight,8,8)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle('line',ctaX,ctaY,ctaWidth,ctaHeight,8,8)
	love.graphics.setFont(self.arialFont)
	love.graphics.printf("Clique em qualquer lugar para começar",ctaX,ctaY+8,ctaWidth,'center')
	love.graphics.setColor(0.7,0.7,0.7)    
	love.graphics.print("(C) Copyright Okra Softmakers",12,690)
end

function MainMenuState:exit()
	self.backImage:release()
	self.orbitonFont:release()
	self.arialFont:release()
	self.titleFont:release()
end