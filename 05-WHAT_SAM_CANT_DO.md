Two big things, and one little thing, that SAM can't do and how to easily forget about them
-------------------------------------------------------------------------------------------

### Tell you that an I2P router is running when SAM is not enabled



### Adjust the I2P Router's settings



#### Natively use an outproxy

Outproxy is a concept primarily known to i2ptunnel, and with i2ptunnel,
primarily known to the HTTP and SOCKS proxies. SAM doesn't consider outproxying
at all on it's own. If you are using SAM and want to access the clear net, you
may wish to use an additional anonymizer when handling clearnet traffic, or
offer a "Bridged" mode which is not anonymous but which is useful for bringing
content to anonymous users

That said, since SAM connections can be used like their non-anonymous
counterparts, it is actually very simple to use SAM to build an out-proxy. While
this technique hasn't been used yet, and it would require careful considerations
for the anonymity of the applications, there are cases where a SAM-based
outproxy would be useful to incorporate into an application. One such
application would be a peer-to-peer CDN which bridges I2P and clearnet
content.
