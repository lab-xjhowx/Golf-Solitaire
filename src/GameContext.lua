GameContext = {}

local GameContext_mt = { __index = GameContext }

function GameContext.new()
    local self = setmetatable({}, GameContext_mt)
    self.board = nil
    self.cards = nil
    self.endlessMode = false
    self.seed = nil
    self.seedOverride = nil
    return self
end

function GameContext:setBoard(board)
    self.board = board
end

function GameContext:getBoard()
    return self.board
end

function GameContext:setCards(cards)
    self.cards = cards
end

function GameContext:getCards()
    return self.cards
end

function GameContext:setEndlessMode(enabled)
    self.endlessMode = not not enabled
end

function GameContext:isEndlessMode()
    return self.endlessMode
end

function GameContext:toggleEndlessMode()
    self.endlessMode = not self.endlessMode
    return self.endlessMode
end

function GameContext:setSeed(seed)
    self.seed = seed
end

function GameContext:getSeed()
    return self.seed
end

function GameContext:setSeedOverride(seed)
    self.seedOverride = seed
end

function GameContext:getSeedOverride()
    return self.seedOverride
end

GGameContext = GameContext.new()
