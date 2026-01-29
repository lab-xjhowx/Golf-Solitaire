GameContext = {}

local GameContext_mt = { __index = GameContext }

function GameContext.new()
    local self = setmetatable({}, GameContext_mt)
    self.board = nil
    self.cards = nil
    self.scoreSystem = nil
    self.ruleSystem = nil
    self.inputSystem = nil
    self.animationSystem = nil
    self.music = nil
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

function GameContext:setScoreSystem(scoreSystem)
    self.scoreSystem = scoreSystem
end

function GameContext:getScoreSystem()
    return self.scoreSystem
end

function GameContext:setRuleSystem(ruleSystem)
    self.ruleSystem = ruleSystem
end

function GameContext:getRuleSystem()
    return self.ruleSystem
end

function GameContext:setInputSystem(inputSystem)
    self.inputSystem = inputSystem
end

function GameContext:getInputSystem()
    return self.inputSystem
end

function GameContext:setAnimationSystem(animationSystem)
    self.animationSystem = animationSystem
end

function GameContext:getAnimationSystem()
    return self.animationSystem
end

function GameContext:setMusic(music)
    self.music = music
end

function GameContext:getMusic()
    return self.music
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
return GameContext
