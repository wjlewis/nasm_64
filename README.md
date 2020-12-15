# Overview

These are a collection of small programs written for
[NASM](https://www.nasm.us/xdoc/2.15.05/html/nasmdoc0.html). Aside from
the official NASM docs (which are quite good), the following resources
have been incredibly helpful:

-   [LMU NASM Tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
-   [Intel 64 Manuals](https://software.intel.com/content/www/us/en/develop/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4.html)
-   [x86-64 C ABI Guide](https://aaronbloomfield.github.io/pdr/book/x86-64bit-ccc-chapter.pdf)
-   K&R C

# Quick notes for future reference

## Registers

`x86-64` provides 16 general-purpose registers, named `rax`, `rbx`,
`rcx`, `rdx`, `rsi`, `rdi`, `rsp`, `rbp`, `r8`, `r9`, `r10`, `r11`,
`r12`, `r13`, `r14`, `r15`.
Although some of these registers have historical "charisms" (e.g. `rax`
was used as the _accumulator_ in arithmetic operations, `rcx` as the
loop _counter_, etc.), most can be used interchangeably. The only
exceptions to this are `rsp` (and possibly `rbp`), which is/are used to
maintain the current pointer into the stack.

## File layout

A line in a NASM assembly program file consists of either an assembler
directive, or the following sequence:

```
label: operator operands...
```

The `label` is optional, and the number of operands is determined by
the operator. The included examples are a better introduction to the
actual instructions, but here are a few pointers:

## Instructions

Arithmetic instructions store the result in the _first_ operand. That
is, this instruction

```
add rax, rbx
```

will sum the values in `rax` and `rbx`, and store the result in `rax`.

Likewise,

```
dec rcx
```

subtracts 1 from `rcx`, and stores this value in `rcx`.

## References to memory

There are several ways to refer to a location in memory. In general, we
can provide a _base_ register, an _index_ register, a _scale_ factor,
and a constant _offset_. The access is represented (and computed) like
this:

```
[base + index * scale + offset]
```

Examples:

-   Referencing the value stored in location `42`: `[42]`.
-   Referencing the value _pointed to_ by `rsi`: `[rsi]`.
-   Referencing the 4th element of an array of words (2 bytes) pointed to
    by `rsi`, where `rcx` contains a representation of `3`: `[rsi + rcx * 2]`.

## Branching

Branching is accomplished using the `jcc` operators, where `cc`
stands for some condition. For instance, `je label` continues execution
at (i.e. moves the IP to) the instruction labeled by `label` if the
most recently performed comparison (`cmp`) revealed an equality.

## Procedures

Procedures typically make use of the stack, the related stack-manipulation
registers/instructions, and the special `call` and `ret` instructions.
A procedure is simply represented as a labeled block that terminates in
a `ret` instruction. The procedure is entered by `call proc-label`; this
instruction does two things: it pushes the address of instruction
_following_ the `call` instruction onto the stack, and it jumps to
`proc-label`. When the `ret` instruction is encountered within the
procedure, the value pointed to by `rsp` is popped into the instruction
pointer. All-in-all, this means that writing procedures is a matter of
being mindful of just a couple of ideas and conventions, like

-   Making sure that `rsp` is pointing to the correct value before `ret`
    is invoked
-   Managing the "passing" of parameters via registers and the stack
-   Saving/restoring registers that might be modified by a procedure to be
    called
-   Any stack-alignment considerations

One way of doing this is via the "C ABI" (Application-Binary Interface).

# x864-64 C ABI

There's a lot more to it than this, but here are the greatest hits
(taken from the PDF linked to above):

Caller's rules:

-   Caller is responsible for saving `r10`, `r11`, and any registers that
    parameters are put in
-   To pass parameters, stuff as many into `rdi`, `rsi`, `rdx`, `rcx`,
    `r8`, and `r9`, and then use the stack (but push from _right_ to
    _left_, so that the leftmost parameter is the last pushed)
-   Procedures place any return value in `rax`

Callee's rules:

-   Allocate locals in registers or on the stack. Since the stack grows
    downward, stack space is reserved by subtracting the desired number
    of bytes from `rsp`. For instance, `sub rsp, 4` reserves 4 bytes on
    the stack.
-   Callee is responsible for saving (i.e. not overwriting) `rbx`, `rbp`,
    and `r12` ... `r15`.

Also, before executing the `call` instruction, `rsp` must be aligned
along a 16-byte boundary.

# Next steps

-   More work with logical operators
-   Floating point arithmetic
-   SIMD operators
-   Multiple stacks/concurrency
