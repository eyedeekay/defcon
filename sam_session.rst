Session Establishment
~~~~~~~~~~~~~~~~~~~~~

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
