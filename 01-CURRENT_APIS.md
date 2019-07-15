Current and Former I2P API's
============================


```
              I2P Network
                  +   +
                  |   |
                  |   |
        =---------+---+-----------=
        |       I2P Router        |
        =--+--------------------+-=
           |                    |
         =-+-----=            =-+----------=
         | I2CP  |            | I2PControl |
         =-+---+-=            =------------=
           |   |
           | =-+------=    =-------------------=
           | | SAM v3 +----+  SAM APPLICATIONS |
           | =--------=    =-------------------=
           |
         =-+-----=      =-------------------=
         | BOB   +------+  BOB APPLICATIONS |
         =-------=      =-------------------=

```

I2CP
----

I2CP is the core I2P API, it underlies many of the other I2P API's. It is also
the most complex to use outside of Java, but recently several libraries have
emerged that provide partial or full I2CP functionality from other languages.
C, Java, and Javascript libraries are available, as is one Go library with
partial support.

BOB
---

BOB is a less complicated to use API, but it is currently unmaintained. We don't
plan on dropping it soon, but we also have not been adding the new features
that are available in SAM Version 3. Many of the best ideas from the BOB API
have been ported to the more modern SAMv3 API. Our advice is that new
applications should not be using BOB, and that the

SAM Version 1, 2
----------------

Deprecated and for all intents and purposes removed.

I2PControl
----------

I2PControl is a little different. Rather than setting up connections between
I2P applications, it's used for configuring and retrieving information about the
router programmatically.

SAM Version 3
-------------

The current recommended API for applications of all types to communicate via I2P
is the SAMv3 API. It provides a convenient way to set up, communicate through,
and tear down I2P connections. It is designed so that it can implement the API
familiar to your programming language in a simple and straightforward way. For
example, we can implement a Socket in Java or a net.Conn in Go.

SAM will by and large be the focus of this workshop.
