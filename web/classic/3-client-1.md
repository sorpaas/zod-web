---
date: ~2017.9.5
title: Building Your Own Ethereum Classic Client: Part I
type: classic-post
navhome: /classic
comments: true
---

# Building Your Own Ethereum Classic Client: Part I

> The revolution will not be centralized. (Peacenik Rick, on comment
> of the Occupying Wall Street movement.)

A large part of cryptocurrency is about decentralization. Running your
own client for the cryptocurrency would help. More nodes to validate
the blockchain, less chance the chain can be controlled by a single
party.

A deeper step for decentralization is to understand how the client
works. With this knowledge, you would understand how generally the
coin you use daily works, evaluate protocol changes that you agree or
disagree, and better stand on your position. This series of posts,
titled *Building Your Own Ethereum Classic Client*, aims to help
general users and developers to get an idea of the internal details of
Ethereum Classic.

In this post, I would introduce how a client downloads the blockchain
from the P2P network. In later posts, I'll go deep into how blocks are
generated or validated, and how account state transition actually
happens. In any post of this series, I'll provide you with the actual
Rust code gist that you can test and experiment. Combining them all
together, you will get a bare minimal but fully functional Ethereum
Classic client.

## Talk is Cheap, Show Me the Code!

A large part of this post is based on work done
on [etclient](https://github.com/sorpaas/etclient), a bare minimal
Ethereum Classic client. Compared with other Ethereum Classic clients
like Parity or Go Ethereum, you will find this client extremely
minimal -- less than a few thousand of lines of code but still fully
functional. The clients are built upon individual components that does
its job, [devp2p](https://github.com/sorpaas/devp2p-rs) for the P2P
network layer, [ethash](https://github.com/ethereumproject/ethash-rs)
for the consensus
layer, [etcommon](https://github.com/ethereumproject/etcommon-rs) for
Merkle trie and common blockchain structures, and
finally, [SputnikVM](https://github.com/ethereumproject/sputnikvm) for
the transaction state transition.

Those components hide a large amount unnecessary details and let you
focus on what's important -- it is the same thing that if you are
building a web application, you don't need to understand how the
actual TCP layer works. Using those components, you can build your own
client, too.

## Download the Blockchain

The client always spends a large amount of time to download the
blockchain from other peers. Using those downloaded blocks, it
gradually figures out how much balance you have on your address, and
let you send out transactions based on information received. But
first, the blockchain needs to get downloaded.

The Ethereum Classic client tries to connect to a number of peers
(other machines that also run the client) at any given time, and talk
with them using a protocol
called
[RLPx](https://github.com/ethereum/devp2p/blob/master/rlpx.md). This
is a generic protocol, which can hold multiple "subprotocols" which
client can exchange actual information. One of the "subprotocols" is
Ethereum Classic.

Each client has an "ID" associated with it, with this "ID", it
identify an unique client and avoids man-in-the-middle attack. RLPx
happens over TCP. Once connected, it will do an additional handshake
in the RLPx protocol layer. The details of this handshake is mostly
cryptography details, but what happens inside is that they will
exchange their client "ID", and figure out how exchange messages are
encrypted for later.

After the initial handshake, the communication happens. Client sends
"Hello" message to exchange "subprotocols" they support, this usually
includes "eth", the actual Ethereum Classic protocol. After that,
subprotocols can exchange information.

## Inside the "eth" Subprotocol

"eth" works in both request-response way and async way. First of all,
client will exchange the "Status" message. This allows both party to
know each other's current best blocks and whether they are actually on
the same network. Client will proactively send newer blocks and
pending transactions that it thinks the other party is interested to
know.

What as well happens is requests and responses. A client can send
"GetBlockHeaders" and "GetBlockBodies" to explictly request some
blocks that it's interested in, and the other party would send
"BlockHeaders" and "BlockBodies" to fulfill the request.

In this way, a client downloads a part of the blockchain from the
other peer.

## Discovering Other Nodes

You may ask, the above is about communication with a single peer, but
how does a client discover other peers? Ethereum uses something called
DPT (a UDP protocol) to deal with it.

What happens is that a fresh client will always try to first exchange
message with the bootnodes -- nodes that are expected to always be
running and responding, and is hard-coded into the client. Those
bootnodes, as they are already connected with the network, will tell
this client some other peers that it know. Using DPT protocol again,
the client then connect to those peers, and request new peers that
those peers know about, until it finds enough peers to connect.

## Programming the Code

You can find the full example
from
[the devp2p repository](https://github.com/sorpaas/devp2p-rs/blob/master/examples/eth_connect.rs). Here
I give some comments on various parts of the code.

```
const BOOTSTRAP_NODES: [&str; 10] = [ .. ]
```

This above constant defines the bootnodes in this network. You can see
that those nodes are all provided in the syntax of `enode:://[client
id]@[ip]:[port]`.

The `ETHStream` is the one that combines RLPx protocol with DPT
protocol. So it handles both peer communication and peer
discovery. Using this, we have a timeout if no new message received
from any peers. It then repeatively sends `GetBlockHeaders` to request
blocks from other peers.

```
client_sender = core.run(client_sender.send(ETHSendMessage {
    node: RLPxNode::Any,
    data: ETHMessage::GetBlockHeadersByHash {
        hash: best_hash,
        max_headers: req_max_headers,
        skip: 0,
        reverse: false,
    }
})).unwrap();
```

And then receive messages about `BlockHeaders` response.

```
ETHMessage::BlockHeaders(ref headers) => {
    println!("received block headers of len {}", headers.len());
    if got_bodies_for_current {
        for header in headers {
            if header.parent_hash == best_hash {
                best_hash = keccak256(&rlp::encode(header).to_vec());
                best_number = header.number;
                println!("updated best number: {}", header.number);
                println!("updated best hash: 0x{:x}", best_hash);
            }
        }
    }
    client_sender = core.run(client_sender.send(ETHSendMessage {
        node: RLPxNode::Any,
        data: ETHMessage::GetBlockHeadersByHash {
            hash: best_hash,
            max_headers: req_max_headers,
            skip: 0,
            reverse: false,
        }
    })).unwrap();
    timeout = Timeout::new(dur, &handle).unwrap().boxed();
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
[Github](https://github.com/sorpaas/zod-web/blob/master/web/classic/3-client-1.md).*
