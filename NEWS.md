### NEWS for Alaterm at GitHub.

#### UPDATE

August 28, 2020: Version 2 installer.

Same Alaterm after installation, but scripts have been rewritten.
The new code is more easily read and maintained. 

If you already installed Alaterm using version 1 scripts,
there is nothing to do. Version 2 is not an update to version 1.

#### REMINDERS:

To update Termux (not Alaterm):  `pkg update`

To update software within Alaterm:  `pacman -Syu`

To update Alaterm itself, from Termux (not Alaterm):
See the contents of file UPDATE.md for instructions.

If you encounter a problem during installation, and have a GitHub account,
be sure to start an issue on this site. I test my code before uploading,
and it works for me. It has been working for over six months now!
If it does not work for you, the fix is probably
something simple, such as my failure to upload the correct code.

#### August 28, 2020

Version 2.0.0. Scripts re-named and re-coded.

#### August 6, 2020

Version 1.6.0. No longer fetches missing installer files.
All must be downloaded together.

#### July 17-18, 2020

Updated to version 1.4.2. Minor code cleanup. Better permissions.

Note: Version 1.4.2 -b on August 4, 2020. Correction for locale detection.
Does not affect existing installations.

#### June 30, 2020

Updated to version 1.2.8. Minor code cleanup.

#### June 18-24, 2020

Updated to version 1.2.6.

Tweaked the order of PATH to be more standard.

Added ability to auto-detect TeXLive if installed via TUG instead of pacman.
Note: This is removed in subsequent update. Did not work well.

Revised HELP files.

Changed method of free space detection, to accomodate unexpected results.

#### June 6, 2020

Updated to version 1.2.0.
Fixed problem involving Internet connection check, for some users.
Added some code for use only by developer.
Corrected rarely-used vncserver conflicts.

#### June 1-3, 2020

Updated to version 1.1.2. Not much change, mostly code cleanup.

Removed obsolete python2 packages from installation.
Also removed other unnecessary packages.

Note: If you have xfce4 installed in Termux:
During June 2-3, 2020 there was a temporary problem updating Termux itself.
This is not an alaterm issue. It was fixed within Termux on June 4. 

Fixed: Alaterm installation problem, typically with exit code 73.
Problem occurred during some April-May 2020 installation attempts.
Did not affect users with previously completed installation.
Will not affect new installations, started after this date.

IF YOU HAD THIS INSTALLATION PROBLEM, HERE IS THE FIX (updated):
(a) Remove your existing **0n-alaterm.bash** files, for each **n**.
(b) Download fresh scripts to the same directory.
(c) Run bash 00-alaterm.bash install

The fix does not delete the original Arch Linux ARM files, so
you will not have to download and unpack the archive a second time.

#### April 3, 2020

Fixed: Some users saw several messages about "usepacman #" at alaterm launch.
These messages were harmless. Now removed.

Fixed: Prior to this, if you installed Gedit, it would not save preferences.
Now it will save them. Gedit uses dbus for that, but dbus did not autolaunch.
An automatic dbus-launch has been added to the desktop launcher. 

#### March 10, 2020:

Minor enhancement to prevent double-launch.

#### March 4, 2020:

Minor enhancement to detect Termux-alaterm coordination.

#### March 3, 2020:

Initial public release.

#### March 2, 2020:

Beta testers invited. Should work. Maybe some typos to fix.

#### March 1, 2020:

Final stages of alpha testing. Alaterm works on its developer's device,
and has been working for several months. Help files are now being written,
and the scripts are being checked for compatibility when downloaded.

#### February 22, 2020:

GitHub project initialized.

#### Some time in Autumn 2019:

Got Alaterm working on my own machine.
I have been regularly using it since then.
