# Cooperative mode

Prepare the game as explained on {ref}`rulebook:setup`.
For the first game, we recommend to use 3 energy units per round and not to use `OR`, `AND`, and `XOR` operations.
Later, you can adjust the difficulty of the game to your level.

To win the game, you must help the astronauts fulfill their mission by **solving** all the goal cards.
Each goal cards shows a **combination of bits**.
To solve the goal card, you must store that combination of bits in register `A` of the CPU.

At the beginning of the game, flip the first three goal cards and copy them in registers `B`, `C` and `D`.
Once they are properly placed, discard these 3 goal cards.

Then, flip the top card in the stack of goal cards, and place it face-up next to the stack.

In each round, you can perform as many operations as you wish depending on the **energy** units available.

```{hint}
Remember that there are operations such as `OR` that require 1/2 energy units, while others like `INC` require 2 energy
units.
```

```{important}
You are not required to spend all energy units in one round, but you **cannot save** energy for the next round.
```

Use your energy units to perform **operations** on registers `A`, `B`, `C` and `D` of the CPU and achieve the goal.
Remember that a goal card will not be solved until its value is stored in **register `A`** of the CPU.

Whether you have resolved the goal card or not, at the end of the round, you have to **move** the unsolved goal cards up
one position, **take** the top card in the stack of goal cards, and place it face-down next to the stack:

```{image} ../_static/rulebook/cooperative_move.png
:align: center
```

This is when you will recover all the energy you had at the beginning of the round.

If a goal card advances to **5th position** at the end of the round, you are a slow CPU, the game is over and the lunar
mission failed.

```{image} ../_static/rulebook/cooperative_over.png
:align: center
```

```{important}
This can happen even if there are no goal cards left in the stack but it takes you more than **5 rounds** to solve the
last goal cards.
```

In other words, at the end of the round the goal cards move up regardless the number of cards left in the stack.

On the other hand, if you manage to solve all the goals of the stack promptly, astronauts will be able to land into the
moon safely and you **win**!

Moreover, there are goal cards that don’t have a combination of bits but a **bug**.

These special cards **cannot be discarded** and they will block one of the positions of the list of pending goals for
the rest of the game.

```{image} ../_static/rulebook/cooperative_bug.png
:align: center
```

During the game, you will need to modify the bits of the CPU registers to reach a goal specified in a goal card.
You will do this by using certain CPU {ref}`rulebook:operations`.
