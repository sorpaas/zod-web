---
date: ~2017.7.4
title: Burn Money on an Ethereum Blockchain
type: classic-post
navhome: /classic
comments: true
---

# Burn Money on an Ethereum Blockchain

There are two ways to burn money on an Ethereum blockchain. The first
way is to accidentially lose a private key or to send money to a
contract that cannot be retrived. In this case, total sum of money of
all accounts in the blockchain remains unchanged. The second way is to
just magically make money disappear. After you do that, the total sum
of money of all accounts in the blockchain will be reduced.

In an Ethereum blockchain, to burn money in the second way is really
easy using the SUICIDE opcode. The SUICIDE opcode accepts one
argument -- the receiver of the money to be transferred. It then sets
the current account balance to zero. So if one accidentally set the
argument as the same account as the current account, the money will
first be transferred to itself -- no problem, but then, the current
account balance -- again this is the account itself -- will be set to
zero. In this way, some money is just burnt to nowhere.

## About Classic in Orbit

Classic in Orbit is an Ethereum Classic blog by Wei Tang
([@sorpaas](https://twitter.com/@sorpaas)), a Rust developer currently
working at ETC Dev Team. You can access this blog
at
[https://zod.that.world/classic](https://zod.that.world/classic)
or in [Solri](https://zod.that.world/giveaway)'s **~zod** galaxy.

*You can suggest changes at
[Github](https://github.com/sorpaas/zod-web/blob/master/web/classic/2-burn-money.md).*
