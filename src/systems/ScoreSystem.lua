ScoreSystem = {}

local ScoreSystem_mt = { __index = ScoreSystem }

function ScoreSystem.new()
    local self = setmetatable({}, ScoreSystem_mt)
    self:reset()
    self:loadRankings()
    return self
end

function ScoreSystem:reset()
    -- score máximo possível em Golf: 35
    self.baseMaxScore = 35
    self.remainingCards = 0
    self.combo = 0
    self.comboBonus = 0
    self.deckDraws = 0
    self.hintPenalty = 0
    self.hintsUsed = 0
    self.history = {}
    self.redoHistory = {}
    self.rankings = self.rankings or {}
end

function ScoreSystem:setRemainingCards(n)
    self.remainingCards = math.max(n or 0, 0)
end

function ScoreSystem:getScore()
    local baseScore = self.baseMaxScore - self.remainingCards
    local total = baseScore + self.comboBonus - self.deckDraws - self.hintPenalty
    return math.max(total, 0)
end

function ScoreSystem:recordMove(moveType)
    if moveType ~= 'pile' and moveType ~= 'deck' then return end
    table.insert(self.history, moveType)
    self.redoHistory = {}
    self:recompute()
end

function ScoreSystem:undoMove()
    if #self.history == 0 then return end
    local last = self.history[#self.history]
    table.remove(self.history)
    table.insert(self.redoHistory, last)
    self:recompute()
end

function ScoreSystem:redoMove()
    if #self.redoHistory == 0 then return end
    local last = self.redoHistory[#self.redoHistory]
    table.remove(self.redoHistory)
    table.insert(self.history, last)
    self:recompute()
end

function ScoreSystem:recompute()
    self.combo = 0
    self.comboBonus = 0
    self.deckDraws = 0
    for _,moveType in ipairs(self.history) do
        if moveType == 'pile' then
            self.combo = self.combo + 1
            self.comboBonus = self.comboBonus + math.max(self.combo - 1, 0)
        elseif moveType == 'deck' then
            self.combo = 0
            self.deckDraws = self.deckDraws + 1
        end
    end
end

function ScoreSystem:recordHint(cost)
    local penalty = cost or 1
    self.hintPenalty = self.hintPenalty + penalty
    self.hintsUsed = self.hintsUsed + 1
end

function ScoreSystem:getRankings()
    return self.rankings
end

function ScoreSystem:addRanking(score)
    local entry = { score = score, time = os.time() }
    table.insert(self.rankings, entry)
    table.sort(self.rankings, function(a,b)
        if a.score == b.score then return a.time < b.time end
        return a.score > b.score
    end)
    while #self.rankings > 10 do
        table.remove(self.rankings)
    end
    self:saveRankings()
end

function ScoreSystem:loadRankings()
    self.rankings = self.rankings or {}
    if not love or not love.filesystem then return end
    if not love.filesystem.getInfo('rankings.dat') then return end
    local contents = love.filesystem.read('rankings.dat')
    if not contents or contents == '' then return end
    local list = {}
    for line in contents:gmatch('[^\n]+') do
        local s,t = line:match('^(%d+),(%d+)$')
        if s and t then
            table.insert(list, { score = tonumber(s), time = tonumber(t) })
        end
    end
    self.rankings = list
end

function ScoreSystem:saveRankings()
    if not love or not love.filesystem then return end
    local lines = {}
    for _,entry in ipairs(self.rankings) do
        lines[#lines+1] = tostring(entry.score)..','..tostring(entry.time)
    end
    love.filesystem.write('rankings.dat', table.concat(lines, '\n'))
end
return ScoreSystem
