# 🃏 Golf Solitaire – Jogo com IA em LÖVE2D

### 🧑‍💻 Autor
- **Jonathan – @xjhowx**
- GitHub: https://github.com/lab-xjhowx
- LinkedIn: https://www.linkedin.com/in/xjhowx

Implementação de Golf Solitaire em 2D usando LÖVE (Love2D), com recursos de dica, IA simples para sugerir movimentos e suporte a undo/redo.

---

## 🎯 Objetivo do Projeto

- **Qual problema o projeto resolve**  
  Fornece um jogo completo de Golf Solitaire para desktop, com lógica de jogo implementada e suporte a experimentos simples de inteligência artificial em cima das regras do jogo.

- **Em que contexto deve ser usado**  
  - Estudo de jogos 2D com LÖVE e Lua.  
  - Exploração de heurísticas e backtracking aplicados a um jogo de cartas.  
  - Uso pessoal como jogo de paciência (solitaire) no computador.

- **Quando não faz sentido utilizá-lo**  
  - Quando se busca um motor genérico de jogos de cartas.  
  - Quando é necessário um produto comercial pronto, com distribuição formal, instalador, suporte online ou multiplayer.  
  - Quando o alvo é web/mobile sem adaptação do código.

---

## 🧠 Visão Geral

### Explicação simples (não técnica)

Jogo de paciência do tipo Golf Solitaire em que o jogador tenta mover todas as cartas da mesa para a pilha de descarte, seguindo regras de valor adjacente.  
O tabuleiro é exibido em 2D, há interação por mouse e atalhos de teclado para pedir dicas, deixar a IA sugerir jogadas e desfazer/refazer movimentos.

### Explicação técnica

- **Componentes principais**
  - `main.lua`: ponto de entrada do jogo, integra com a API do LÖVE (`love.update`, `love.draw`, `love.keypressed`, `love.mousepressed`).
  - `src/dependencies.lua`: carrega bibliotecas (`lib/*`), constantes, recursos, lógica e configura a máquina de estados global `gStateMachine`.
  - Máquina de estados (`src/StateMachine.lua`, `src/State.lua`, `src/states/*.lua`): organiza telas como menu principal, jogo e prompts.
  - Objetos de jogo (`src/objects/*.lua`): implementação de carta (`Card`), baralho (`Deck`), pilha (`Pile`), descarte (`Waste`), carta em arraste (`DraggingCard`) e tabuleiro (`GameBoard`).
  - Lógica de regras e IA (`src/logic.lua`): geração do baralho, regras de movimentação, cálculo de score, detecção de fim de jogo, dicas (`getHint`) e decisões automáticas (`makeDecision`, `makeSmartDecision`).

- **Como se conectam**
  - `main.lua` delega atualização e renderização para `gStateMachine`.
  - `src/dependencies.lua` cria `gStateMachine` com os estados `main-menu`, `play` e `prompt`, e entra inicialmente em `main-menu`.
  - O estado `PlayState` instancia o `GameBoard`, que contém `Deck`, `Pile`, `Waste` e controla a interação com as cartas.
  - A lógica de jogo em `logic.lua` é utilizada pelos objetos e pelo `GameBoard` para validar movimentos, finalizar partidas e fornecer dicas/IA.

- **Fluxo básico de execução**
  1. LÖVE inicia e executa `main.lua`.
  2. `main.lua` carrega `src/dependencies.lua`, que por sua vez carrega bibliotecas, recursos, objetos, estados e configura `gStateMachine`.
  3. O jogo entra no estado de menu principal; ao iniciar uma partida, muda para `PlayState`.
  4. Em cada frame, `love.update(dt)` chama `gStateMachine:update(dt)`, que atualiza o estado atual (`GameBoard` no caso do jogo).
  5. `love.draw()` chama `gStateMachine:render()`, que desenha o tabuleiro, cartas e UI.
  6. Entradas de teclado e mouse são encaminhadas à máquina de estados, que as repassa ao estado ativo (menu, jogo ou prompt).

---

## 🧱 Estrutura do Projeto

### Raiz do repositório

- `main.lua`  
  Ponto de entrada do jogo em LÖVE. Atualiza e desenha o estado atual via `gStateMachine` e encaminha eventos de teclado e mouse.

- `README.md`  
  Documentação oficial do projeto (este arquivo).

- `README.md automático.md`, `análise consciente de projetos.md`, `kit_profissional_de_analise_de_repositorios.md`  
  Documentos auxiliares de análise e templates de documentação. Não participam diretamente da execução do jogo.

