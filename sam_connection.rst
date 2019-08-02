Connections/Messaging
~~~~~~~~~~~~~~~~~~~~~

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
