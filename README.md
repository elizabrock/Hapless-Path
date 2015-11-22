# Hapless Path
This is the combined capstone from my Advanced Databases and Programming Language Paradigms classes, circa April 2008.

## Running Hapless Path

1. Install Haskell
2. ??
3. Profit.

I'm actually still trying to puzzle through getting HAppS to run, but it starts with reverse-engineering a time capsule.

### Reverse-Engineer a Time Capsule

*The Goal*: Install [HAppS-Server 0.9.3](http://hackage.haskell.org/package/HAppS-Server-0.9.3)

00. Install Ubunutu 12.04 i386
01. Install [libgmp.so.3](http://packages.ubuntu.com/precise/libgmp3c2)
  * `sudo apt-get install libgmp3c2`
, as per [these instructions](http://unix.stackexchange.com/a/119948/19466). Then `cd /usr/local/lib/x86_64-linux-gnu`, `sudo ln -s /usr/lib/libgmp.so.3 libgmp.so`
02. Install [GHC 6.10.1 x86_64](https://www.haskell.org/ghc/download_ghc_6_10_1), following the instructions in INSTALL.
  01. `./configure`
  02. `sudo make install`
03. Restart your terminal
04. Read the notes (below), then install the packages (farther below).

Using `cabal install` was not a winner for me, since Haskell package maintainers didn't (don't?) have the paranoia level of Rubyists (e.g. requiring hslogger >= 1.0.2, as if version 6 was never going to happen)

Haskell packages are installed via.:
  * Download the package from [Hackage](http://hackage.haskell.org/)
  * Untar the pacakge and `cd` into the untarred directory
  * `ghc --make Setup && ./Setup configure && ./Setup build && sudo ./Setup install`

To see which packages are already installed:
  * `ghc-pkg list`

If you get an error about `-lgmp` or `libgmp`:
  * `ld -lgmp --verbose` (to find out where it's looking for the so)
  * `sudo ln -s \usr\lib\libgmp.so.3 \usr\lib\libgmp.so` (with one of the places its looking being the argument on the right.)
  * Try again

Installation Order, with dependencies noted:

* hslogger 1.0.7 (should have been 1.0.2, though) (>=1.0.2)
* HAppS-Util 0.9.3 (>=0.9.2)
  * hslogger (>=1.0.2)
* binary 0.4.1
* HaXml 1.13.3 (==1.13.*)
* syb-with-class 0.4 (>=0.4)
* HAppS-Data 0.9.3 (>=0.9.2)
  * binary
  * HAppS-Util (>=0.9.3)
  * HaXml (==1.13.*)
  * syb-with-class (>=0.4)
* hspread 0.3.1 (should have been 0.3, though) (>=0.3)
* HAppS-State 0.9.3 (>=0.9.2)
  * binary
  * HAppS-Data (>=0.9.3)
  * HAppS-Util (>=0.9.3)
  * HaXml (==1.13.*)
  * hslogger (>=1.0.2)
  * hspread (>=0.3)
* HAppS-IxSet 0.9.3 (>=0.9.2)
  * HAppS-Data (>=0.9.3)
  * HAppS-State (>=0.9.3)
  * HAppS-Util (>=0.9.3)
  * hslogger (>=1.0.2)
  * syb-with-class
* * HTTP 3001.1.3 (should have been 3001.0.4)
* HAppS-Server 0.9.3
  * HAppS-Data (>=0.9.2)
  * HAppS-IxSet (>=0.9.2)
  * HAppS-State (>=0.9.2)
  * HAppS-Util (>=0.9.2)
  * HaXml (==1.13.*)
  * hslogger (>=1.0.2)
  * HTTP

### Compiling the Server

???

### Running the Server

???
