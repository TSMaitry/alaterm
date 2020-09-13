#!/usr/bin/env perl
# Alaterm:file=$alatermTop/usr/local/scripts/start-vnc
# Script /usr/local/scripts/start-vnc
# This is an ESSENTIAL Alaterm file. Do not remove it.
# Based on older version of /usr/bin/vncserver.
# See above file for Copyright, License, and credits.

# Set some default options:
my %default_opts;
$default_opts{auth} = "/home/.Xauthority";
$default_opts{rfbwait} = 20000;
$default_opts{rfbauth} = "/home/.vnc/passwd";
$default_opts{rfbport} = 5901;
$default_opts{pn} = "";
$default_opts{geometry} = "1280x800";
# The password is pre-set, but just in case it is missing:
($z,$z,$mode) = stat("/home/.vnc/passwd");
if (!(-e "/home/.vnc/passwd") || ($mode & 077)) {
    warn "\nYou will require a password to access your desktop.\n\n";
    system("/usr/bin/vncpasswd -q /home/.vnc/passwd");
    if (($? >> 8) != 0) {
        exit 1;
    }
}
unlink("/home/.vnc/localhost:1.log");
$cookie = `mcookie`;
open(XAUTH, "|xauth -f /home/.Xauthority source -");
print XAUTH "add localhost:1 . $cookie\n";
print XAUTH "add localhost/unix:1 . $cookie\n";
close(XAUTH);
# Base vnc command:
$cmd = "/usr/bin/Xvnc :1";
# Read configuration from /home/.vnc/config. Usually only geometry:
my %config;
if (stat("/home/.vnc/config")) {
  if (open(IN, "/home/.vnc/config")) {
    while (<IN>) {
      next if /^#/;
      if (my ($k, $v) = /^\s*(\w+)\s*=\s*(.+)$/) {
        $k = lc($k); # Lowercase.
        $config{$k} = $v;
      }
    }
    close(IN);
  }
}
# Each config substitutes for its default:
foreach my $k (sort keys %config) {
  $cmd .= " -$k $config{$k}";
  delete $default_opts{$k};
}
# Add remaining defaults:
foreach my $k (sort keys %default_opts) {
  $cmd .= " -$k $default_opts{$k}";
}
# Log the command:
$cmd .= " >> " . '/home/.vnc/localhost:1.log' . " 2>&1";
# Run command and record the process ID.
$pidFile = "/home/.vnc/localhost:1.pid";
system("$cmd & echo \$! >$pidFile");
# Give Xvnc a chance to start:
sleep(3);
# Verify that it started:
unless (kill 0, `cat $pidFile`) {
    warn "Could not start Xvnc.\n\n";
    unlink $pidFile;
    open(LOG, "</home/.vnc/localhost:1.log");
    while (<LOG>) { print; }
    close(LOG);
    die "\n";
}
# Greeting message:
warn "New localhost:1 at 127.0.0.1:5901.
View LXDE Desktop in VNC Viewer app. Password: password
To leave Alaterm and return to Termux: logout\n";
$ENV{DISPLAY}= ":1";
$ENV{VNCDESKTOP}= "localhost:1";
system("/home/.vnc/xstartup >> " . '/home/.vnc/localhost:1.log' . " 2>&1 &");
exit;
##
