## How to INSTALL, REMOVE, or UPDATE alaterm

### Description

Alaterm occupies a lot of device storage, and allows you to run
several programs that are intended for Linux desktop computers.
Among these are GIMP, LibreOffice, Inkscape, and others.
But it does not include multimedia, which is always handled by other Android services.

Depending on which programs you use, your device may run short of CPU or memory.
If that happens, then Android will abruptly close Termux, so that essential Android services continue.
But this is unlikely to happen, if you work on moderately-sized files, one by one. 


### Device Requirements:

**(a)** Android 8 or later. Tested with Android 9. Reported OK on Android 10.
**(b)** ARM CPU 32- or 64-bit. Includes many tablets, phones, and some Chromebooks.
**(c)** Kernel 4 or later. You almost certainly have this, with recent Android.
**(d)** 3GB free space for minimal setup. 4GB to be useful, 5GB for serious work.
**(e)** Installation must be to on-board storage. Cannot install to removable media.
**(f)** Use with rooted devices is possible, but discouraged.
**(g)** Termux app, and VNC Viewer app. Available at Google Play or F-Droid.
**(h)** Optional: External keyboard and mouse. Bluetooth works.


### Preparation

You need **Termux**, and **VNC Viewer** free apps from Google Play Store (also on F-Droid).

Launch Termux. Then (one line at a time):

```
pkg update
pkg install wget
wget https://raw.githubusercontent.com/cargocultprog/alaterm/master/00-alaterm.bash
bash 00-alaterm.bash install
```

File 00-alaterm.bash will fetch the remaining scripts from GitHub.
But if you are installing from a downloaded zip file, then the local scripts will be used.

In most cases, that is all you need to do.
It will take 40-60 minutes with a good Internet connection.
While you are waiting, you can use an Android music player, check your Email, or do some other things.

In some cases, the installer script will be unsure if your device meets specs.
Then it will ask you what to do, before continuing or exiting.
In other cases, an Internet problem will cause the script to exit with a problem message.
So, be sure to check what the installer is doing, from time to time.

You can halt the installer at any time, if you lost Internet connection, or must shut down your device.
If you halt the installer, or if it exits by itself, no problem.
You do not lose the portion that was already completed.
The script remembers where it halted, and will resume from there.

After succesful completion, all scripts except 00-alaterm.bash will be automatically deleted.

Termux home directory is Android **/data/data/com.termux/files/home**.
Termux software directory is **/data/data/com.termux/files/usr**, which Termux names as **$PREFIX**.
The default alaterm installation is **/data/data/com.termux/alaterm**.
So, within Termux, alaterm is installed to **$PREFIX/../../alaterm**.


### Removal

Since alaterm does not affect the operation of anything else,
a good working installation should be left in place,
unless your device is running low on storage and you do not need alaterm.

To remove alaterm, launch Termux, then:

```
bash 00-alaterm.bash remove
```

You will be asked for confirmation, twice.


### Cleaning Termux, but retaining alaterm

WARNING: If you uninstall the Termux app, you will lose all of alaterm!
Re-installing Termux does not restore a prior installation of alaterm.

The standard alaterm installation directory is **not** in the Termux home folder.
So, you can clean out everything in Termux home (even dotfiles), without losing alaterm.

You can also clean out the Termux **/usr** directory, without losing alaterm.
Perhaps you did some experimental coding in Termux, and caused a problem there?
You can restore Termux to "factory":

```
rm -rf $PREFIX
```

Then exiting and re-launching Termux will restore its original code. Be sure to update it.
Alaterm is unaffected.


### Updating alaterm

Alaterm installs and configures software provided by the Arch Linux ARM project.
From time to time, alaterm configuration is improved.

To update alaterm, simply re-run `bash 00-alaterm.bash install`
using the latest scripts (not a saved copy).

That does not re-install alaterm.
It detects that you already have an installation, then re-configures a few files, if necessary.

NOTE: Updating alaterm does **not** update programs such as GIMP.
It only updates the alaterm configuration files.
To update installed programs, launch alaterm, then:

```
pacman -Syu
```


### Description of the install process

1. Your device should be plugged into a power supply, or fully charged.
Installation may take 40-60 minutes, and consumes a lot of power.

2. The installer records its progress in a status file.
If you are interrupted, perhaps because you must shut down your device
or because you lost Internet connection, then re-launch the installer.
It will resume where it left off.

3. Your device is examined for compatibility.
In most cases, the result is accept or reject.
If a device is accepted, progress continues automatically.
In some marginal cases, you will be asked whether or not you wish to install.

4. The installer requests a wakelock.
Android may ask if you will allow it to stop battery optimization.
You may allow or deny. Installation may complete faster if you allow.
Battery optimization is restored when the script completes or fails.

5. A large archive is downloaded from the Arch Linux ARM project.
It is about 450MB. After download, its md5sum is checked.

6. The archive is unpacked into **proot** subsystem of Termux.
This is a virtual machine, which does not require root access.

