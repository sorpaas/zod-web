---
date: ~2017.9.21
title: Migrate from Urbit to Solri
type: classic-post
navhome: /classic
comments: true
---

# Migrate from Urbit to Solri

You may have noticed that this blog is hosted on an Urbit
star/galaxy. Urbit has always been an good nerdy toy for me to play
with. However, recently, Urbit decides to [bootstrap its PKI system
from the Ethereum blockchain](https://urbit.org/blog/2017.9-eth/).

I have no particular hard feelings towards any particular
blockchain. After all, each one has its unique features -- wide
adoption from Bitcoin, smart contracts from Ethereum, sounding
philosophy from Ethereum Classic, trusted anonymous transactions from
Monero. However, I don't think Urbit's joining the on-going blockchain
war is a good idea -- it retakes all the fun away, which is the only
reason that I'm running Urbit for this blog. Besides, Urbit's galaxy
PKI system acts similar to blockchain's genesis block. You have never
seen a standalone blockchain (except side chains) writing its genesis
block into another blockchain. If the problem is with the PKI system
on the star level, then it's better to fix it within Urbit, rather
than saying "Urbit cannot do this, let's use something else".

At the same time, Urbit hasn't given any sounding plan for its
integration with Ethereum. Anything I can think of would require Urbit
to download the whole Ethereum blockchain (10+ GB and is still
growing). That would be something unacceptable. Blockchain technology
is something that trades consensus with efficiency. Being even less
efficient than Urbit, it is better to make it optional rather than
doing something as mandatory as bootstrapping the PKI.

Urbit certainly has many talents in the Urbit technology. However,
from someone working in the blockchain field, the move to integrate
Ethereum certainly shows a lack of understanding of what a blockchain
actually does. A config file that can be distributed across all client
is certainly more decentralized than a large PKI state (which if we
move to Ethereum integration, will be the case). Because the later can
only be downloaded by few galaxy nodes, and every other client will
rely on those galaxy nodes for the truth. The later is not much
different than PayPal.

Besides, Urbit starts to censor discussions that are not in favor of
the Urbit trademark. This makes it questionable whether a good
community can be built by Tlon.

As a result, I decide to fork Urbit and create Solri. Solri is Urbit
without the blockchain buzzword, and will closely follow the
development of Urbit.

* It will not integrate with any particular blockchain, to keep it
  pure and avoid any blockchain wars.
* Its constitution will be written in [Lojban](http://lojban.org/)
  rather than English.
  
Solri is a Lojban word, meaning "the sun".

We are also accepting Urbit immigrants (dual nationality is perfectly
fine!). You can find more details
[here](https://zod.that.world/giveaway/).
