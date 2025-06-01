<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

- A **Moore FSM** that inspects a product through multiple states, based on two binary inputs:
  - `P`: presence of product
  - `RI`: inspection result

  It produces a 2-bit output `E`:
  - `00`: Idle
  - `01`: Product advances
  - `10`: Rejected
  - `11`: Passed inspection

- A **Mealy FSM** that receives the output `E` from the Moore FSM and drives a protocol response through a 2-bit output `Y`:
  - `01`: Activate conveyor belt
  - `10`: Rejection action
  - `11`: Approval action

## How to test

1. Apply a clock to the `clk` input.
2. Use the `in[0]` bit for `P` (product present).
3. Use the `in[1]` bit for `RI` (inspection result).
4. Reset the circuit with `rst_n` (active-low reset).

## External hardware

This project does **not require external hardware**.
