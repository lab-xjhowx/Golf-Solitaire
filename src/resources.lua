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

function getMusicRef()
	if GGameContext and GGameContext:getMusic() then
		return GGameContext:getMusic()
	end
	return gMusic
end

function toggleMusic()
	local music=getMusicRef()
	if not music then return end
	if music:isPlaying() then
		music:pause()
	else
		music:play()
	end
end

function drawMusicIcon(x,y,size,muted)
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
