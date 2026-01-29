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
    self.stateName = nil
    self.config = {
        hintCost = 1,
        replayInterval = 0.4,
        maxSnapshots = 200
    }
    self.debugFlags = {
        enabled = false
    }
    self.metrics = {
        moves = 0,
        hints = 0,
        deckDraws = 0,
        startedAt = os.time(),
        endedAt = nil
    }
    self.snapshots = {}
    self.replayIndex = 0
    self.replayTimer = 0
    self.replayActive = false
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

function GameContext:setStateName(stateName)
    self.stateName = stateName
end

function GameContext:getStateName()
    return self.stateName
end

function GameContext:setConfig(config)
    self.config = config or self.config
end

function GameContext:getConfig()
    return self.config
end

function GameContext:updateConfig(key, value)
    self.config[key] = value
end

function GameContext:setDebugFlag(key, value)
    self.debugFlags[key] = value
end

function GameContext:getDebugFlag(key)
    return self.debugFlags[key]
end

function GameContext:resetMetrics()
    self.metrics = {
        moves = 0,
        hints = 0,
        deckDraws = 0,
        startedAt = os.time(),
        endedAt = nil
    }
end

function GameContext:incrementMetric(key, value)
    self.metrics[key] = (self.metrics[key] or 0) + (value or 1)
end

function GameContext:getMetrics()
    return self.metrics
end

function GameContext:pushSnapshot(snapshot)
    if not snapshot then return end
    table.insert(self.snapshots, snapshot)
    local maxSnapshots = self.config.maxSnapshots or 200
    while #self.snapshots > maxSnapshots do
        table.remove(self.snapshots, 1)
    end
end

function GameContext:clearSnapshots()
    self.snapshots = {}
    self.replayIndex = 0
    self.replayTimer = 0
    self.replayActive = false
end

function GameContext:startReplay()
    if #self.snapshots == 0 then return end
    self.replayActive = true
    self.replayIndex = 1
    self.replayTimer = 0
end

function GameContext:stopReplay()
    self.replayActive = false
end

function GameContext:isReplayActive()
    return self.replayActive
end

function GameContext:updateReplay(dt)
    if not self.replayActive then return nil end
    self.replayTimer = self.replayTimer + dt
    local interval = self.config.replayInterval or 0.4
    if self.replayTimer < interval then return nil end
    self.replayTimer = 0
    local snapshot = self.snapshots[self.replayIndex]
    self.replayIndex = self.replayIndex + 1
    if self.replayIndex > #self.snapshots then
        self.replayActive = false
    end
    return snapshot
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
