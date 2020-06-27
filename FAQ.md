
## FAQs for alaterm


##### Q. My device is a phone. Will alaterm be useful?

A. Alaterm does not interact with phone in any way.
It treats your device as a WiFi tablet, whether or not you have phone.
If your device has a small screen, then alaterm might be too visually congested.


##### Q. Can alaterm install non-Android versions of web browsers?

A. No. The only web browser known to work within alaterm is the pre-installed NetSurf.
Although programs such as Firefox can be installed, they will not work properly.
This is because Android always controls connections, and also for security reasons.


##### Q: What is the relationship between Linux, Arch Linux ARM, Android, Termux, and alaterm?

A: They are similar but different:

1. Android has a Linux-like structure, but it is different from Linux in many ways.
2. So, Android has capabilities that Linux does not have,
and Linux has capabilities that Android does not (normally) have.
3. Arch Linux is a subset of all Linux.
Arch Linux ARM is a subset specifically compiled for CPUs that use the ARM architecture. 
But Arch Linux ARM knows nothing about Android.
4. Termux is a Linux subsystem that is built using Android tools.
It has a limited set of Linux programs, to which it adds some Android capabilities.
5. Alaterm is a subset of Arch Linux ARM, and a subset of Termux.
It can access some Android features, because Termux actually provides the support.


##### Q: Can alaterm run Windows programs using WINE?

A: No. WINE is available as a free Google Play Store app. Works great. Unfortunately,
there are very few Windows programs compiled for the ARM architecture.
Most of them are text editors, such as Notepad++.
Forget about running ordinary Windows programs using WINE.


##### Q. Why doesn't alaterm have audio-visual programs?

A. Although many audio-visual programs can be installed, at most the video will work.
This is because Android retains control of the sound card, so that it is invisible to alaterm.
A certain amount of hacking can get sound for some, but not all, programs.
However, this is not worth the effort, and it is likely to break with software updates.
Video is best using ordinary Android apps. Alaterm is too slow for that.
If you want to listen to music while you work in alaterm,
simply use an Android music player as a background task.


##### Q. Are the programs, such as GIMP, the same ones used for desktop computers?

A. Yes. And, they are very up-to-date.
But your device has limited CPU and memory, which will limit performance.
Some program features may be unavailable, even though they are shown in the program menus.


##### Q. Does alaterm work with touchscreen, mouse and keyboard, or all of these?

A. All of them. In fact, a Bluetooth mouse and keyboard are recommended,
because the programs are designed for desktop computers.
Although it is possible to (for example) draw and edit in GIMP by touchscreen alone,
it is very challenging.


##### Q. Can alaterm access data on an external USB hard drive?

A. Probably not. Device access is always controlled by Android.
If you cannot do it in Android, and in Termux, then you cannot do it in alaterm.
But you can access Bluetooth devices, and USB pendrive.


##### Q. Can I boot directly into alaterm, without using Android?

A. No.


##### Q. Can I print from alaterm?

A. Probably not with a plug-in printer. Probably OK with a Bluetooth printer.
Or, you can export images and documents as file formats (png, pdf, etc.)
that are understood by other Android apps or desktop computer programs.
Then you can print from there.


##### Q. Can alaterm open files such as PDF, MS Word?

A. PDF is easy. The program is named Document Viewer.
For something such as MS Word, install LibreOffice.
It can also export most (not all) MS Word formats.
But if LibreOffice is too large for your device, remember that a variety of Android apps
can handle MS Word files.


##### Q. Help! I saved a file in alaterm, but Android's file manager cannot find it.

A. This is normal behavior.
Android security does not allow apps (such as the file manager) to look into
locations that are "private" to other apps. Your alaterm home folder is private. So is Termux home.
But you can move a file out of the private area, to where the Android file manager can see it.
You can do this in the LXDE Desktop using its own file manager,
or you can do it via command line if you know how.


##### Q. In alaterm, where is the Termux home directory?

A. It can be found via the LXDE file manager, or via alaterm command: `cd $THOME`


##### Q. In Termux (wihout launching alaterm), where is the alaterm home directory?

A. It is /data/data/com/termux/alaterm/home unless you customized it.
Or, Termux command: `cd $alatermTop/home`


##### Q. Once alaterm is installed, can I discard the "status" file it generated?

A. No! The status file records essential information. In particular,
if you run the installer script again, it tells the installer
that you already have alaterm there, so all it needs to do is update.


##### Q. How often is alaterm updated?

A. Alaterm is merely an installer script. It is occasionally updated for bugs or features.
The installed programs are frequently updated by the Arch Linux ARM project.


##### Q. If I uninstall Termux, what happens?

A. You simultaneously uninstall alaterm.


##### Q. Is there a way to re-install Termux, without losing alaterm?

A. Yes! Do not remove the Termux app. Without launching alaterm, type this into Termux:

```
rm -rf $PREFIX
```
Then exit Termux. At its next launch, Termux will re-download itself,
without touching alaterm. This assumes that you used the standard alaterm install directory.
You will need to add the `proot` program to Termux.
If you forget to do that, any attempt to launch alaterm will remind you.


##### Q. Can I clean out my Termux home directory, without losing alaterm?

A. Yes! The default installation of alaterm is not within Termux home.


##### Q. Can I run two different installations of alaterm in a single Termux?

A. Yes, but not recommended. To do that, you need to edit `00-alaterm.bash`
so that the installation directory and launch command are both changed.
The script developer did this for testing purposes,
but there is no good reason for a user to do it.


##### Q. Does alaterm work with Android power management, to save battery life?

A. Yes . This is automatic, since Android is always in control.
If you know how, you can start and stop a wakelock, when full power is needed.


##### Q. Is alaterm a fork of the TermuxArch project?

A. No. Both of them rely on Arch Linux ARM software, but alaterm and TermuxArch are very different.
If you wish, you may install both of them, as they are independent.


##### Q. Alaterm occupies a lot of space on my device. Is there a lighter alternative?

A. If you need to run heavy programs such as GIMP or LibreOffice,
then you need a heavy installation such as alaterm.
But if you only need to run lightweight programs, such as Geany or mtPaint,
then the lightweight `xfce4` Desktop might be your choice.
See the Termux project page (X11 programs) for more information.
Or, if you only need a command-line program such as TeXLive or ffmpeg,
then you do not need any GUI.


##### Q. If I root my device, does that make alaterm better?

A. I do not know, and do not care. Do not even ask about rooting.


##### Q. Can the installer script be modified for a different Linux distro?

A. No. The installer is specific to Arch Linux ARM.
It is not as simple as changing the name to some other distro.
Besides, most other distros do not have code compiled for ARM processors.


##### Q. Can I contribute to this project?

A. No. It is free, as in libre and gratis. See the MIT License.
If you are a programmer who has code corrections or suggestions,
then raise an issue on the alaterm GitHub project page. Or fork the project.
If you fork it, be sure to keep your code updated!


