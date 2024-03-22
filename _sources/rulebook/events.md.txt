(events)=
# Events

Add event cards to the deck of goal cards to make the games more exciting!

## Reset

Reset cards **reset** (all its bits are switched off) a row or a column of the CPU.

Register resets change a row while bit resets change a column.

```{image} ../_static/rulebook/events_reset.png
:align: center
```

## Error

Error card **disable** a register or an operation.

```{image} ../_static/rulebook/events_error_register.png
:align: center
```

```{note}
Despite a register being disabled, if a reset event occurs, the corresponding bits are set to zero.
However, the register remains disabled.
```

```{image} ../_static/rulebook/events_error_operation.png
:align: center
```

## OK

OK cards **repair** an existing ERROR in a register or operation.


```{image} ../_static/rulebook/events_ok.png
:align: center
```

```{important}
You **cannot** keep them around to repair future errors!
```
