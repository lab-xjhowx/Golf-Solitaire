# Arquitetura Técnica do Jogo Golf Solitaire

Este documento descreve a arquitetura interna do jogo, para quem quer entender como o código está organizado e como o fluxo funciona por baixo dos panos.

## Visão Geral

- O jogo é escrito em **Lua** usando o framework **LÖVE (Love2D)**.
- O fluxo principal é controlado por uma **máquina de estados** (`StateMachine`).
- A lógica de regras do jogo e IA fica principalmente em `src/logic.lua`.
- A renderização e interação com o jogador são realizadas pelos objetos em `src/objects/` e pelos estados em `src/states/`.

## Fluxo Principal

1. **`main.lua`**
   - É o ponto de entrada do LÖVE.
   - Carrega `src/dependencies.lua`.
   - Implementa as funções principais do LÖVE:
     - `love.update(dt)`: atualiza `gStateMachine`.
     - `love.draw()`: chama `gStateMachine:render()`.
     - `love.keypressed(key)`: repassa teclas para a lógica global.
     - `love.mousepressed(x, y, btn)`: repassa cliques para a máquina de estados.

2. **`src/dependencies.lua`**
   - Importa bibliotecas de `lib/` (`class`, `autocursor`, `lovecc`, `itable`).
   - Importa constantes, recursos, utilitários e lógica (`constants`, `resources`, `util`, `custom`, `logic`, `Stack`).
   - Importa todos os objetos (`Card`, `Deck`, `Pile`, `Waste`, `DraggingCard`, `GameBoard`).
   - Importa estados (`State`, `StateMachine`, `MainMenuState`, `PlayState`, `PromptState`).
   - Cria a máquina de estados global `gStateMachine` e entra inicialmente em `main-menu`.

3. **Máquina de Estados (`src/State.lua`, `src/StateMachine.lua`)**
   - `State` define a interface base (`enter`, `exit`, `update`, `render`, etc.).
   - `StateMachine` mantém um dicionário de estados possíveis e um estado atual.
   - Permite trocar de tela chamando `gStateMachine:switch("nome-do-estado")`.

4. **Estados Concretos (`src/states/`)**

   - **`MainMenuState`**
     - Desenha o fundo de menu.
     - Mostra texto com os objetivos do jogo e instruções básicas.
     - Ao clicar com o mouse, muda para o estado `PlayState`.

   - **`PlayState`**
     - Ao entrar, cria o baralho (`gCards = initCards()`) e o `GameBoard`.
     - No `update`, chama `gameBoard:update(dt)`.
     - No `render`, chama `gameBoard:render()`.

   - **`PromptState`**
     - Mostra uma janela de confirmação (por exemplo, fim de jogo e pergunta se deseja reiniciar).
     - Renderiza o tabuleiro por baixo e a janela por cima.
     - Possui botões "Sim" / "Não" e botão de fechar.

## Objetos de Jogo (`src/objects/`)

- **`Card`**
  - Representa uma carta individual (naipe, valor, posição, verso).
  - Sabe se desenhar a partir do spritesheet.

- **`Deck`**
  - Representa o baralho de onde novas cartas são compradas.
  - Mantém a pilha de cartas restantes.

- **`Pile`**
  - Representa cada pilha do tableau (as colunas de cartas na mesa).

- **`Waste`**
  - Pilha de descarte, onde as cartas devem ser empilhadas segundo as regras.

- **`DraggingCard`**
  - Representa a carta que está sendo arrastada pelo mouse.
  - Guarda a referência do "pai" (de onde veio) para poder aplicar o movimento.

- **`GameBoard`**
  - Junta `Deck`, `Pile` (7 pilhas) e `Waste` em um único tabuleiro.
  - Controla o modo de IA (`aiMode`) e os movimentos automáticos.
  - No `update`:
    - Processa as teclas `A` (IA) e `H` (dica).
    - Atualiza deck, waste e pilhas.
    - Aplica movimentos quando há carta sendo arrastada.
    - Verifica se o jogo acabou (`isGameOver`) e, se sim, chama `gameOver`.
  - No `render`:
    - Desenha o fundo, deck, waste, pilhas e, se existir, a carta sendo arrastada.

## Lógica de Jogo e IA (`src/logic.lua`)

- **Criação e sorteio de cartas**
  - `initCards()`: cria a matriz de cartas por naipe e valor.
  - `getRandomCard()`: sorteia uma carta e remove do conjunto disponível.
  - `getRandomCards(...)`: monta conjuntos de cartas com posições iniciais.

- **Informações de cartas**
  - `getCardValue(value)`: converte valor numérico para nome (Rei, Dama, Valete, etc.).
  - `getCardSuit(suit)`: converte o naipe em texto (Copas, Espadas, Ouros, Paus).
  - `getCardInfo(card)`: junta valor + naipe em uma string amigável.

- **Interação e regiões**
  - `aabbcollision(...)`: checagem de colisão retangular.
  - `cardIsHovered(...)`: verifica se o mouse está sobre uma carta.
  - `cardInRegion(card, region)`: testa se a carta está dentro de uma região alvo.
  - `lockToRegion(card, region)`: move a carta para uma região se estiver dentro da área "ativa".

- **Regras para descarte (waste)**
  - `checkLockWaste(card, waste)`: verifica se uma carta pode ser jogada no descarte, considerando a regra de valor adjacente (variação de Golf).
  - `isGameOver()`: checa se ainda há movimentos possíveis ou cartas no deck.
  - `gameOver(background)`: calcula o score final e abre o `PromptState` oferecendo reinício ou volta ao menu.

- **Dicas e IA**
  - `getHint()`: procura uma jogada válida nas pilhas e retorna uma mensagem de texto com a sugestão. Se não houver, recomenda comprar outra carta.
  - `makeDecision(waste, deck, piles, move)`: monta uma sequência de movimentos que a IA pode executar, explorando recursivamente as opções.
  - `makeSmartDecision(...)`: versão mais avançada que faz backtracking para explorar combinações de jogadas e avaliar sequências melhores (marcada como área para futuras melhorias).

## Recursos e Desenho (`resources.lua`, `custom.lua`)

- **`resources.lua`**
  - Carrega o spritesheet de cartas e o fundo.
  - Carrega efeitos sonoros de deslizar carta, colocar carta, buzzer e undo/redo.
  - Define funções utilitárias para tocar sons específicos (`playCardSlideSound`, `playCardPlaceSound`, etc.).

- **`custom.lua`**
  - Desenha o fundo verde da mesa.
  - Desenha as "caixas" onde cartas podem ficar (deck, waste, piles).
  - Funções `drawCard` e `drawBack` encapsulam o desenho das cartas e dos versos usando os quads do spritesheet.

## Estados de Tela em Alto Nível

- **Menu Principal**
  - Explica o objetivo do jogo.
  - Mostra controles principais (H para dica, A para IA, Ctrl+Z/Ctrl+Y para undo/redo).
  - Um clique inicia a partida.

- **Partida (PlayState)**
  - Exibe o tabuleiro (deck, piles, waste).
  - Permite arrastar cartas, comprar novas cartas e usar IA/dicas.

- **Prompt de Fim de Jogo / Confirmação**
  - Sobrepõe uma janela de confirmação ao tabuleiro.
  - Pergunta se o jogador quer reiniciar ou voltar ao menu.

---

Este documento é complementar ao `README.md` e ao `NOTAS_PTBR.md`.  
Use-o quando quiser entender melhor como as partes internas do código se conectam.
