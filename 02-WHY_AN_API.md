
Which API do You Need?
----------------------

If you need to make connections between applications automatically, then you
need the **SAMv3 API**.

If you need to monitor or adjust the I2P router's connection, bandwidth usage,
or change it's status, then you need the **I2PControl API**.

If you need to set up tunnels for an already-existing Web Application, then
I2Ptunnel, either by embedding it in your application or by placing files into
i2ptunnel.config.d.

If you need to simply check the presence of an I2P router before making
connections, one way is to make a quick connection to the **I2CP API**. If
you're writing a Java application, the I2CP API may also be a good choice.
Besides that, unless you know why you need to use I2CP, you probably just need
SAM.


