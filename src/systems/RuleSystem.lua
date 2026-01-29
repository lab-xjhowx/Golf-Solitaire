RuleSystem = {}

local RuleSystem_mt = { __index = RuleSystem }

function RuleSystem.new()
    local self = setmetatable({}, RuleSystem_mt)
    return self
end

function RuleSystem:checkLockWaste(card, waste)
    if not waste.top then return false end
    local cv = card.value
    local wv = waste.top.value
    local up = (cv + 1 > 13) and 1 or (cv + 1)
    local down = (cv - 1 < 1) and 13 or (cv - 1)
    return (wv == up) or (wv == down)
end

function RuleSystem:isGameOver(board)
    if #board.deck.cards > 0 then return false end
    for i = 1, 7 do
        local pile = board.pile[i]
        if pile and pile.top and self:checkLockWaste(pile.top, board.waste) then
            return false
        end
    end
    return true
end
return RuleSystem
