-- importa as bibliotecas auxiliares
Class=require 'lib.class'
fcursor=require 'lib.autocursor'
lovecc=require 'lib.lovecc'
require 'lib.itable'

-- importa configurações globais (todas as constantes vão aqui)
require 'src.constants'

-- importa os recursos (imagens, fontes, sons)
require 'src.resources'

-- importa o mecanismo de geração de quads e inicializa CARDS, PATTERN
require 'src.util'


-- importa funções especiais de desenho
require 'src.custom'

-- importa as funções de lógica especial para abstrair ao máximo
require 'src.logic'

-- systems
local ScoreSystem=require 'src.systems.ScoreSystem'
local RuleSystem=require 'src.systems.RuleSystem'
local InputSystem=require 'src.systems.InputSystem'
local AnimationSystem=require 'src.systems.AnimationSystem'
require 'src.GameContext'

-- protótipo de pilha (Stack)
require 'src.Stack'


-- importa os protótipos dos objetos do jogo
require 'src.objects.Card'
require 'src.objects.DraggingCard'
if GGameContext then
	GGameContext:setScoreSystem(ScoreSystem.new())
	GGameContext:setRuleSystem(RuleSystem.new())
	GGameContext:setInputSystem(InputSystem.new())
	GGameContext:setAnimationSystem(AnimationSystem.new())
	local music=love.audio.newSource('assets/audio/music.mp3','stream')
	music:setLooping(true)
	music:play()
	GGameContext:setMusic(music)
end
require 'src.objects.Waste'
require 'src.objects.Deck'
require 'src.objects.Pile'
require 'src.objects.GameBoard'


require 'src.StateMachine'
require 'src.State'
require 'src.states.PlayState'
require 'src.states.MainMenuState'
require 'src.states.PromptState.main'
require 'src.states.PromptState.util'
require 'src.states.PromptState.custom'

gStateMachine=StateMachine{
	['main-menu']=function() return MainMenuState() end,
	['play']=function() return PlayState() end,
	['prompt']=function() return PromptState() end
}:switch('main-menu')
