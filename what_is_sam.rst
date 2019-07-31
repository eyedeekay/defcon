What is SAM
-----------

SAM is a simple API for controlling **connections** on the I2P i2p router in a
way which is familiar to people who write internet applications. To use it, you
simply set up a SAM connection and then use it like a streaming connection or
to send datagrams, either with or without a repliable address. You can use these
connections just like their TCP/IP equivalents for basically every intent or
purpose.

Stages of the SAM Setup process
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Handshake

-  This is done so that you can negotiate the features of your SAM client with
   the SAM service.
-  First, establish a socket connection to the I2P router's SAM Port.
-  From the client, it's a simple "HELLO" message which can contain optional
   version and authentication information.
-  When the server replies, it will respond with OK and the maximum supported
   SAM version.

2. Session Establishment

-  Once your handshake is complete, you need to establish a session with SAM
   to control connections.
-  To create a session, you send a "SESSION CREATE" message which must declare
   the type of connection and messaging you will be doing, a unique name for
   the connection which will allow you to refer to the client, and either a full
   public/private base64-encoded key pair for the local tunnel or TRANSIENT for
   a tunnel created with a new keypair for this session.
-  Optionally, it can specify a signature type. From now on, it is recommended
   that libraries supporting SAM 3.1 or greater use ed25519 signatures by
   default.
-  When the SAM service replies, it will return a result of either OK
   indicating that the session was established successfully or a string
   indicating the type of error that was encountered. If the session was
   established successfully, the reply will also include the destination keypair
   or the newly established session.

3. Connections/Messaging

-  Now that you've established a session, you can start making connections
   and/or sending messages.
-  Streaming connections are bi-directional, and can either be connected as
   a client to a server or listened upon to accept connections as a server to a
   client. Predictably, the commands you send to the SAM bridge to set up each
   kind of connection is "STREAM CONNECT" for connections and "STREAM ACCEPT"
   for listeners.
-  Datagrams can be sent after a datagram style session has been established
   by sending datagrams to the socket. They can be repliable and include a return
   address or raw and not include a return address.
-  Once you have created a Streaming connection, any further communication on
   that socket will be done with I2P, whether it be an HTTP Client, a connection
   between bittorrent peers, or any other kind of Streaming communication.

That all seems pretty complicated written out like that, but it's actually quite
straightforward in practice and what you end up with is just a socket, and you
can do whatever you would do with a regular socket. Applications that use
sockets can usually simply substitute a regular socket for a SAM socket and it
just works. Anything that builds on the socket can be made to build on a SAM
socket, and anything that uses the SAM socketed alternative implementation can
inherit I2P features.

Make your Code Re-Usable!
~~~~~~~~~~~~~~~~~~~~~~~~~

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

susc
====

Simplest Useful SAM Streaming Client.

This isn't intended to be very "good" right now, but rather to illustrate the
simplest ways the concepts of SAM map onto it's clearnet equivalents. It's been
created as a set of examples for Def Con 27. When it's done being a basic
example it might become a socket library, but probably not. sam3 is better.

.. _acceptgo:

accept.go
^^^^^^^^^

::

   package susc

   import (
       "fmt"
   )

   // StreamAccept asks SAM to accept a TCP-Like connection
   func (c *Client) StreamAccept(id int32) (*Reply, error) {
       r, err := c.Command("STREAM ACCEPT ID=%d SILENT=false\n", id)
       if err != nil {
           return nil, err
       }

       // TODO: move check into Command()
       if r.Topic != "STREAM" || r.Type != "STATUS" {
           return nil, fmt.Errorf("Unknown Reply: %+v\n", r)
       }

       result := r.Pairs["RESULT"]
       if result != "OK" {
           return nil, fmt.Errorf("Reply Error")
       }

       return r, nil
   }

.. _clientgo:

client.go
^^^^^^^^^

::

   package susc

   import (
       "net"
           "encoding/binary"
           "encoding/base32"
       "encoding/base64"
   )

   type Client struct {
       *net.TCPConn
   }

   var (
       i2pB64enc *base64.Encoding = base64.NewEncoding("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-~")
       i2pB32enc *base32.Encoding = base32.NewEncoding("abcdefghijklmnopqrstuvwxyz234567")
   )

   func NewClient() (*Client, error) {
       //var err error
       var c Client
       samaddr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:7656")
       if err != nil {
           return nil, err
       }
       c.TCPConn, err = net.DialTCP("tcp", nil, samaddr)
       if err != nil {
           return nil, err
       }
       return &c, nil
   }


   // Base64 returns the base64 of the local tunnel
   func Base64(destination string) string {
       if destination != "" {
           s, _ := i2pB64enc.DecodeString(destination)
           alen := binary.BigEndian.Uint16(s[385:387])
           return i2pB64enc.EncodeToString(s[:387+alen])
       }
       return ""
   }

