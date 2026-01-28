# NOTAS PT-BR – Bibliotecas e Estrutura Interna

Este arquivo explica, em português simples, alguns componentes internos usados pelo projeto.

## Bibliotecas externas em `lib/`

- **`lib/class.lua`**  
  Pequeno sistema de classes em Lua. Ele permite escrever código orientado a objetos de forma simples, usando `Class{}` para criar "classes" como `GameBoard`, `Card`, `Deck`, etc.

- **`lib/autocursor.lua` (fcursor)**  
  Biblioteca para controlar um cursor automático na tela.  
  No jogo, é usada quando o modo de IA (`aiMode`) está ativo, para mover o cursor e simular cliques de forma automática com base nas decisões calculadas.

- **`lib/lovecc`**  
  Conjunto de utilitários para trabalhar com cores e estilos no LÖVE.  
  Permite usar nomes de cores (como `"slateGrey"`, `"lime"`, `"black"`) em vez de ter que decorar valores RGB.  
  É usada principalmente para desenhar fundos, janelas e botões com cores consistentes.

- **`lib/itable.lua`**  
  Extensões para trabalhar com tabelas (arrays/dicionários) em Lua.  
  Inclui funções auxiliares como `table.copy` e outras operações sobre listas, usadas em pontos como a lógica de IA (`makeDecision`, `makeSmartDecision`).

> Observação: os cabeçalhos de licença e autoria dentro desses arquivos (`Author`, `GPLv3`, etc.) são do autor original das bibliotecas e foram mantidos exatamente como estão.

## Organização do código em `src/`

- **`src/dependencies.lua`**  
  Arquivo de "bootstrap". Carrega as bibliotecas (`lib/*`), constantes, recursos (imagens, sons, fontes), objetos (`Card`, `Deck`, `Pile`, etc.), estados (`MainMenuState`, `PlayState`, `PromptState`) e configura a máquina de estados global `gStateMachine`.

- **`src/resources.lua`**  
  Centraliza o carregamento de imagens, sons e fontes.  
  Também define funções utilitárias para tocar sons específicos, como deslizar cartas, soltar carta, buzzer de erro e sons de undo/redo.

- **`src/custom.lua`**  
  Funções de desenho específicas para este jogo: fundo verde da mesa, molduras das áreas onde as cartas ficam e desenho das cartas e de seus versos.

- **`src/logic.lua`**  
  Implementa as regras do Golf Solitaire e parte da lógica de IA:
  - criação e embaralhamento de cartas (`initCards`, `getRandomCard`, `getRandomCards`),
  - checagem de colisão e regiões, 
  - regras para saber se uma carta pode ir para o descarte (`checkLockWaste`),
  - cálculo de score e detecção de fim de jogo (`gameOver`, `isGameOver`),
  - geração de dicas (`getHint`),
  - simulação de jogadas para IA (`makeDecision`, `makeSmartDecision`).

- **`src/objects/*.lua`**  
  Cada arquivo representa um tipo de objeto do jogo:
  - `Card` (carta individual),
  - `Deck` (baralho de compra),
  - `Pile` (pilhas do tableau),
  - `Waste` (pilha de descarte),
  - `DraggingCard` (carta que está sendo arrastada pelo mouse),
  - `GameBoard` (tabuleiro que reúne deck, piles e waste e orquestra o jogo).

- **`src/states/*.lua`**  
  Implementam a máquina de estados e os estados concretos:
  - `State` e `StateMachine` são a base do sistema de estados,
  - `MainMenuState` é o menu inicial,
  - `PlayState` é o estado do jogo em andamento,
  - `states/PromptState/*` são arquivos que desenham e controlam a janela de prompt (por exemplo, confirmação de reinício).

## Resumo

Você pode pensar assim:
- A pasta `lib/` traz bibliotecas genéricas reutilizáveis (criadas por outros autores) para classes, cores, tabelas e cursor automático.
- A pasta `src/` contém o código específico deste jogo (regras, objetos, estados, recursos).
- O arquivo `main.lua` conecta tudo com o LÖVE (game loop, inputs) e delega o comportamento para `gStateMachine`.
