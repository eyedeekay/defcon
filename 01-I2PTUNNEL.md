
[I2PTunnel](https://geti2p.net/en/docs/api/i2ptunnel)
---------

Java applications can also embed their own instances of I2PTunnel in order to
use it to set up I2P tunnels. However, even non-java applications can take
advantage of drop-in configuration of I2Ptunnel via i2ptunnel.config.d in the
Java i2p router, or tunnels.conf.d in the C++ i2P router. In this way, regular
clear-web applications can provide alternate configurations that automatically
configure their I2P tunnels. If you ship i2ptunnel.config.d files, then any
application can be turned into an I2P application without necessarily requiring
any modification to the application's code.

 - https://geti2p.net/en/docs/api/i2ptunnel
