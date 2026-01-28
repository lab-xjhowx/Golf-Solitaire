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
require 'src.systems.ScoreSystem'
require 'src.systems.RuleSystem'
require 'src.systems.InputSystem'
require 'src.systems.AnimationSystem'
require 'src.GameContext'

-- protótipo de pilha (Stack)
require 'src.Stack'


-- importa os protótipos dos objetos do jogo
require 'src.objects.Card'
require 'src.objects.DraggingCard'

gMusic=love.audio.newSource('assets/audio/music.mp3','stream')
gMusic:setLooping(true)
gMusic:play()
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
