susc
====

Simplest Useful SAM Streaming Client.

This isn't intended to be very "good" right now, but rather to illustrate the
simplest ways the concepts of SAM map onto it's clearnet equivalents. It's been
created as a set of examples for Def Con 27. When it's done being a basic
example it might become a socket library, but probably not. sam3 is better.

A simple TCP client
-------------------

::

       package susc
       import (
           "encoding/base32"
           "encoding/base64"
           "encoding/binary"
           "net"
       )
       // Client: A SAM Client is just a socket once it's set up.
       type Client struct {
           *net.TCPConn
       }
       // I2P uses a slightly altered base64 alphabet. You will need to customize your
       // encoder to use it.
       var (
           i2pB64enc *base64.Encoding = base64.NewEncoding("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-~")
           i2pB32enc *base32.Encoding = base32.NewEncoding("abcdefghijklmnopqrstuvwxyz234567")
       )
       // NewClient: To create a new client, create a TCP Connection to a SAM Service.
       func NewClient() (*Client, error) {
           //var err error
           var c Client
           // The default SAM address is localhost:7656
           samaddr, err := net.ResolveTCPAddr("tcp", "127.0.0.1:7656")
           if err != nil {
               return nil, err
           }
           // When you create your client, establish your connection to SAM.
           c.TCPConn, err = net.DialTCP("tcp", nil, samaddr)
           if err != nil {
               return nil, err
           }
           return &c, nil
       }
       // Base64 returns the base64 destination of the tunnel from the full destination.
       // It's very helpful for SAM libraries to include a function like this even
       // though it's not part of the spec
       func Base64(destination string) string {
           if destination != "" {
               // Decode the base64 string to it's binary form
               s, _ := i2pB64enc.DecodeString(destination)
               // Take the length bits from the binary representation
               alen := binary.BigEndian.Uint16(s[385:387])
               // take the first 387 bits, + the length reported by the length bits,
               // from the binary representation and re-encode it to base64.
               return i2pB64enc.EncodeToString(s[:387+alen])
           }
           return ""
       }


.. raw:: html

   <div style="page-break-after: always;"></div>


.. raw:: pdf

    PageBreak oneColumn
A function to send commands
---------------------------

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


.. raw:: html

   <div style="page-break-after: always;"></div>


.. raw:: pdf

    PageBreak oneColumn
A reply parser
--------------

::

       package susc
       import (
           "fmt"
           "strings"
       )
       // Reply is a structure that represents a reply to the SAM bridge for
       // convenience sake
       type Reply struct {
           Topic string
           Type  string
           Pairs map[string]string
       }
       // ParseReply takes a string reply from the SAM bridge and turns it into a Reply
       // object for later use.
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


.. raw:: html

   <div style="page-break-after: always;"></div>


.. raw:: pdf

    PageBreak oneColumn
Do the handshake
----------------

::

       package susc
       import (
           "fmt"
       )
       // Hello does the handshake with the SAM bridge
       func (c *Client) Hello() error {
           reply, err := c.Command("HELLO VERSION MIN=3.0 MAX=3.2\n")
           if err != nil {
               return err
           }
           if reply.Topic != "HELLO" {
               return fmt.Errorf("Unknown Reply: %+v\n", r)
           }
           if reply.Pairs["RESULT"] != "OK" {
               return fmt.Errorf("Handshake did not succeed\nReply:%+v\n", r)
           }
           return nil
       }


.. raw:: html

   <div style="page-break-after: always;"></div>


.. raw:: pdf

    PageBreak oneColumn
Establish a session
-------------------

::

       package susc
       import (
           "fmt"
       )
       // CreateStreamSession: finally creates a streaming session. You can now use
       // your socket.
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
           result := r.Pairs["RESULT"]
           if result != "OK" {
               return "", fmt.Errorf("Reply error")
           }
           return r.Pairs["DESTINATION"], nil
       }


.. raw:: html

   <div style="page-break-after: always;"></div>


.. raw:: pdf

    PageBreak oneColumn
Create a connection
-------------------

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
           result := r.Pairs["RESULT"]
           if result != "OK" {
               return fmt.Errorf("Reply Error")
           }
           return nil
       }


.. raw:: html

   <div style="page-break-after: always;"></div>


.. raw:: pdf

    PageBreak oneColumn
