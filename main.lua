require 'src/dependencies'

SCALE_X=1
SCALE_Y=1

local function updateScale(w,h)
	SCALE_X=w/VIRTUAL_WIDTH
	SCALE_Y=h/VIRTUAL_HEIGHT
end

updateScale(love.graphics.getWidth(),love.graphics.getHeight())

function love.update(dt)
	local mx,my=love.mouse.getPosition()
	love.mouse.x,love.mouse.y=mx/SCALE_X,my/SCALE_Y
	gStateMachine:update(dt)
	if GInput then GInput:clearFrame() end
	love.keyboard.lastKeyPressed=nil
	love.mouse.lastClick=nil
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(SCALE_X,SCALE_Y)
	gStateMachine:render()
	love.graphics.pop()
end

function love.resize(w,h)
	updateScale(w,h)
end

function love.keypressed(key)
	if key=='escape' then love.event.quit() end
	if GInput then GInput:setKeyPressed(key) end
	love.keyboard.lastKeyPressed=key	
end

function love.mousepressed(x,y,btn)
	local vx,vy=x/SCALE_X,y/SCALE_Y
	if GInput then GInput:setMousePressed(vx,vy,btn) end
	love.mouse.lastClick=btn
	gStateMachine:mousePressed(vx,vy,btn)
end
