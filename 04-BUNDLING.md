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

### Kicking off a child installer with NSIS

``` NSIS
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
```
