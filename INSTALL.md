## How to INSTALL, REMOVE, or UPDATE Alaterm

### Description

Alaterm occupies a lot of device storage, and allows you to run
several programs that are intended for Linux desktop computers.
Among these are GIMP, LibreOffice, Inkscape, and others.
But it does not include multimedia,
which is always handled by other Android services.

Depending on which programs you use,
your device may run short of CPU or memory.
If that happens, then Android will abruptly close Termux,
so that essential Android services continue.
But this is unlikely to happen,
if you work on moderately-sized files, one by one. 


### Device Requirements:

**(a)** Android 8 or later. Tested with Android 9. Reported OK on Android 10.
**(b)** ARM CPU 32 or 64. Includes many tablets, phones, and some Chromebooks.
**(c)** Kernel 4 or later. Recent Android has this.
**(d)** 3GB free space for minimal. 4GB to be useful, 5GB for serious work.
**(e)** Installation must be to on-board storage, not removable media.
**(f)** Use with rooted devices is possible, but discouraged.
**(g)** Termux app, and VNC Viewer app. Available at Google Play or F-Droid.
**(h)** Optional: External keyboard and mouse. Bluetooth works.


### Installation

![Installation is a no-brainer.](no-brainer-install.jpg)

You need **Termux**, and **VNC Viewer**
free apps from Google Play Store (also on F-Droid).

First, get all the files from this repository.
If you use git clone, then you know what to do.

If downloading the ZIP:
You need to transfer the entire ZIP into Termux.
Do not unzip it using Android methods.
The downloaded ZIP is probably in Android Downloads folder.
If it is somewhere else,
use Android file manager to move it to Android Downloads folder.

Launch Termux. Then (one line at a time):

```
pkg update
pkg install gzip
termux-setup-storage
```

Android may show a popup, asking if you will grant Termux access to files.
Allow it. If you deny it, then Termux cannot access the downloaded ZIP.

Then extract the ZIP, assuming it is named alaterm-master.zip:

```
gzip -d alaterm-master.zip
cd alaterm-master
bash 00-alaterm.bash install
```

In some cases, the installer script will be unsure if your device meets specs.
Then it will ask you what to do, before continuing or exiting.

If all good, then you will see a message about Android battery optimization.
The script will wait for your reply, and possibly Android will show a popup.
If you allow Android to (temporarily) stop battery optimization,
then the script may run faster.

Past that point, the script can run by itself without intervention.
It will take 40-60 minutes with a good Internet connection.
While you are waiting, you can use an Android music player,
check your Email, or do some other things.

An Internet problem will cause the script to exit with a problem message.
So, be sure to check what the installer is doing, from time to time.

Maybe you lost connection, or a server is not responding,
or you must shut down your device? No problem.

The installer keeps track of its progress, recorded in a status file.
Simply re-launch `bash 00-alaterm.bash install`
to continue from where you interrupted.


### Where does it go?

Termux home directory is Android **/data/data/com.termux/files/home**

Termux software directory ($PREFIX) is **/data/data/com.termux/files/usr**

The default Alaterm installation is **/data/data/com.termux/alaterm**

So, as seen from Termux, Alaterm is installed to **$PREFIX/../../alaterm**

The Alaterm home directory, seen from Termux: **$PREFIX/../../alaterm/home**


### Removing Alaterm

Since Alaterm does not affect the operation of anything else,
a good working installation should be left in place,
unless your device is running low on storage and you do not need Alaterm.

To remove Alaterm, launch Termux, then:

```
bash 00-alaterm.bash remove
```

You will be asked for confirmation, twice.


### Cleaning Termux, but retaining Alaterm

WARNING: If you uninstall the Termux app, you will lose all of Alaterm!
Re-installing Termux does not restore a prior installation of Alaterm.

The Alaterm installation directory is **not** in the Termux home folder.
So, you can clean out everything in Termux home (even dotfiles),
without losing Alaterm.

You can also clean out the Termux **/usr** directory, without losing Alaterm.
Perhaps you did some experimental coding in Termux, and caused a problem?
You can restore Termux to its factory state. In Termux (not Alaterm), command:

```
rm -rf $PREFIX
```

Then exiting and re-launching Termux will restore its original code.
Be sure to update it. Alaterm is unaffected.


### Updating Alaterm

Alaterm installs and configures software provided by Arch Linux ARM.
From time to time, Alaterm configuration is improved.

To update Alaterm, simply re-run `bash 00-alaterm.bash install`
using the latest scripts (not a saved copy).

That does not re-install Alaterm.
It detects that you already have an installation,
then re-configures a few files, if necessary.

NOTE: Updating Alaterm does **not** update programs such as GIMP.
It only updates the Alaterm configuration files.
To update installed programs, launch Alaterm, then:

```
pacman -Syu
```


### Description of the install process

**1.** Your device should be plugged into a power supply, or fully charged.
Installation may take 40-60 minutes, and consumes a lot of power.

**2.** The installer records its progress in a status file.
If you are interrupted, perhaps because you must shut down your device
or because you lost Internet connection, then re-launch the installer.
It will resume where it left off.

**3.** Your device is examined for compatibility.
In most cases, the result is accept or reject.
If a device is accepted, progress continues automatically.
In some marginal cases, you will be asked whether or not you wish to install.

**4.** The installer requests a wakelock.
Android may ask if you will allow it to stop battery optimization.
You may allow or deny. Installation may complete faster if you allow.
Battery optimization is restored when the script completes or fails.

