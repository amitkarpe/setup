#!/bin/bash
# "C:\Users\ISSUser\Downloads\setup\setup\hardening\final.sh" update 16 July
set -x
stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: { %g/ %G)' /etc/passwd-
chmod u-x,go-wx /etc/passwd ; chown root:root /etc/passwd
chmod u-x,go-wx /etc/passwd- ; chown root:root /etc/passwd-
stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/group
chmod u-x,go-wx /etc/group ; chown root:root /etc/group
chmod u-x,go-wx /etc/group- ; chown root:root /etc/group-
stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/shells
chmod u-x,go-wx /etc/shells; chown root:root /etc/shells
stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/group
chmod u-x,go-wx /etc/shells; chown root:root /etc/shells
chown root:root /etc/shadow; chmod 0000 /etc/shadow
chown root:root /etc/shadow-; chmod 0000 /etc/shadow-
chown root:root /etc/gshadow; chmod 0000 /etc/gshadow
chown root:root /etc/gshadow-; chmod 0000 /etc/gshadow-
