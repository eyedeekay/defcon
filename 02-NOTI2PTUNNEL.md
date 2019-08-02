
### But Why Not Just Tell Users to Set Up I2PTunnel via the existing WebUI?

I2Ptunnel is good at forwarding existing services to I2P, and it can concievably
be used for many applications. It does provide a SOCKS proxy after all. However,
setting up i2ptunnels is an involved process, with lots of settings that are
intimidating to your users. Using SAM, you set up the connections and apply all
the options inside the application itself, **giving you the all-important**
**oppourtunity to set up sane defaults** on behalf of your users.

A good example can be found in applications that are federated with Activitypub.
While I2Ptunnel is perfectly capable of making AP applications available over
I2P, not many new users will correctly configure the AP-based service correctly
on their first try. The process of setting up connections, deciding whether or
not to "Bridge" clearnet connections or remain strictly anonymous, deciding
tunnel length and the number of tunnels in your destination "Pool," and most
other I2P connection-related functions.
