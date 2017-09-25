---
date: ~2017.9.14
title: On Adding Precompiled Contracts without Hard Forks
type: classic-post
navhome: /classic
comments: true
---

# On Adding Precompiled Contracts without Hard Forks

Many of the Metropolis hard forks and recent discussions
in
[Ethereum Classic Improvement Proposals](https://github.com/ethereumproject/ECIPs/) are
about adding new precompiled contracts. Precompiled contracts are just
native code in EVM -- when you issue a CALL to any of the precompiled
contract address, instead of trying to evaluate the actual code in
that address, the EVM will execute a pre-defined native codes and
return the results. Those precompiled contracts adds additional
functionality such as zkSNARK that allows various interesting
features.

Adding new precompiled contracts, however, have one really unpleasent
drawback -- it requires a consensus hard fork, which requires a large
amount of efforts to carry out, and is possible to cause a community
split. So, is it possible to add new precompiled contracts without
requiring a hard fork?

**tldr**, the answer is yes. We will only need to modify the client
and use a special rule for including transactions in a block to reach
the same performance as the hard fork way. A soft fork can be carried
out if we want to prevent a block gas limit attack, but it is pretty
unlikely unless the attacker controls a significant amount of the
network's hashpower.

Below I'll introduce the way to do this.

## Implement the Functionality in EVM Opcodes

The first step is to implement the functionality of the proposed
precompiled contract in EVM opcodes. This provides a slow version of
what is desired. Implementation might be a little bit tricky, but
given EVM's similarity to other VMs like WebAssembly, it is doable.

The resulting contract A might be quite slow, and might also require a
large amount of gas to execute. If the gas required exceeds the block
gas limit, miners will need to vote to raise the block gas limit to
the level that is the originally comfortable level plus the gas of the
newly created contract A. They should still only accept transactions
up to the originally comfortable level -- the raised level is totally
just for the new contract.

You can see, in this way, no hard fork happens when we get the
functionality. So old clients are not affected. Next, the only thing
we need to do is to make it so that the contract A runs reasonably
fast.

## Replace the Contract with Native Codes

To do this, we create an equivalent native Rust/Go code as the above
contract A. When the client tries to run anything that invokes the
contract A (either in a transaction or through CALL* opcodes), instead
of executing the EVM codes, it executes the native code. This returns
the same result, and costs the same gas.

Clients solely uses the raised block gas limit if it finds that a
block has a transaction that executes contract A. In that case, it
accepts a gas price reduction -- transactions that use contract A can
have a lower gas price compared with other transactions.

In this way we reached our objective -- adding precompiled contracts
without any hard fork, and in terms of performance, it is the same as
the hard fork way.

## Block Gas Limit Attack

If an attacker controls a significant amount of hash power, it can
abuse the raised block gas limit to include other transactions, which
may cause a slow down in miners importing new transactions.

This attack can be prevented by doing a soft fork that allows the
chain to keep a secondary block gas limit (for example, as a RLP item
in the extra data field of the block). If a block does not contain any
transactions invoking contract A but its total used gas exceeds the
secondary block gas limit, then that block is rejected.

## Detecting Transactions and Contracts that Call Contract A

To cheaply detect whether a transaction or contract contains
invocation to contract A, the client can use some heuristics. A simple
way to do this is to search for the opcode sequence as below:

```
PUSH20(<contract A address>)
SWAP1
CALL
```

See [Safely Detecting Gas Price Reduction in Non-HF Precompiled
Contracts](/classic/7-reduced-gasprice/) for a more detailed
explanation on how this can be done.

## About Classic in Orbit

Classic in Orbit is an Ethereum Classic blog by Wei Tang
([@sorpaas](https://twitter.com/@sorpaas)), a Rust developer currently
working at ETC Dev Team. You can access this blog
at
[https://zod.that.world/classic](https://zod.that.world/classic)
or in [Solri](https://zod.that.world/giveaway)'s **~zod** galaxy.

*You can suggest changes at
[Github](https://github.com/sorpaas/zod-web/blob/master/web/classic/5-nonfork-precompiled.md).*