- `assets/`  
  Recursos visuais e sonoros do jogo.
  - `assets/audio/`  
    Arquivos de som e música (`music.mp3`, `cardSlide*.ogg`, `buzz.wav`, etc.).
  - `assets/fonts/`  
    Fontes utilizadas na renderização de textos.
  - `assets/images/`  
    Imagens do fundo, sprites de cartas, cursor e demais elementos visuais.
  - `assets/CREDITS`  
    Créditos dos recursos utilizados.

- `lib/`  
  Bibliotecas auxiliares em Lua.
  - `lib/class.lua`  
    Implementação simples de sistema de classes.
  - `lib/autocursor.lua`  
    Lógica relacionada ao cursor automático.
  - `lib/itable.lua`  
    Utilitários para manipulação de tabelas.
  - `lib/lovecc/`  
    Utilidades visuais, incluindo `Palette/default.lua` e inicialização (`init.lua`).

- `src/`  
  Código-fonte principal do jogo.
  - `src/constants.lua`  
    Constantes globais do jogo (como dimensões de carta, layout e outros valores fixos).
  - `src/resources.lua`  
    Carregamento e organização de imagens, fontes e sons.
  - `src/util.lua`  
    Funções utilitárias, incluindo geração de quads/sprites das cartas.
  - `src/custom.lua`  
    Funções de desenho e comportamentos gráficos específicos.
  - `src/logic.lua`  
    Lógica de regras do Golf Solitaire, validação de movimentos, cálculo de score, detecção de fim de jogo, dicas e IA.
  - `src/dependencies.lua`  
    Arquivo responsável por carregar todas as dependências (lib, constantes, recursos, objetos, estados), iniciar a música e configurar `gStateMachine`.
  - `src/Stack.lua`  
    Implementação de uma pilha genérica utilizada por estruturas do jogo.

  - `src/objects/`  
    Implementações orientadas a objeto dos elementos do jogo.
    - `Card.lua` – representação de uma carta individual (naipe, valor, posição e renderização).
    - `Deck.lua` – baralho de compra.
    - `Pile.lua` – pilhas de cartas do tableau.
    - `Waste.lua` – pilha de descarte, central para as regras de Golf.
    - `DraggingCard.lua` – representação da carta que está sendo arrastada via mouse.
    - `GameBoard.lua` – composição de deck, piles, waste, gerenciamento de atualização e desenho do tabuleiro.

  - `src/states/`  
    Sistema de estados do jogo.
    - `State.lua` – classe base de um estado.
    - `StateMachine.lua` – máquina de estados responsável por troca e delegação.
    - `MainMenuState.lua` – estado de menu principal.
    - `PlayState.lua` – estado onde o jogo acontece; cria `gCards` e `GameBoard` ao entrar.
    - `states/PromptState/`  
      - `main.lua`, `util.lua`, `custom.lua` – lógica e componentes para prompts (por exemplo, mensagens de “fim de jogo / deseja reiniciar?”).

- `screenshots/`  
  Imagens de tela do jogo usadas para documentação e visualização rápida.

Atualmente o projeto não possui pastas dedicadas a `backend/`, `frontend/` web ou `infra/` separada.

---

## ⚙️ Tecnologias Utilizadas

- **Linguagem**
  - Lua

- **Framework**
  - LÖVE (Love2D)

- **Bibliotecas principais (diretório `lib/`)**
  - `class.lua` – sistema de classes simples.
  - `autocursor.lua` – controle de cursor.
  - `lovecc` – utilidades para cores/elementos visuais.
  - `itable.lua` – extensões e utilidades para tabelas.

- **Outras ferramentas**
  - Assets de áudio, fontes e imagens em `assets/`.

Atualmente o projeto não utiliza Node, Python, Docker ou outros frameworks web/backend.

---

## ▶️ Como Executar o Projeto

### Pré-requisitos

- **LÖVE (Love2D)** instalado na máquina.  
  A versão mínima não está documentada no repositório, mas o projeto segue o padrão das versões estáveis mais comuns do LÖVE.
- Sistema operacional compatível com LÖVE (Windows, macOS ou Linux).

Atualmente o projeto não possui `package.json`, `requirements.txt`, Dockerfile ou scripts de build externos.

### Passos para execução

```bash
# clonar o repositório
git clone <url-do-repositorio>
cd golf-master

# executar o jogo com LÖVE
love .
```