.. _commandgo:

command.go
^^^^^^^^^^

::

   package susc

   import (
       "bufio"
       "fmt"
   )

   // Command is a helper to send one command and return the reply as a string
   func (c *Client) Command(str string, args ...interface{}) (*Reply, error) {
       if _, err := fmt.Fprintf(c.TCPConn, str, args...); err != nil {
           return nil, err
       }
       reader := bufio.NewReader(c.TCPConn)
       line, _, err := reader.ReadLine()
       if err != nil {
           return nil, err
       }

       return ParseReply(string(line))
   }

.. _connectgo:

connect.go
^^^^^^^^^^

::

   package susc

   import (
       "fmt"
   )

   // StreamTCPConnect asks SAM for a TCP-Like connection to dest, has to be called on a new Client
   func (c *Client) StreamTCPConnect(id int32, dest string) error {
       r, err := c.Command("STREAM CONNECT ID=%d DESTINATION=%s\n", id, dest)
       if err != nil {
           return err
       }

       // TODO: move check into Command()
       if r.Topic != "STREAM" || r.Type != "STATUS" {
           return fmt.Errorf("Unknown Reply: %+v\n", r)
       }

       result := r.Pairs["RESULT"]
       if result != "OK" {
           return fmt.Errorf("Reply Error")
       }

       return nil
   }

.. _hellogo:

hello.go
^^^^^^^^

::

   package susc

   import (
       "fmt"
   )

   func (c *Client) Hello() error {
       r, err := c.Command("HELLO VERSION MIN=3.0 MAX=3.2\n")
       if err != nil {
           return err
       }

       if r.Topic != "HELLO" {
           return fmt.Errorf("Unknown Reply: %+v\n", r)
       }

       if r.Pairs["RESULT"] != "OK" {
           return fmt.Errorf("Handshake did not succeed\nReply:%+v\n", r)
       }

       return nil
   }

.. _readgo:

read.go
^^^^^^^

::

   package susc

   import (
       "bufio"
   )

   func (c *Client) ReadLine() (string, error) {
       reader := bufio.NewReader(c.TCPConn)
       bytes, _, err := reader.ReadLine()
       if err != nil {
           return "", err
       }
       return string(bytes), nil
   }

.. _replygo:

reply.go
^^^^^^^^

::

   package susc

   import (
       "fmt"
       "strings"
   )

   type Reply struct {
       Topic string
       Type  string

       Pairs map[string]string
   }

   func ParseReply(line string) (*Reply, error) {
       line = strings.TrimSpace(line)
       parts := strings.Split(line, " ")
       if len(parts) < 3 {
           return nil, fmt.Errorf("Malformed Reply.\n%s\n", line)
       }

       r := &Reply{
           Topic: parts[0],
           Type:  parts[1],
           Pairs: make(map[string]string, len(parts)-2),
       }

       for _, v := range parts[2:] {
           kvPair := strings.SplitN(v, "=", 2)
           if kvPair != nil {
               if len(kvPair) != 2 {
                   return nil, fmt.Errorf("Malformed key-value-pair.\n%s\n", kvPair)
               }
           }

           r.Pairs[kvPair[0]] = kvPair[len(kvPair)-1]
       }

       return r, nil
   }

.. _sessiongo:

session.go
^^^^^^^^^^

::

   package susc

   import (
       "fmt"
   )

   func (c *Client) CreateStreamSession(id int32, dest, sigtype, options string) (string, error) {
       if dest == "" {
           dest = "TRANSIENT"
       }
       r, err := c.Command(
           "SESSION CREATE STYLE=STREAM ID=%d DESTINATION=%s %s %s\n",
           id,
           dest,
           sigtype,
           options,
       )
       if err != nil {
           return "", err
       }

       // TODO: move check into Command()
       if r.Topic != "SESSION" || r.Type != "STATUS" {
           return "", fmt.Errorf("Unknown Reply: %+v\n", r)
       }

       result := r.Pairs["RESULT"]
       if result != "OK" {
           return "", fmt.Errorf("Reply error")
       }
       return r.Pairs["DESTINATION"], nil
   }

.. _writego:

write.go
^^^^^^^^

::

   package susc

   // Write implements the TCPConn Write method.
   func (c *Client) Write(b []byte) (int, error) {
       return c.TCPConn.Write(b)
   }

