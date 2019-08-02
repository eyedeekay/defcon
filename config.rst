Wait, how to I finally make sure that it has the SAM API enabled?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now that we're sure an I2P router is installed, we need to make sure that a SAM
API is available to your application to use. Since 0.9.42, all platforms that
use SAM can also use clients.config.d. That way, you can drop a file in to an
I2P router you have just installed or one that exists on the computer already,
without needing to worry about over-writing or otherwise harmfully altering
a potentially sensitive configuation file.
