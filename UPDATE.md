#### Updates to Alaterm

Latest scriptRevision 1 is 68<br>
Latest scriptRevision 2 is 208<br>
Note that version 2 is not an update to version 1.

Launch Alaterm. Command: `echo $scriptRevision` then compare to above.
If an update exists, then:

1. Download and unzip a fresh copy of the Alaterm repository,
into your Alaterm home directory. IMPORTANT: Updates must be run
from within launched Alaterm.

2. Enter the `update` folder. Command: `bash alaterm-update`

The script will auto-detect whether your installation is version 1 or 2,
and will apply updates (if any). This is a fast procedure, usually involving
no more than small tweaks to existing configuration files, or new
utility scripts.

Remember: Alaterm does not provide programs.
It is an installer for programs provided by Arch Linux ARM.
To update installed Linux software: `pacman -Syu`



