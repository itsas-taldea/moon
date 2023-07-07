# Concepts

Let's review some parallelisms between computers and MOON.

- Each computer architecture has an {wikipedia}`instruction set <Instruction_set_architecture>` that defines which
  operations can be performed and how to specify the arguments.
  Typically, multiple {wikipedia}`addressing modes <Addressing_mode>` are supported.

  In MOON, a very reduced set of directly addressed arithmetic and boolean operations is defined.
  Branching/jumping instructions are not modeled.

- In order to achieve their purposes, programs do operations on the CPU.
  When a program runs, it can use multiple registers and memory locations to perform operations, but the result has to
  be stored in some specific location.

  In MOON, this means that any player can modify any CPU register in her turn, but you will have to achieve your goal in
  the register `A` to win.

- The operating system assigns time to programs to run.
  A program can only execute a limited number of operations before running out of time.
  When it runs out of time, it has to leave the CPU for other programs.

  In MOON, each player has several energy units for every turn.
    - In cooperative mode, exceptionally a program can take longer at the cost of reducing the time available for other
      programs.
    - In competitive mode, you will use the energy to perform operations and then leave the CPU register to the next player.

- Since all programs share the CPU, a partial result should be stored in a local RAM memory.
  Contrary to what happens with the CPU registers, the RAM memory of each program is protected from other programs.

  In MOON, each player has an individual RAM module which other players cannot modify or use.
  You can copy any of the values from the CPU register to your RAM (using the MOV operation) before your turn ends.
  Then, you can copy it back to any register of the CPU (using MOV again) during your next turn.
