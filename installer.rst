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
this case because we already determines that I2P was not installed, and it is
**ONLY** in this example in this way because 0.9.42 isn't out yet.
