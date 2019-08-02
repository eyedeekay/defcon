
### Make your Code Re-Usable!

Because of the deliberate similarity to existing streaming and datagram
communications, every language makes it possible to reduce this process to one
or two steps at sensible layers of abstraction. Starting from the most similar,
like a Socket in Java, a connection in Javascript, or a net.Conn in Go. The
actual thing will vary from language to language, but when creating a library,
you should probably start with a whatever's closest to a Socket.

Once you've done that, you've laid the foundation to alter the other network
parts of your language. In many cases, it may be possible to forward a
connection using the code you've already written, or to replace an underlying
structure with your SAM-enabled version.

In a surprisingly short amount of time, you too can develop extensive tooling
that makes building new I2P applications and, more importantly, adapting your
existing applications to use I2P simple, reliable, and familiar.

Or you can literally just write your own i2ptunnel that you can embed in your
existing application. I did that once. It works really well. I don't think we
need a gazillion 'socat for I2P' out there but some would argue we didn't need
a third so who am I to judge.
