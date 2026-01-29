local function assertEqual(expected, actual, message)
	if expected ~= actual then
		error((message or "assert")..": expected "..tostring(expected).." got "..tostring(actual))
	end
end

package.path = package.path .. ";./?.lua;./?/init.lua;./?/?.lua"

if not love then love = {} end
love.filesystem = love.filesystem or {}
love.filesystem.getInfo = love.filesystem.getInfo or function() return nil end
love.filesystem.read = love.filesystem.read or function() return nil end
love.filesystem.write = love.filesystem.write or function() return true end

local RuleSystem = require "src.systems.RuleSystem"
local ScoreSystem = require "src.systems.ScoreSystem"

local rules = RuleSystem.new()
local waste = { top = { value = 6 } }
local card = { value = 5 }
assertEqual(true, rules:checkLockWaste(card, waste), "checkLockWaste adjacent")
waste.top.value = 13
card.value = 1
assertEqual(true, rules:checkLockWaste(card, waste), "checkLockWaste wrap down")
waste.top.value = 1
card.value = 13
assertEqual(true, rules:checkLockWaste(card, waste), "checkLockWaste wrap up")
waste.top.value = 7
card.value = 5
assertEqual(false, rules:checkLockWaste(card, waste), "checkLockWaste invalid")

local board = { deck = { cards = { 1 } }, pile = {}, waste = { top = { value = 1 } } }
assertEqual(false, rules:isGameOver(board), "isGameOver deck not empty")

board.deck.cards = {}
board.pile = {
	{ top = { value = 2 } },
	{ top = { value = 9 } },
	{ top = nil },
	{ top = nil },
	{ top = nil },
	{ top = nil },
	{ top = nil }
}
board.waste.top.value = 3
assertEqual(false, rules:isGameOver(board), "isGameOver move available")

board.waste.top.value = 7
assertEqual(true, rules:isGameOver(board), "isGameOver no moves")

local score = ScoreSystem.new()
score:reset()
score:setRemainingCards(0)
assertEqual(35, score:getScore(), "score base")
score:recordMove("pile")
score:recordMove("pile")
assertEqual(36, score:getScore(), "score combo")
score:recordMove("deck")
assertEqual(35, score:getScore(), "score deck")
score:recordHint(2)
assertEqual(33, score:getScore(), "score hint penalty")

print("tests passed")
