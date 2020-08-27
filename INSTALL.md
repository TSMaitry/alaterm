## How to INSTALL, REMOVE, or UPDATE Alaterm


### IMPORTANT

Alaterm is now version 2. It uses the files in `v2installer`.
Its main script is `alaterm-installer`.
The prior `00-alaterm.bash` is obsolete.

The new installer can also be used to remove an installation,
whether it was installed by version 1 or 2.

Updates are in folder `v1update` or `v2update`, depending on version.

The scripts auto-detect correct version.
 

### Description

Alaterm installs Arch Linux ARM within the Android Termux app.
Its graphical desktop is viewed with the VNC Viewer app.
The result emulates an ordinary desktop computer, but with some
limitations due to the different technologies.
Among the working programs are GIMP, much of LibreOffice, and others.
However, multimedia programs are not included.

Your device is not intended to be a desktop computer,
so its resources are limited. You may run short of RAM.
If that happens, then Android will abruptly close Termux and Arch,
so that essential Android services continue.
But this is unlikely to happen, if you work on moderately-sized files.
 

### Device Requirements:

1. Android 8 or later. Tested with Android 9. Reported OK on Android 10.

2. ARM CPU 32- or 64-bit. For most tablets and phones, some Chromebooks.

3. Kernel 4 or later. You almost certainly have this, on recent Android.

4. 3GB free space for minimal. 4GB to be useful, 5GB for serious work.

5. Installation must be to on-board storage, not removable media.

6. Use with rooted devices is possible, but discouraged.

7. Termux app, and VNC Viewer app. Available at Google Play or F-Droid.

8. At least 2GB RAM. That is enough for most applications.
However, 3GB is recommended for heavy work with larger files.

9. Optional: External keyboard and mouse. Bluetooth works.


### Installation

You need two free apps, from Google Play Store (also on F-Droid):
**Termux** by Fredrik Fornwall, and **VNC Viewer** by Real VNC.

Optionally, you may add the Termux:API app to enhance Termux features.


##### Experienced Termux users, with git installed:

Navigate to whichever Termux directory you use for git clones. Then:

```
git clone https://github.com/cargocultprog/alaterm

```


##### New Termux users:

While you are at the Alaterm repository web page,
look for the green **Code** button. Touch to open it,
then touch **Download ZIP**. It will download `alaterm-master.zip`
to wherever your browser puts downloads. If it is not the "Downloads"
folder, use Android file manager to move it there. But do not unzip it yet.

Launch Termux. If you are new to Termux, you must first prepare it.
Issue these commands, one at a time. At the second command, Android may
show a popup messages, asking if you will allow Termux to access files.
Allow it:

```
pkg update
termux-setup-storage
```

Move the downloaded zip file into Termux home, and unzip it:

```
mv ~/storage/downloads/alaterm-master.zip ~
gzip -d alaterm-master.zip
```

Navigate to the installer directory, and list its contents:

```
cd alaterm-master/v2installer && ls
```

You should see `alaterm-installer`, among other things.


##### Everyone:

File `alaterm-installer` is used for install or remove.
To get basic information, without action:

```
bash alaterm-installer
```

Now to install Alaterm:

```
bash alaterm-installer install
```

Your device will be checked for the required specifications.
Usually, the result is pass or fail.
In rare cases, the installer will be unsure if your device meets specs.
Then it will ask you what to do, before continuing or exiting.

You may see an Android popup about battery optimization.
Allow it, so the installer may run faster.
If you deny it, then the installer will still work, but more slowly.
In any case, optimization is restored when the script completes or fails.

Past that point, the script can run by itself without intervention.
It will take 40-60 minutes with a good Internet connection.
While you are waiting, you can walk away, or use an Android music player,
or check your Email, or do some other things.

An Internet problem will cause the script to exit with a problem message.
So, be sure to check what the installer is doing, from time to time.

Maybe you lost connection, or a server is not responding,
or you must shut down your device mid-install? No problem.

The installer keeps track of its progress, recorded in a status file.
Simply re-launch `bash alaterm-installer install`
to continue from where you were interrupted.


### Where does it go?

Termux home directory is Android `/data/data/com.termux/files/home`.
Termux software directory is `/data/data/com.termux/files/usr`.
The Alaterm installation is `/data/data/com.termux/alaterm`.


### Removal

Since Alaterm does not affect the operation of anything else,
a good working installation should be left in place,
unless your device is running low on storage and you do not need Alaterm.

To remove Alaterm, launch Termux. Navigate to `alaterm-installer`.
Then:

```
bash alaterm-installer remove
```

You will be asked for confirmation, twice.


### Cleaning Termux, but retaining Alaterm

**WARNING:** If you uninstall the Termux app, you will lose all of Alaterm!
Re-installing Termux does not restore a prior installation of Alaterm.

