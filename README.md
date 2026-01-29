# Golf Solitaire

Golf Solitaire em 2D feito com LÖVE (Love2D), com dicas, IA simples para sugerir movimentos e suporte a undo/redo.

## Screenshots

![Screenshot 1](screenshots/1.png)
![Screenshot 2](screenshots/2.png)
![Screenshot 3](screenshots/3.png)

## Como jogar

- Mova cartas do tableau para a waste usando valores adjacentes.
- Compre cartas do deck quando não houver jogadas disponíveis.
- O objetivo é limpar todas as pilhas e maximizar a pontuação.

## Controles

- Mouse — selecionar, arrastar e soltar cartas
- H — dica de jogada
- A — ativa IA para sugerir jogadas
- Ctrl + Z — desfaz o último movimento
- Ctrl + Y — refaz o movimento desfeito
- M — alterna música
- E — alterna modo endless
- Esc — sair do jogo

## Tecnologias usadas

- Lua
- LÖVE (Love2D)
- Bibliotecas em lib/: class, autocursor, lovecc, itable

## Como rodar localmente

Pré-requisitos: LÖVE (Love2D) instalado.

```bash
git clone <url-do-repositorio>
cd golf-master
love .
```

No Windows, se o love não estiver no PATH:

```powershell
& "C:\Program Files\LOVE\love.exe" .
```

## Copyright

© 2026 Jonathan (@xjhowx). All rights reserved.
