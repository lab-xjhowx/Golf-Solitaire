# Regras do Jogo – Golf Solitaire (Variação)

Este documento explica, em português claro, as regras do Golf Solitaire implementadas neste projeto e como o jogo funciona do ponto de vista do jogador.

## Objetivo Principal

- Mover **todas as cartas** do tableau (as colunas de cartas na mesa) para a pilha de descarte (**waste**).
- Cada carta movida para o waste vale **1 ponto**.
- O objetivo máximo é **35 pontos** (todas as cartas removidas do tableau).

## Componentes da Mesa

- **Deck (Estoque)**
  - Pilha de onde novas cartas são compradas.
  - Quando você compra uma carta, ela vai para o topo do waste.

- **Piles (Tableau)**
  - 7 colunas de cartas dispostas na mesa.
  - Você só pode mover a **carta do topo** de cada pilha.

- **Waste (Descarte)**
  - Pilha central onde as cartas devem ser empilhadas seguindo as regras de valor adjacente.

## Regras de Movimento

1. Você pode mover **somente a carta do topo** de uma pilha (`Pile`) para o topo do waste.
2. A carta que será movida precisa ser **adjacente em valor** à carta atual do topo do waste.
3. A variação usada aqui trata os valores de forma **circular**:
   - Depois de **Rei** pode vir **Ás**.
   - Depois de **Ás** pode vir **Rei**.
4. Na implementação atual, os valores são mapeados internamente para nomes como Rei, Dama, Valete, etc., mas a regra prática para o jogador é:
   - Você sempre pode jogar uma carta que esteja **+1 ou -1** em relação ao valor da carta na waste, considerando esse círculo Rei ↔ Ás.

### Exemplo de jogadas válidas

- Se o topo do waste é um **7**, você pode jogar um **6** ou um **8**.
- Se o topo do waste é um **Rei**, você pode jogar um **Ás**.
- Se o topo do waste é um **Ás**, você pode jogar um **Rei**.

### Quando NÃO é possível jogar

- Se não houver carta no topo de uma pilha que seja adjacente ao valor da carta no waste.
- Se você está tentando mover uma carta que **não está no topo** da pilha.

## Compra de Cartas

- Quando não há mais jogadas válidas a partir das pilhas, você pode **comprar uma nova carta do deck**.
- Essa carta vai para o topo do waste e passa a ser a nova referência para jogadas adjacentes.
- Quando o deck acaba, você não pode mais comprar cartas.

## Fim de Jogo

O jogo termina quando:

- Não há mais cartas no deck **e**
- Não existe nenhuma carta nas pilhas que possa ser movida para o waste de acordo com a regra de adjacência.

Quando isso acontece:

- O jogo calcula a pontuação: começa em **35** e subtrai **1 ponto para cada carta restante no tableau**.
- Abre-se uma janela perguntando se você deseja **reiniciar** ou voltar para o **menu principal**.

## Controles Importantes

- **H** – Mostra uma **dica** de jogada (por exemplo, "mova tal carta para o waste").
- **A** – Ativa o modo de **IA**, que simula e executa jogadas automaticamente com base em uma sequência calculada.
- **Ctrl + Z** – **Desfazer** o último movimento.
- **Ctrl + Y** – **Refazer** o movimento desfeito.
- **Clique do mouse** – Interage com cartas e regiões da mesa (arrastar soltar).

## Estratégia Básica

- Procure sempre movimentos que abram mais cartas escondidas nas pilhas.
- Use o deck com cuidado: quanto mais cedo você travar o jogo sem movimentos, menor será a pontuação final.
- Use a tecla **H** para entender melhor quais movimentos a lógica do jogo considera válidos.
- Use **A** quando quiser ver a IA tomando decisões por você.

---

Este documento complementa o `README.md` e ajuda a entender as regras específicas da variação de Golf implementada neste projeto.
