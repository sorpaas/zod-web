---
date: ~2017.9.22
title: How to Create a Fork of Urbit
type: descend-post
navhome: /descend
comments: true
---

# How to Create a Fork of Urbit

Sometimes it might be useful to create a fork of the Urbit network
either because you have several pieces of machines and servers that
you want to fit into a private network, or because you don't like
Tlon. Forking Urbit is actually a really easy task.

## `urbit/urbit`

To fork Urbit, there are several things to be changed. Starting the
network, the Urbit client will try to connect to `zod.urbit.org`. To
connect to a different network, you'll need to change this address. Go
to
[vere/ames.c](https://github.com/urbit/urbit/blob/maint-0.4/vere/ames.c#L71)
and replace the DNS address with your own.

Urbit client, on bootstrap, will also download the "pill". To change
this, go to
[noun/manage.c](https://github.com/urbit/urbit/blob/maint-0.4/noun/manage.c#L1543). The
Urbit's [Contributing
Guide](https://github.com/urbit/urbit/blob/maint-0.4/CONTRIBUTING.md)
has instructions for how to generate a "pill" for your own use.

## `urbit/arvo`

When bootstrapping, an important piece is the galaxy PKI, which is
located at
[arvo/ames.hoon](https://github.com/urbit/arvo/blob/maint-20170614/arvo/ames.hoon#L145). Ususally
a fork will need to change all of these fingerprints and replace the
unused one with `0w0`.

The guide in [Solri's giveaway](https://zod.that.world/giveaway/)
thread contains information about how to generate those
fingerprints. You will only need to make sure that you have a ~zod`
fingerprint setup and you're off to go. :)

