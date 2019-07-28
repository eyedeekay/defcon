What is SAM
-----------

SAM is a simple API for controlling **connections** on the I2P i2p router in a
way which is familiar to people who write internet applications. To use it, you
simply set up a SAM connection and then use it like a streaming connection or
to send datagrams, either with or without a repliable address. You can use these
connections just like their TCP/IP equivalents for basically every intent or
purpose.

### Stages of the SAM Setup process

 1. Handshake
  - This is done so that you can negotiate the features of your SAM client with
  the SAM service.
  - First, establish a socket connection to the I2P router's SAM Port.
  - From the client, it's a simple "HELLO" message which can contain optional
  version and authentication information.
  - When the server replies, it will respond with OK and the maximum supported
  SAM version.
 2. Session Establishment
  - Once your handshake is complete, you need to establish a session with SAM
  to control connections.
  - To create a session, you send a "SESSION CREATE" message which must declare
  the type of connection and messaging you will be doing, a unique name for
  the connection which will allow you to refer to the client, and either a full
  public/private base64-encoded key pair for the local tunnel or TRANSIENT for
  a tunnel created with a new keypair for this session.
  - Optionally, it can specify a signature type. From now on, it is recommended
  that libraries supporting SAM 3.1 or greater use ed25519 signatures by
  default.
  - When the SAM service replies, it will return a result of either OK
  indicating that the session was established successfully or a string
  indicating the type of error that was encountered. If the session was
  established successfully, the reply will also include the destination keypair
  or the newly established session.
 3. Connections/Messaging
  - Now that you've established a session, you can start making connections
  and/or sending messages.
  - Streaming connections are bi-directional, and can either be connected as
  a client to a server or listened upon to accept connections as a server to a
  client. Predictably, the commands you send to the SAM bridge to set up each
  kind of connection is "STREAM CONNECT" for connections and "STREAM ACCEPT"
  for listeners.
  - Datagrams can be sent after a datagram style session has been established
  by sending datagrams to the socket. They can be repliable and include a return
  address or raw and not include a return address.
  - Once you have created a Streaming connection, any further communication on
  that socket  will be done with I2P, whether it be an HTTP Client, a connection
  between bittorrent peers, or any other kind of Streaming communication.

### Make your Code Re-Usable!

Because of the deliberate similarity to existing streaming and datagram
communications, every language makes it possible to reduce this process to one
or two steps at sensible layers of abstraction. Starting from the most similar,
like a Socket in Java, a connection in Javascript, or a net.Conn in Go. The
actual thing will vary from language to language, but when creating a library,
you should probably start soon.

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

### A Very Simple SAM Client


