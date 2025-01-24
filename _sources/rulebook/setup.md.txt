(rulebook:setup)=
# Setup a game

1. Place the **4 CPU registers** (`A`, `B`, `C`, and `D`) and their corresponding switched-off bits in the middle of the
   table.
   This will be the central board.

2. Place the **operation** cards on the left of the central board, sorted by their energy usage:
   first those requiring 2 energy units (`INC`, `DEC`),
   then those requiring 1 energy unit (`NOT`, `ROL`, `ROR`, `ROL`, `MOV`),
   and finally those requiring 1/2 energy units (`OR`, `AND`, `XOR`).

3. Shuffle the **goal cards** and place the deck face-down on the right side of the central board.
   These cards represent the calculations astronauts need to make to land on the moon.

4. Take 3 **energy units** and place them next to you.

```{image} ../_static/rulebook/setup.png
:align: center
```

MOON simulates a **real computer**.
Operations modify data in the same way as in real microprocessors.
So, let’s review how to count in binary before you start playing.
