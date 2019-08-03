Considerations for embedding an I2P router
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While flexible, this method requires somewhat more preparation and consideration
than relying on an external I2P router.

1. You will need to compile the parts of the router you want into your
   application.
2. You will need to periodially update your I2P router source code in order
   to update the i2p router embedded in your application.
3. You will need to store your configuration and some information about the
   network and the router.
4. You may wish to disable the Floodfill status in your embedded router. This
   is fine.
5. You may wish to disable participating traffic in your embedded router. In
   most cases, we would rather you not do this.
6. YOu should allow the user to rely on an I2P router that is already
   installed on the system if one is present, so the user doesn't have to
   effectively

For more information, see the embedding guide: http://i2p-projekt.i2p/en/docs/applications/embedding
