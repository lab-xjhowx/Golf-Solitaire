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

Para detalhes técnicos da arquitetura interna, consulte:  
- [`docs/ARQUITETURA.md`](docs/ARQUITETURA.md)

Para entender as regras completas da variação de Golf Solitaire usada aqui:  
- [`docs/REGRAS_DO_JOGO.md`](docs/REGRAS_DO_JOGO.md)

---

## 🧱 Estrutura do Projeto (Resumo)

- `main.lua` – ponto de entrada do LÖVE.
- `src/` – código-fonte principal (objetos, estados, lógica, recursos).
- `lib/` – bibliotecas auxiliares em Lua (cores, classes, tabelas, cursor).
- `assets/` – imagens, fontes e sons.
- `screenshots/` – capturas de tela do jogo.

Para uma explicação detalhada da organização interna e das bibliotecas usadas, veja:  
- [`NOTAS_PTBR.md`](NOTAS_PTBR.md)

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
Resumo rápido:

- A aplicação inicia em `main.lua`, que carrega `src/dependencies.lua`.
- A máquina de estados (`gStateMachine`) controla qual tela está ativa (menu, jogo, prompt).
- O `PlayState` cria o `GameBoard`, que gerencia deck, piles e waste.
- Toda a lógica de jogadas, score, fim de jogo, dicas e IA está concentrada em `src/logic.lua` e nos objetos em `src/objects/`.

Detalhes completos de arquitetura:  
- [`docs/ARQUITETURA.md`](docs/ARQUITETURA.md)

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
