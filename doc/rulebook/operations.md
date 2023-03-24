(rulebook:operations)=
# Operations

## INC

This operation is used on **1 register** and costs **2 energy** units.
It **adds 1** to the total value stored in the register:

```{image} ../_static/rulebook/operation_inc.png
:align: center
```

~~~{attention}
If the register stores the maximum value (all bits switched on), an **overflow** happens and the register is reset to zero:

```{image} ../_static/rulebook/operation_overflow.png
:align: center
```
~~~

## DEC

This operation is used on **1 register** and costs **2 energy** units.
It **subtracts 1** to the total value stored in the register:

```{image} ../_static/rulebook/operation_dec.png
:align: center
```

~~~{attention}
If all the bits of the register are switched off, subtracting 1 will cause an **underflow** that sets all the bits of
the register to one (switched on):

```{image} ../_static/rulebook/operation_underflow.png
:align: center
```
~~~

## ROL

This operation is used on **1 register** and costs **1 energy** unit.

It involves **shifting** every bit on the register to the **left** and placing the remaining bit on the left in the
rightmost position:

```{image} ../_static/rulebook/operation_rol.png
:align: center
```

~~~{hint}
From an arithmetic point of view, in many cases it is equivalent to **multiplying** the value of the register by 2:

```{image} ../_static/rulebook/operation_rol_mul.png
:align: center
```
~~~

## ROR

This operation is used on **1 register** and costs **1 energy** unit.

It involves **shifting** every bit on the register to the **right** and placing the remaining bit on the right in the
leftmost position:

```{image} ../_static/rulebook/operation_ror.png
:align: center
```

~~~{hint}
From an arithmetic point of view, in many cases it is equivalent to **dividing** the value of the register by 2:

```{image} ../_static/rulebook/operation_ror_div.png
:align: center
```
~~~

## MOV

This operation is used on **2 registers** or 1 register and a RAM module and costs **1 energy** unit (1/2 in competitive mode).

It **copies** all bits from one register to another, **overwriting** the value stored in the destination.

```{image} ../_static/rulebook/operation_mov.png
:align: center
```

```{hint}
In competitive mode, it can be useful to copy a value into your RAM module and then recover it later, preventing other
players from modifying it.
```

## NOT

This operation is used on **1 register** and costs **1 energy** unit.

It **negates** every bit on the register: switched-on bits are switched off, and switched-off bits are switched on.
This involves **flipping** all the bits of the register.

```{image} ../_static/rulebook/operation_not.png
:align: center
```

## OR

This operation is used on **2 registers** and costs **1/2 energy** unit.

It **copies** only the **switched-on** bits from one register to another.

```{image} ../_static/rulebook/operation_or.png
:align: center
```

### NOR

```{todo}
Describe `NOR`.
```

## AND

This operation is used on **2 registers** and costs **1/2 energy** unit.

It **copies** only the **switched-off** bits from one register to another.

```{image} ../_static/rulebook/operation_and.png
:align: center
```

### NAND

```{todo}
Describe `NAND`.
```

## XOR

This operation is used on **2 registers** and costs **1/2 energy** unit.

It **copies** only the **switched-on** bits from one register to another, but if the bit was already on, it’s turned off.

```{image} ../_static/rulebook/operation_xor.png
:align: center
```

### XNOR

```{todo}
Describe `XNOR`.
```

## ADD

```{todo}
Describe `ADD`.
```

## SUB

```{todo}
Describe `SUB`.
```
