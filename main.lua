require 'src/dependencies'

function love.update(dt)
	love.mouse.x,love.mouse.y=love.mouse.getPosition()
	gStateMachine:update(dt)
	if GInput then GInput:clearFrame() end
	love.keyboard.lastKeyPressed=nil
	love.mouse.lastClick=nil
end

function love.draw() gStateMachine:render() end

-- function love.resize(w,h) push:resize(w,h) end

function love.keypressed(key)
	if key=='escape' then love.event.quit() end
	if GInput then GInput:setKeyPressed(key) end
	love.keyboard.lastKeyPressed=key	
end

function love.mousepressed(x,y,btn)
	if GInput then GInput:setMousePressed(x,y,btn) end
	love.mouse.lastClick=btn
	gStateMachine:mousePressed(x,y,btn)
end