**5.** A large archive is downloaded from the Arch Linux ARM project.
It is about 450MB. After download, its md5sum is checked.

**6.** The archive is unpacked into **proot** subsystem of Termux.
This is a virtual machine, which does not require root access.

**7.** The existing Arch Linux ARM files are updated.
Language is chosen, based on earlier test of your device language settings.
During the update, you may see errors or messages regarding
attempts to re-create the kernel, or access the bus. Ignore them.
As long as the installer continues, all is good.
Alaterm does not use the Arch kernel.
It relies on the Android kernel, which is unknown to Arch.

**8.** The *sudo* program is installed and configured.
Then a new user is created, with administrator privileges within Alaterm.
This does **not** grant any new privileges outside of Alaterm.

**9.** The script logs in as the new user.
It downloads and installs the LXDE graphical desktop. Download is large.

**10.** The installer creates or edits various files,
to configure the desktop and its pre-installed software.
This provides a "just works" experience,
without the need for further configuration.

**11.** The installer logs out of Alaterm,
and creates a launch script for Termux.
Termux displays information regarding how to launch Alaterm.


### Using Alaterm

The Termux command is **alaterm**.
Login as username *user* and password *password* are applied automatically.

When Alaterm is launched, the command prompt changes,
so you know that you are in Alaterm.
Adding and updating software is done via the command line.
Some programs can also be run via command line.

The best programs, such as GIMP and LibreOffice, require a graphical desktop.
It is already installed and configured, but you need the VNC Viewer to see it.

Keep the command window running.
Open the VNC Viewer app.

The first time you open VNC Viewer,
you will see a short slide show, describing its features.
When that finishes, you may dismiss the side-panel at screen left (if there).
VNC has professional business features that are not relevant for you.

Click the + at bottom left, to add a new connection.
The connection is at 127.0.0.1:5901 and may be named anything you like.

The password is *password* and you should save it.
There is no need for a more secure password.

The new address will appear as a large square icon
(might be black now, later will change).
Click on it. Then connect.

The LXDE Desktop will appear. It is managed by Alaterm.
You may see a red bar on the screen,
informing you that the connection is insecure.
After a few moments, the red bar will disappear.

Depending on your device, you may see an Android system overlay
at top and bottom of the screen.
If your system is like mine, there is a thumbtack icon.
Toggle the thumbtack to keep the overlay always on, or to have it only appear
when you sweep from top or bottom of the screen.

In the lower left corner of LXDE there are two small icons.
At left is the Menu. Click to open its submenus.
Works just like on a desktop computer.
The Menu includes HELP, locally installed.

Notice that the Menu does **not* offer logout.
You do not logout via LXDE Desktop.
Instead, you logout from the command-line Terminal.
That will also disconnect you from VNC Viewer.
Closing VNC Viewer is a separate operation.

Next to the Menu is the icon that opens the File Manager (named PCManFM).
You can navigate through accessible folders.
Right-click works for context menu, if you are using a mouse.

Parts of the Android file system are not accessible to Alaterm.
This is due to normal Linux file permission restrictions.
Likewise, apps other than Termux cannot look into Alaterm.
On the PCmanFM you will see a shortcut **Android Shared**.
That is where you can transfer files into or out of Alaterm.
There is also a shortcut to removable media, if you have any;
but the name of the media is obscure, so you will have to hunt around.
Alaterm cannot mount any media unless it is already mounted by Android.

### Installing more software

Alaterm comes with some utility programs, but not big programs.
To install a package such as GIMP, from within Alaterm:

```
pacman -S gimp
```

For LibreOffice, you have the choice of the stable (still)
or leading-edge (fresh) version.
Both of them work. To install the fresh version:

```
pacman -S libreoffice-fresh
```

However, do **not** install Java capability.
Android itself uses Java (or, a language similar to Java).
There might be conflicts.

The included HELP file, accessible from the LXDE Menu, tells you more.


### Mouse? Touchscreen?

The LXDE Desktop understands both touchscreen and mouse.
With mouse, it understands left-click, right-click, and double-click.

If you are using the touchscreen without mouse:
The cursor is moved by sliding.
Your finger does not have to be atop the cursor position.
When the cursor gets to where you want it to be,
tap anywhere on the screen to activate.


### Software availability

Please understand that Alaterm does not provide software.
All it does is install software provided by the Arch Linux ARM project.

Among the programs known to work are: GIMP, LibreOffice, Inkscape,
TexWorks (TeXLive), Evince, NetSurf, FontForge, and a few others.

Among the programs known NOT to work are Firefox (and most browsers),
Audacity, Totem, and many others requiring system services denied by Android.

Without hacking, you will not be able to use audio programs,
even if the software can be installed.
This is because Android always handles audio, but the Arch Linux ARM software
is unable to communicate with the Android sound system.

You do not need to manage Internet or Bluetooth from Alaterm.
This is done by Android at all times.

If Android cannot access a device (such as an external hard drive)
via its own File Manager, then Alaterm will not be able to access the device.

A discussion of useful programs, and how to install them,
is provided in the HTML help files installed within Alaterm.
Or, you can read them in plain text at this GitHub project page.


### Bug reports

If you have a software request,
or found a software bug in an installed program,
**do not** report it here.
Instead, report it at the project page for the particular program.

If you found a bug in the Alaterm installation script,
then **do** report it here.
Create an issue, and be sure to answer the questions in the bug report form.

Alaterm is not configured for multimedia. Absence of audio is not a bug.

Alaterm is not a pentest suite. Just forget about it.
