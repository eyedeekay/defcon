Bundling an I2P Router with your SAM Application
------------------------------------------------

Sometimes, the details of setting up your SAM application require you to know
whether an I2P router is present and ready to accept SAM connections or not. As
of release 0.9.42 in a few weeks, this becomes a very easy problem to solve.
Let's take a slightly complicated case as an example, a non-JVM, non-plugin
application for Windows.

Since there's a good chance your SAM Application is in a non-Java, non-JVM
language, it may be difficult or impossible to build as a plugin for the I2P
router. If that's the case, then we can't *assume* a router is there.

Since this is a Windows machine, we can't *assume* that a package manager is
available with a viable I2P router to install. If that's the case, we'll have to
install our own.

Kicking off a child installer with NSIS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

One common way of creating a Windows installer for an application is to use
Nullsoft Scriptable Install System. NSIS has the ability to do two essential
things. First, it can check for the existence of the file, and second, it can
start a new Windows application, and that application can be the I2P installer
package.

.. code:: NSIS

   Section "GetI2P"
     SetOutPath $INSTDIR
       IfFileExists "$PROGRAMFILES\i2p\i2p.exe" endGetI2P beginGetI2P
       Goto endGetI2P
     beginGetI2P:
       MessageBox MB_YESNO "Your system does not appear to have i2p installed.$\n$\nDo you wish to install it now?"
       File "i2pinstaller.exe"
       ExecWait "$INSTDIR\i2pinstaller.exe"
       SetOutPath "$PROGRAMFILES\i2p"
       File "clients.config"
       SetOutPath "C:\\ProgramData\i2p"
       File "clients.config"
       SetOutPath "$AppData\I2P"
       File "clients.config"
     endGetI2P:
   SectionEnd

As you can see, after the i2pinstaller.exe is done running, a clients.config
file is copied to the I2P application data directory. We can **ONLY** do it in
this case because we already determines that I2P was not installed.

Wait, how can I make sure the router I am bundling is current?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Well here's how I once did it in a Makefile:

.. code:: Make

   # geti2p is an alias for i2pinstaller.exe
   geti2p: i2pinstaller.exe

   # This downloads the I2P installer using the url composed by the 'make url'
   # target.
   i2pinstaller.exe: url
       wget -c `cat geti2p.url` -O i2pinstaller.exe

   # This fetches an RDF listing of I2P versions from launchpad and looks for
   # the most recent stable version. Using this information, it then constructs
   # a URL to download the Windows I2P router installer from Launchpad.
   url:
       echo -n 'https://launchpad.net' | tee .geti2p.url
       curl -s https://launchpad.net/i2p/trunk/+rdf | \
           grep specifiedAt | \
           head -n 3 | \
           tail -n 1 | \
           sed 's|                <lp:specifiedAt rdf:resource="||g' | \
           sed 's|+rdf"/>||g' | tee -a .geti2p.url
       echo -n '+download/i2pinstall_' | tee -a .geti2p.url
       curl -s https://launchpad.net/i2p/trunk/+rdf | \
           grep specifiedAt | \
           head -n 3 | \
           tail -n 1 | \
           sed 's|                <lp:specifiedAt rdf:resource="/i2p/trunk/||g' | \
           sed 's|/+rdf"/>||g' | tee -a .geti2p.url
       echo '_windows.exe' | tee -a .geti2p.url
       cat .geti2p.url | tr -d '\n' | tee geti2p.url
       rm -f .geti2p.url

Wait, what if I don't want to make my clients install a JVM?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Enter Jlink, i2pd TODO

Wait, how to I finally make sure that it has the SAM API enabled?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use clients.config.d TODO
