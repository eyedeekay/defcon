
### Handshake

  - This is done so that you can negotiate the features of your SAM client with
  the SAM service.
  - First, establish a socket connection to the I2P router's SAM Port.
  - From the client, it's a simple "HELLO" message which can contain optional
  version and authentication information.
  - When the server replies, it will respond with OK and the maximum supported
  SAM version.
