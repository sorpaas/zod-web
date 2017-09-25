---
anchor: none
---

# Solri Galaxy, Star and Planet Giveaway

First things first, we accept dual nationality!

You may have heard the recent plan of [Urbit to integrate the Ethereum
blockchain](https://urbit.org/blog/2017.9-eth/). Besides [other
objections](https://zod.that.world/classic/6-migrate-solri/), the plan
makes no cryptocurrency-sense and reduces Urbit to the class of
side-chains. It will also mean that when the integration is finished,
you will need to download the whole Ethereum blockchain (more than
10GB) if you want to validate the PKI yourself.

For anyone who don't like it, you can migrate to Solri. Solri is Urbit
without the blockchain buzzword, and will closely follow the
development of Urbit.

* It will not integrate with any particular blockchain, to keep it
  pure and avoid any blockchain wars.
* Its constitution will be written in [Lojban](http://lojban.org/)
  rather than English.

Right now Solri is giving away 63 galaxies and 63 stars to anyone who
request. This is first-come first-served.

## Running Solri

Running Solri is as easy as running Urbit, except that we don't
provide any binary builds.

Go to [Solri repository](http://github.com/solri/urbit) and follow the
build instructions. You can then follow Urbit's guide to join the
Solri network.

## The Giveaway

Details are as below. It assumes that you have a working Solri build
as described above.

### Galaxy Giveaway

Setting up a galaxy might be hard for non-programmers. Besides, if you
become a galaxy owner, please help to distribute stars and planets to
those who request. The steps are adopted from [~wicdev-wisryt on
Urbit](https://urbit.org/fora/posts/~2016.8.17..21.04.11..1450~/).

1. Get a server that you plan to host the galaxy up and running, know
   its IP address.
2. Choose an untaken galaxy name from
   [here](https://github.com/solri/arvo/blob/maint-20170614/arvo/ames.hoon#L145). It
   needs to be **in the range 1-63 (inclusive)**. I will assume below that the
   name you choose is `~gal`.
3. Clone
   [https://github.com/solri/arvo](https://github.com/solri/arvo) to
   your local disk.
4. Start up an urbit ship. This doesn't need to be connected to
   anything, so you can use a fakezod (`bin/urbit -cFI ~zod -A
   path/to/arvo pier` to create). This shouldn't talk to the net, but
   if you're paranoid you can run this on a machine with no internet
   access, etc.
5. Run `+pope ~gal`. It'll ask for a "passphrase", which can be any
   entropy. We recommend at least 512 bits of entropy.
6. Press enter twice, and it'll generate a fingerprint and a
   generator, both in the form 0wXXX.
7. Save the generator, it can generate your public and private
   keys. You will need to use this when you first boot the galaxy in
   each continuity era.
8. Add the fingerprint to the corrsponding line arvo/ames.hoon and
   send a pull request to
   [https://github.com/solri/arvo](https://github.com/solri/arvo). State
   the IP address you're going to host the galaxy.
   
Then after some wait and when your PR gets merged, you will be able to
create the galaxy.

1. Make sure your firewall accepts connections on the correct UDP
   port. Your port is `13337 + galaxy-number`, where `galaxy-number`
   is the number of your galaxy.
2. Fetch the newest
   [https://github.com/solri/arvo](https://github.com/solri/arvo)
   repo.
3. `bin/urbit -cI gal -A path/to/arvo pier` to create. It will ask
   your generator.
4. `bin/urbit -I gal pier` to start afterwards.

### Star and Planet Giveaway

We have around 63 stars and 16384 planets to be given away.

If you want a star or a planet, simply send me a message using Reddit
(/u/sorpaas), Twitter (@sorpaas), or [email](mailto:hi@that.world).
