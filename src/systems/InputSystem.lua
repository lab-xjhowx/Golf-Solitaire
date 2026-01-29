InputSystem = {}

local InputSystem_mt = { __index = InputSystem }

function InputSystem.new()
    local self = setmetatable({}, InputSystem_mt)
    self.lastKeyPressed = nil
    self.lastClick = nil
    return self
end

function InputSystem:setKeyPressed(key)
    self.lastKeyPressed = key
end

function InputSystem:setMousePressed(x, y, btn)
    self.lastClick = btn
end

function InputSystem:getLastKey()
    return self.lastKeyPressed
end

function InputSystem:getLastClick()
    return self.lastClick
end

function InputSystem:clearFrame()
    self.lastKeyPressed = nil
    self.lastClick = nil
end
return InputSystem
