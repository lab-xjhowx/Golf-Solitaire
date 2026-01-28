# Roadmap de Evolução – Golf Solitaire (Love2D)

> Plano de implementação baseado na **Auditoria Técnica e Propostas de Evolução**.
> Use este arquivo para acompanhar o que já foi feito e o que ainda falta.

---

## Fase 1 – Polimento e Portfólio (Curto Prazo)

Foco: deixar o projeto apresentável como portfólio, sem grandes mudanças de arquitetura.

### 1.1 Documentação
- [x] README.md em PT-BR, claro e profissional
- [x] NOTAS_PTBR.md explicando libs externas e estrutura interna
- [x] `docs/ARQUITETURA.md` detalhando a arquitetura do jogo
- [x] `docs/REGRAS_DO_JOGO.md` descrevendo claramente as regras da variação de Golf
- [x] Documento de auditoria técnica (`auditoria_tecnica_golf_solitaire_love_2_d.md`)
- [x] Linkar a auditoria técnica no README.md

### 1.2 UX / UI Básica
- [x] Melhorar o menu principal (título mais destacado e call-to-action visual)
- [x] Destacar visualmente cartas jogáveis (ex.: borda, glow ou cor de fundo diferenciada)
- [x] Pequena animação ao mover carta para o waste (slide/flip simples)

### 1.3 Organização Interna
- [x] Padronizar comentários para PT-BR nos arquivos principais (`src/*.lua`, `main.lua`)
- [x] Verificar e ajustar nomes de pastas/arquivos nos diagramas da doc (ex.: `graphics/` vs `images/`)

---

## Fase 2 – Arquitetura e Systems (Médio Prazo)

Foco: tornar o código mais modular, testável e pronto para crescer.

### 2.1 Camada `systems/`
- [x] Criar pasta `src/systems/`
- [x] Implementar `ScoreSystem` para centralizar cálculo e estado de pontuação
- [x] Implementar `RuleSystem` para concentrar regras de movimento e fim de jogo
- [x] (Opcional) Implementar `InputSystem` para unificar tratamento de entrada
- [x] (Opcional) Implementar `AnimationSystem` para centralizar animações

### 2.2 GameContext
- [x] Definir uma estrutura `GameContext` (ex.: tabela Lua global controlada)
- [x] Mover referências globais soltas (como `gameBoard`, `gCards`, etc.) para dentro de `GameContext`
- [x] Adaptar `PlayState`, `GameBoard` e `logic.lua` para usarem `GameContext`

---

## Fase 3 – Novas Mecânicas e Modos de Jogo (Médio Prazo)

Foco: agregar valor de gameplay.

- [x] Implementar **Modo Endless**
- [x] Implementar sistema de pontuação avançado (combos, bônus por sequência, penalidades)
- [x] Criar rankings locais (persistência em arquivo simples)
- [x] Adicionar suporte a **seeds reproduzíveis** para o baralho
- [ ] Implementar dificuldade progressiva (ajuste de layout, número de cartas, etc.)

---

## Fase 4 – Qualidade Profissional (Médio / Longo Prazo)

Foco: práticas de engenharia de software.

- [ ] Adicionar testes unitários para regras principais
  - [ ] Testar `checkLockWaste`
  - [ ] Testar `isGameOver` em cenários simples
  - [ ] Testar cálculo de score final
- [ ] Configurar linting para Lua (ex.: `luacheck`)
- [ ] Configurar CI simples no GitHub Actions para rodar lint e testes
- [ ] Criar scripts para empacotar o jogo em versão desktop (Windows, e opcionalmente macOS/Linux)

---

## Fase 5 – IA Avançada e Analytics (Longo Prazo)

Foco: inteligência artificial e análise de gameplay.

### 5.1 IA
- [ ] Melhorar `makeSmartDecision` com memoização e limitação de profundidade
- [ ] Criar sistema de avaliação de estados (heurística de "boa jogada")
- [ ] Tornar o sistema de hints mais inteligente e explicativo

### 5.2 Analytics de Gameplay
- [ ] Registrar estatísticas básicas de partidas (tempo, número de movimentos, score)
- [ ] Exportar logs simples para análise manual
- [ ] (Opcional) Pensar em integração futura com serviços de analytics

---

## Fase 6 – Publicação e Portfólio

Foco: transformar o projeto em peça forte de apresentação.

- [ ] Gravar vídeo curto de gameplay (mostrando menu, jogadas, IA, dicas, undo/redo)
- [ ] Atualizar descrição do repositório no GitHub com texto em PT-BR profissional
- [ ] Garantir que README tenha:
  - [x] Descrição clara
  - [x] Como executar
  - [x] Controles
  - [x] Status do projeto
  - [ ] Link para auditoria técnica e outros docs importantes
- [ ] Publicar uma build jogável (Itch.io, por exemplo) ou disponibilizar `.love`/executável na aba Releases

---

## Como Usar Este Roadmap

- Use as caixas `[ ]` / `[x]` para marcar o que já foi feito.
- Ao finalizar um bloco de tarefas, considere atualizar também a **auditoria técnica** para refletir o novo estado do projeto.
- Você pode adaptar este arquivo ao longo do tempo – ele é um guia vivo, não algo rígido.
