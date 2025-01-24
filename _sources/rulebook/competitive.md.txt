# Competitive mode

```{hint}
Before playing in competitive mode, it’s a good idea to have played in collaborative mode first.
Review the previous sections to learn the basics of the game.
```

Prepare the game as explained on {ref}`rulebook:setup`.
Each player **chooses a color**, takes the **RAM** card of that color and sets all the positions of their RAM module to
zero.
Distribute the **energy** units to each player according to the game’s desired difficulty:

- Easy: 4
- Normal: 3
- Difficult: 2.5
- Master: 2

Shuffle the **goal cards** and place them face-down to the right of the CPU.
Each player takes a goal card from the deck, looks at it (without showing it to the other players) and places it
**face-down** next to their RAM module.

```{image} ../_static/rulebook/competitive_setup.png
:align: center
```

In each turn, each player may play as many operation cards as allowed by their energy units.

```{hint}
A player is not required to use all their energy units.
```

```{important}
Energy units **cannot be transferred** from one player to another.
```

```{important}
Any player can modify the values of any of the bits in the 4 registers of the CPU in their turn, but will **not** be
able to **copy or modify** the values stored in the **RAM** of other players.
```

If a player manages to store their goal in **register `A`** of the CPU during their turn, the player will **show** their
goal card to the rest of the players, keep it next to their RAM module and take another goal card from the deck.

```{image} ../_static/rulebook/competitive_show.png
:align: center
```

Once the deck of goal cards deck is exhausted, the player who has solved the most goal cards will be the **winner**!

In competitive mode, there are two additional **changes** with respect to the cooperative mode:

1. The `MOV` operation requires **1/2 energy** unit (instead of 1 energy unit).

2. Bug cards are used **to view another player’s goal card** at any time during the game.
  When a player takes this card from the deck, they show it to the other players and saves it for later use.
  The bug card can only be used during the player’s turn and, when used, the player who was forced to show their goal
  card **will take possession** of the bug card, which they can then use during one of their turns.
  These cards **do not count** as a solved goal to decide the winner at the end of the game.

## Hackers

You can also make each player have **special** features in the competitive games.
Look at the back of the RAM cards to see which hacker you want to be:

- **Green**: you can use `INC` or `DEC` by consuming only 1 energy unit.
- **Yellow**: you can use `ROL` or `ROR` consuming only 1/2 energy units.
- **Purple**: you can make two `MOV` operations without consuming energy on each turn.
- **Red**: you can do two logic operations `OR`, `AND`, `XOR` without consuming energy on each turn.
