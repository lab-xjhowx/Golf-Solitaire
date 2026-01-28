-- recursos (aqui temos duas imagens e dois conjuntos de quads)
gImg=love.graphics.newImage("assets/images/spritesheet.png")
gBackground=love.graphics.newImage("assets/images/back.jpg")
-- inicializados em util.lua
gSprCard,gSprPattern=nil

gSounds={}

for i=1,8 do
	gSounds[i]=love.audio.newSource("assets/audio/cardSlide"..i..".ogg","static")
end

gSounds[9]=love.audio.newSource("assets/audio/buzz.wav","static")

gFonts={
	['large']=love.graphics.newFont("assets/fonts/ostrich-sans-black.ttf",35)
}



function playSound(sfx_id)
	gSounds[sfx_id]:stop()
	gSounds[sfx_id]:play()
end

-- quando você desliza cartas do deck para o estoque
function playCardSlideSound()
	playSound(4)
end

-- quando você solta uma carta arrastada em uma nova posição
function playCardPlaceSound()
	playSound(1)
end

-- quando não há mais redistribuições disponíveis
function playBuzzSound()
	playSound(9)
end

-- quando você desfaz ou refaz um movimento
function playURSound()
	playSound(3)
end