The Alaterm install directory is **not** in the Termux home folder.
So, you can clean out everything in Termux home, without losing Alaterm.

You can clean out the Termux `$PREFIX` directory, without losing Alaterm.
Perhaps you did some experimental Termux coding, and caused errors there?
No problem. You can restore Termux to its factory state.
In Termux (Not in Alaterm! Not in Alaterm! Not in Alaterm!), command:

```
rm -rf $PREFIX
```

Then exiting and re-launching Termux will restore its original code.
Be sure to update it. Alaterm is unaffected.


### Updating Alaterm

Launch Alaterm, and command: `echo $scriptRevision`.
Compare it to the information in file UPDATE.md at the Alaterm repository.

If there is an update, then get the new ZIP file (or, git pull) the same way
as you did before. The installer is also used for updates.
It does not reinstall, so it runs quickly. It autodetects whether
the update should be for version 1 or 2. Command:

```
bash alaterm-installer install
```

NOTE: Updating Alaterm does **not** update programs such as GIMP.
It only updates the Alaterm configuration files.
To update installed Arch Linux ARM programs, launch Alaterm, then:

```
pacman -Syu
```


### Description of the install process

Your device should be plugged into a power supply, or fully charged.
Installation may take 40-60 minutes, and consumes a lot of power.

1. The installer records its progress in a status file.
If you are interrupted, perhaps because you must shut down your device
or because you lost Internet connection, then re-launch the installer.
It will resume where it left off.

2. Your device is examined for compatibility.
In most cases, the result is accept or reject.
If a device is accepted, progress continues automatically.
In some marginal cases, you will be asked whether or not you wish to install.

3. A large archive is downloaded from the Arch Linux ARM project.
It is about 450MB. After download, its md5sum is checked.

4. The archive is unpacked into a `proot` subsystem of Termux.
This is a virtual machine, which does not require root access.

5. The existing Arch Linux ARM files are updated.
Language is chosen, based on earlier test of your device language settings.
During the update, you may see errors or messages regarding
attempts to re-create the kernel, or access the bus. Ignore them.
As long as the installer continues, all is good.
Alaterm does not use the downloaded Arch kernel.
It relies on your device Android kernel, which is unknown to Arch.

6. The `sudo` program is installed and configured.
Then a new user is created, with administrator privileges within Alaterm.
This does **not** grant any new privileges outside of Alaterm.

7. The script logs in as the new user.
It downloads and installs the LXDE graphical desktop. Download is large.

8. The installer creates or edits various files,
to configure the desktop and its pre-installed software.
This provides a "just works" experience,
without the need for further configuration.

When done, the installer logs out of Alaterm,
and creates a launch script for Termux.
Termux displays information regarding how to launch Alaterm.


### Using Alaterm

The Termux command is `alaterm`.
Login as username *user* with password *password* are applied automatically.

When Alaterm is launched, the command prompt changes,
so you know that you are in Alaterm.
Adding and updating software is done via the command line.
Some programs can also be run via command line.

The best programs, such as GIMP and LibreOffice, require a graphical desktop.
It is already installed and configured, but you need the VNC Viewer to see it.

Keep the Termux command window running.
Open the VNC Viewer app.

The first time you open VNC Viewer,
you may see a short slide show, describing its features.
When it finishes, you may dismiss the side-panel at left of screen (if there).
VNC has professional business features that are not relevant for you.

Click the **+** at bottom left, to add a new connection.
The connection is at `127.0.0.1:5901` and may be named anything you like.

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
when you swipe from top or bottom of the screen.

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
On the PCmanFM you will see a shortcut `Android Shared`.
That is where you can transfer files into or out of Alaterm.
There is also a shortcut to removable media, if you have any;
but the name of the media is obscure, so you will have to hunt around.


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

The included HELP files, accessible from the LXDE Menu, tell you more.


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
Audacity, Totem, and others that require system services denied by Android.

You will not be able to use audio programs,
even if the software can be installed.
This is because Android always handles audio, but the Arch Linux ARM software
is unable to communicate with the Android sound system. This can be hacked
for some programs, but the developer does not provide hacking support.

You do not need to manage Internet or Bluetooth from Alaterm.
This is done by Android at all times.

If Android cannot access a device (such as an external hard drive)
via its own File Manager, then Alaterm will not be able to access the device.

A discussion of useful programs, and how to install them,
is provided in the HTML help files installed within Alaterm.


### Bug reports

If you have a software request,
or found a software bug in an installed program, **do not** report it here.
Instead, report it at the project page for the particular program.

If you found a bug in the Alaterm installation script,
then **do** report it here.
Create an issue, and be sure to answer the questions in the bug report form.

Alaterm cannot easily be configured for multimedia.
Absence of audio is not a bug.

Alaterm is not a pentest suite. Just forget about it.

