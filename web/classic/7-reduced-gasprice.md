---
date: ~2017.9.25
title: Safely Detecting Gas Price Reduction in Non-HF Precompiled Contracts
type: classic-post
navhome: /classic
comments: true
---

# Safely Detecting Gas Price Reduction in Non-HF Precompiled Contracts

A common question raised from [On Adding Precompiled Contracts without
Hard Forks](/classic/5-nonfork-precompiled/) is if a transaction
indicated gas price reduction, how can the client make sure that it is
safe to execute and that the gas price reduction is valid. Incorrectly
handling this might result in DDoS attacks in the network -- whereby it would be
flooded with invalid gas price reduction transactions, rendering clients too
busy to spend the time to check whether they are, in fact, valid.

EVM is turing complete, so instead of validating directly on the
client, we can delegate the resposibility to the transaction
signer. In the networking layer, this makes it so that when a transaction
with gas price reduction is broadcasted, it will also need to
broadcast a supplimental piece of information in the form of a gas price reduction proof.

## The Proof

The proof is a list of static call stacks with its code
locations. Each call stack, specifically, is represented as:

```
[<pc_loc> <pc_loc> <pc_loc> ...]
```

The last item of the call stack must be a `CALL` to a non-HF
precompiled contract. The client then simply follows this list of proof
to check that a non-HF precompiled contract must have been called for
**at least** N times to compensate for its gas price reduction. This
check is done in linear time.

The client first goes to the code location (if it is a message call
transaction, then the code is from the `to` address of the
transaction, and if it is a contract creation transaction, then the code
is from the `data` field of the transaction) of the first item in the
call stack, and checks that it is a **static** call represented by the sequence
below:

```
PUSH20(<contract address>)
SWAP1
CALL
```

The client then follows `<contract address>` and checks the second
item in the call stack. For the last item, it checks whether the
`<contract address>` is in a known list of non-HF precompiled
contracts.

## The Networking Layer

Instead of broadcasting the transaction with gas price reduction using
the `Transactions` message in the [Ethereum
sub-protocol](https://github.com/ethereum/wiki/wiki/Ethereum-Wire-Protocol), we
define a new message `PriceReducedTransactions` message with the
following format:

```
[+0x0n: P, [[nonce: P, receivingAddress: B_20, ...], [[callStackItem: P, ...], ...]], ...]
```

That is, each transaction is also supplied by a list of call stack
proofs to demonstrate that the gas price reduction is valid.

A new protocol version will also need to be defined because now we
have a new message.

## Calculating the Gas Price Reduction

Because we can only check the gas price reduction statically, it is
assumed that each non-HF precompiled contract reduces the gas needed
by a constant number `N_<contract>`. In this way we can calculate the
gas price reduction as follows:

```
R_gas = T_gas - SUM_<contract>(N_<contract>)
R_gas * R_price = T_gas * N_price
```

Where `T_gas` is the actual gas limit specified in the
transaction, `R_gas` is the reduced gas, `R_price` is the reduced gas
price, and `N_price` is the normal gas price.

## About Classic in Orbit

Classic in Orbit is an Ethereum Classic blog by Wei Tang
([@sorpaas](https://twitter.com/@sorpaas)), a Rust developer currently
working at ETC Dev Team. You can access this blog
at
[https://zod.that.world/classic](https://zod.that.world/classic)
or in [Solri](https://zod.that.world/giveaway)'s **~zod** galaxy.

*You can suggest changes at
[Github](https://github.com/sorpaas/zod-web/blob/master/web/classic/7-reduced-gasprice.md)
or in this [public Google
Docs](https://docs.google.com/document/d/19uyewUxhYiL60ft9T_N9DQdYiJBFBpxFo5_dFsftbYs/edit?usp=sharing).*
