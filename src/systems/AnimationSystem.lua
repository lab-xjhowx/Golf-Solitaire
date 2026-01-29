AnimationSystem = {}

local AnimationSystem_mt = { __index = AnimationSystem }

function AnimationSystem.new()
    local self = setmetatable({}, AnimationSystem_mt)
    self.active = {}
    return self
end

function AnimationSystem:animateCard(card, endX, endY, duration)
    if not card then return end
    card.animating = true
    card.animTime = 0
    card.animDuration = duration or card.animDuration or 0.18
    card.animStartX, card.animStartY = card.x, card.y
    card.animEndX, card.animEndY = endX, endY
    self.active[card] = true
end

function AnimationSystem:update(dt)
    for card,_ in pairs(self.active) do
        card:update(dt)
        if not card.animating then
            self.active[card] = nil
        end
    end
end
return AnimationSystem
