### NEWS for alaterm at GitHub.

#### REMINDER:

To update Termux (not alaterm):  pkg update

To update software within alaterm:  pacman -Syu

To update alaterm itself, from Termux (not alaterm): bash 00-alaterm.bash install

The installer does not re-install, it merely patches. Usually takes only a few seconds.

#### April 3, 2020

Fixed: Some users saw several messages about "usepacman #" at alaterm launch.
These messages were harmless. Now removed.

Fixed: Prior to this, if you installed Gedit, it would not save preferences.
Now it will save them. Gedit uses dbus for that, but dbus would not autolaunch.
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
Final stages of alpha testing. Alaterm certainly works on its developer's device,
and has been working for several months. Currently, help files are being written,
and the scripts are being checked for compatibility when downloaded.

#### February 22, 2020:
GitHub project initialized.