Também é possível arrastar a pasta `golf-master` diretamente para o executável do LÖVE, dependendo do sistema operacional.

---

## 🕹️ Controles do Jogo

- `H` – exibe uma dica de jogada.
- `A` – aciona a IA para ajudar com as jogadas possíveis.
- `Ctrl + Z` – desfaz (undo) o último movimento.
- `Ctrl + Y` – refaz (redo) o movimento desfeito.
- Mouse – interação com as cartas e regiões do tabuleiro.

---

## 🔄 Fluxo Principal da Aplicação

- A aplicação inicia em `main.lua`, que carrega `src/dependencies.lua`.
- `src/dependencies.lua` carrega bibliotecas, constantes, recursos, objetos e estados, inicia a música de fundo e configura `gStateMachine`.
- O estado inicial é o menu principal (`MainMenuState`). Ao iniciar uma partida, o jogo troca para `PlayState`.
- `PlayState` inicializa o baralho (`gCards = initCards()`) e cria o `GameBoard`, que passa a controlar deck, piles e waste.
- Em cada frame, `love.update(dt)` chama `gStateMachine:update(dt)` e `love.draw()` chama `gStateMachine:render()`.
- Eventos de teclado e mouse são tratados em `main.lua` e encaminhados para o estado atual, que decide como reagir (seleção de cartas, arraste, prompts, etc.).

As regras de negócio (validação de jogadas, score, fim de jogo, dicas e IA) estão concentradas em `src/logic.lua` e nos objetos em `src/objects/`.

---

## 🧪 Qualidade, Estado Atual e Limitações

- **Testes automatizados**  
  Atualmente o projeto não possui testes automatizados nem pasta de testes dedicada.

- **Lint e padrões**  
  Não há configuração de linter (como Luacheck) incluída no repositório.

- **Nível de maturidade**  
  - Estável para uso pessoal e estudo.
  - Adequado como base de aprendizado de LÖVE e lógica de jogos de cartas.

- **Limitações conhecidas**  
  - Dependência do LÖVE instalado localmente, sem suporte web/mobile nativo.
  - Ausência de testes automatizados torna refatorações mais arriscadas.
  - O algoritmo de IA é propositalmente simples e não garante sempre o score máximo possível.
  - Não há sistema de distribuição empacotado (instaladores, builds prontos por plataforma).

Atualmente o projeto não possui arquivo de licença (`LICENSE`), o que limita o uso formal em contextos comerciais ou redistribuição.

---

## 🚀 Possíveis Evoluções

- **Melhorias técnicas**
  - Adicionar suíte de testes automatizados para funções de `src/logic.lua` (validação de jogadas, score, fim de jogo e IA).
  - Isolar e documentar melhor as heurísticas de IA, permitindo ajustes de dificuldade.
  - Incluir configuração de linter (por exemplo, Luacheck) e guia de estilo para contribuições.

- **Experiência do jogador**
  - Opções de configuração de áudio (ligar/desligar música e efeitos).
  - Indicadores visuais mais claros para dicas e jogadas sugeridas pela IA.
  - Estatísticas básicas: partidas jogadas, média de score, melhor score.

- **Distribuição**
  - Scripts para empacotar o jogo em executáveis específicos para Windows, macOS e Linux.

---

## 👥 Público-Alvo

- Desenvolvedores que desejam aprender:
  - LÖVE (Love2D) e jogos 2D em Lua.
  - Modelagem de jogos de cartas e regras de negócio relacionadas.
  - Implementação de heurísticas simples de IA e backtracking.

- Pessoas que querem um jogo de Golf Solitaire single-player para uso pessoal em desktop.

Atualmente o projeto não é direcionado como produto comercial pronto, mas pode servir como base para experimentos e protótipos.

---

## 📌 Status do Projeto

- **Manutenção ativa**  
  O repositório não define explicitamente política de manutenção contínua.

- **Contribuições**  
  Não há `CONTRIBUTING.md` ou guia formal de contribuição. Sugestões e melhorias podem ser discutidas via issues e pull requests no GitHub.

- **Licença**  
  Atualmente o projeto não possui arquivo de licença declarado.

---

## 📝 Conclusão

Golf Solitaire – Jogo com IA em LÖVE2D entrega um jogo de paciência completo, com regras de Golf Solitaire, suporte a dicas, IA simples e undo/redo, rodando em cima da stack Lua + LÖVE.  
Serve tanto como jogo casual em desktop quanto como base de estudo para lógica de jogos de cartas, design de estados e heurísticas de IA em um contexto acessível.
