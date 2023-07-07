# Counting in binary

Both the individual RAM modules and the CPU registers have several bits that work as binary counters.
Each position has an associated number (1, 2, 4 and 8 in 4-bit registers).

If all the bits of a register are switched off, the value zero is stored.
See {numref}`fig-binary_0`.

```{figure} ../_static/rulebook/binary_0.png
:name: fig-binary_0
:align: center

Representation of zero.
```

If there are any switched-on bits, you have to add the numbers placed on the top of the CPU.
This will be the value stored in that register.
See, for example, {numref}`fig-binary_3` and {numref}`fig-binary_9`.

```{figure}  ../_static/rulebook/binary_3.png
:name: fig-binary_3
:align: center

Representation of decimal number 3.
Positions 1 and 2 are switched on, so {math}`1 + 2 = 3`.
```

```{figure} ../_static/rulebook/binary_9.png
:name: fig-binary_9
:align: center

Representation of decimal number 9.
Positions 1 and 8 are switched on, so {math}`1 + 8 = 9`.
```
