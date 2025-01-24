# Difficulty

You can adapt the difficulty of the game in several ways:

## Energy

Changing the number of **energy** units available per round.
We suggest you use 3 units of energy (easy) for the first games and then reduce it progressively:

- Normal: 2.5
- Hard: 2
- Master: 1.5

## Bugs

Changing the number of “**bug**” cards the goal cards deck will have:

- Easy: 0
- Normal: 1
- Hard: 2
- Master: 3

## Initial state

Changing the **initial state** of the registers:

- Easy:

  - Take the first 3 goal cards of the deck at the start of the game, and copy their values into registers
    `B`, `C` and `D` (these three cards can then be considered solved).
  - Set register `A` to zero.

- Normal:

  - Do the same with the first 2 goal cards and registers `B` and `C`.
  - Set registers `A` and `D` to zero.

- Hard:
  - Copy the first goal card to register `B`.
  - Set registers `A`, `C` and `D` to zero.

- Master:
  - Set register `A` to value 1.
  - Set the rest of registers to zero.

## Events

Adding **event** cards to the goal cards deck.
See {ref}`events`.