7. The existing Arch Linux ARM files are updated.
Language is chosen, based on earlier test of your device language settings.
During the update, you may see errors or messages regarding
attempts to re-create the kernel, or access the bus. Ignore them.
As long as the installer continues, all is good.
Alaterm does not use the Arch kernel. It relies on the Android kernel, which is unknown to Arch.

8. The *sudo* program is installed and configured.
Then a new user is created, with administrator privileges within alaterm.
This does **not** grant any new privileges outside of alaterm.

9. The script logs in as the new user.
It downloads and installs the LXDE graphical desktop. Download is large.

10. The installer creates or edits various files,
to configure the desktop and its pre-installed software.
This provides a "just works" experience, without the need for further configuration.

11. The installer logs out of alaterm, and creates a launch script for Termux.
Termux displays information regarding how to launch alaterm.


### Using alaterm

The default Termux command is **alaterm**.
Login as username *user* and password *password* are applied automatically.

When alaterm is launched, the command prompt changes, so you know that you are in alaterm.
Adding and updating software is done via the command line.
Some programs can also be run via command line.

The best programs, such as GIMP and LibreOffice, require a graphical desktop.
It is already installed and configured, but you need the VNC Viewer to see it.

Keep the command window running.
Open the VNC Viewer app.

The first time you open VNC Viewer, you will see a short slide show, describing its features.
When that finishes, you may dismiss the side-panel at left of screenj (if it is there).
VNC has professional business features that are not relevant for you.

Click the + at bottom left, to add a new connection.
The connection is at 127.0.0.1:5901 and may be named anything you like.

The password is *password* and you should save it.
There is no need for a more secure password.

The new address will appear as a large square icon (might be black now, later will change).
Click on it. Then connect.

The LXDE Desktop will appear. It is managed by alaterm.
You may see a red bar on the screen, informing you that the connection is insecure.
After a few moments, the red bar will disappear.

Depending on your device, you may see an Android system overlay
at top and bottom of the screen. If your system is like mine, there is a thumbtack icon.
Toggle the thumbtack to keep the overlay always on, or to have it only appear
when you sweep from top or bottom of the screen.

In the lower left corner of LXDE theree are two small icons.
At left is the Menu. Click to open its submenus. Works just like on a desktop computer.
The Menu includes HELP, locally installed.

Notice that the Menu does **not* offer logout. You do not logout via LXDE Desktop.
Instead, you logout from the command-line Terminal.
That will also disconnect you from VNC Viewer.
Closing VNC Viewer is a separate operation.

Next to the Menu is the icon that opens the File Manager (named PCManFM).
You can navigate through accessible folders.
Right-click works for context menu, if you are using a mouse.

Parts of the Android file system are not accessible to alaterm.
This is due to normal Linux file permission restrictions.
If you create or edit a file in alaterm, and wish to make it accessible to other Android apps,
then be sure to move or copy it to where those other apps can see it.
They cannot look into your alaterm (or Termux) home folder.


### Installing more software

Alaterm comes with some utility programs, but not big programs.
To install a package such as GIMP, from within alaterm:

```
pacman -S gimp
```

For LibreOffice, you have the choice of the stable (still) or leading-edge (fresh) version.
Both of them work. To install the fresh version:

```
pacman -S libreoffice-fresh
```

However, do **not** install Java capability.
Android itself uses Java (or, a language similar to Java). There might be conflicts.

The included HELP file, accessible from the LXDE Menu, tells you more.


### Mouse? Touchscreen?

The LXDE Desktop understands both touchscreen and mouse.
With mouse, it understands left-click, right-click, and double-click.

If you are using the touchscreen without mouse: The cursor is moved by sliding.
Your finger does not have to be atop the cursor position.
When the cursor gets to where you want it to be, tap anywhere on the screen to activate.


### Software availability

Please understand that alaterm does not provide software.
All it does is install software provided by the Arch Linux ARM project.

Among the programs known to work are: GIMP, LibreOffice, Inkscape, TexWorks (TeXLive),
Evince, Netsurf, FontForge, and a few others.

Among the programs known NOT to work are Firefox (and most browsers), Audacity, Totem,
and many others that require system services denied by Android.

You will not be able to use programs that require audio, even if the software can be installed.
This is because Android always handles audio, but the Arch Linux ARM software
is unable to communicate with the Android sound system. This cannot be fixed.

You do not need to manage Internet or Bluetooth from alaterm.
This is done by Android at all times.

If Android cannot access a device (such as an external hard drive) via its own File Manager,
then alaterm will not be able to access the device.

A discussion of useful programs, and how to install them,
is provided in the HTML help files installed within alaterm.
Or, you can read them in plain text at this GitHub project page.


### Bug reports

If you have a software request, or found a software bug, **do not** report it here.

If you found a bug in the alaterm installation script, then **do** report it here.

Alaterm cannot be configured for multimedia. Absence of audio is not a bug.

