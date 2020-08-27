Alaterm:file=$alatermTop/usr/local/README

##### /usr/local/README

Directory /usr/local is empty when unpacked from the Arch archive.
The Alaterm installer added directories and files.

This directory is required. You may add to it, but not delete it.
Alaterm PATH begins with /usr/local/scripts:/usr/local/bin
so anything in /usr/local/bin over-rides /usr/bin, which is same as /bin.
Anything in /usr/local/scripts over-rides them all.


##### About /usr/local/scripts

Directory /usr/local/scripts contains several useful bash scripts.
Some are automatically run when Alaterm starts, or when pacman is used.
Others can be run when you need them, if ever.
You may add custom scripts, if you wish.

If you need to over-ride the scripts, do not remove or edit them,
because they may be refreshed at a future update.
Instead, create a new folder, such as ~/bin, in your home.
Then prepend it to PATH and export PATH, in your !/.bashrc file.
It will take effect at next login.


##### About /usr/local/help-alaterm

Directory /usr/local/help-alaterm contains ordinary html files and images.
Within Alaterm, they are read by the NetSurf browser.
If you wish, you may copy the entire help-alaterm directory
to a location where Android File Manager can see it.
Then you can read the help files without launching Alaterm or Termux,
using your Android web browser.


##### About PATH

In Alterm version 2, Termux PATH is not appended to Alaterm PATH.
You may manually append it, at your own risk. Results unpredictable.
If you do append it, then Alaterm must be prevented from accessing
certain Termux commands such as pkg and apt.
Directory /usr/local/bin contains fake executables for such programs.

If you install TeXLive in Alaterm, using the TUG online installer rather
than pacman, you should allow it to create softlinks in /usr/local/bin.

If you compile source code, it may install to /usr/local/bin and
create other /usr/local directories.
Note that Alaterm environment variables are different from those in Termux.
Also, support structure, such as libc6.so, may be incompatible.
If you need to build something for Termux, use the Termux native compiler.

