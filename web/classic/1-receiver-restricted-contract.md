---
date: ~2017.7.1
title: The Receiver-restricted Smart Contract
type: classic-post
navhome: /classic
comments: true
---

# The Receiver-restricted Smart Contract

One of the advantage of cryptocurrency is that you're able to run your own bank -- you can run code against your money and it automates some of the daily tasks. However, multiple levels of security and trust exist in the code that moves money. For example, we have:

* **Your personal laptop, or your mobile phone, or your hardware wallet**: those are the things that you trust ultimately and it should be allowed to move money everywhere.
* **Your server ran by a cloud-host provider**: those runs against the public, and it is more likely to be comprised. The server should only be allowed to move money to some trusted address.

All the above entities all have valid practical use of sending money around. For example, I have a personal knowledge management tool written in [Racket](http://racket-lang.org/) that automates most of my task management process. The information being outputted by that tool can be used to derive many other useful applications. For example, there is [Short-of-time Index](https://that.world/~wei/busy/), which by analyzing the tasks that I currently have, tells other how busy I am at the current moment. The information can also be used to manage finance. Combined with a Bitcoin and Ethereum Classic price source, it can estimate how I should distribute funds for leisure and investment.

The code that carries out the distribution needs to be run on a server -- it needs to be able to redistribute funds 24/7 to be useful. A server, however, as we discussed, is not as secure as a hardware key or a laptop. It is important to limit the destination of money to be some trusted address. A receiver-restricted smart contract can do exactly that -- it allows an owner to add trusted address, so an operator can run in a less-trusted environment that moves money on your behalf. Below are some pseudocode that does that.

```
contract ReceiverRestricted {
  address owner;
  address operator;
  address[] trusted;
  
  function addTrusted(address addr) {
    if msg.sender != owner {
      throw;
    }
    trusted.push(addr)
  }
  
  function send(address addr, uint value) {
    for (uint i = 0; i < trusted.length; i++) {
      if trusted[i] == addr {
        addr.transfer(value);
        return;
      }
    }
    throw;
  }
}
```

## About Classic in Orbit

Classic in Orbit is an Ethereum Classic blog by Wei Tang
([@sorpaas](https://twitter.com/@sorpaas)), a Rust developer currently
working at ETC Dev Team. You can access this blog
at
[https://zod.that.world/classic](https://zod.that.world/classic)
or in [Solri](https://zod.that.world/giveaway)'s **~zod** galaxy.

*You can suggest changes at
[Github](https://github.com/sorpaas/zod-web/blob/master/web/classic/1-receiver-restricted-contract.md).*
