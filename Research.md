https://wiki.ubuntu.com/DesktopCDOptions
https://wiki.ubuntu.com/UbiquityAutomation
http://wiki.debian.org/DebianInstaller/Preseed
https://help.ubuntu.com/12.04/installation-guide/i386/appendix-preseed.html
https://help.ubuntu.com/12.04/installation-guide/example-preseed.txt
https://help.ubuntu.com/12.10/installation-guide/i386/preseed-contents.html
https://help.ubuntu.com/12.10/installation-guide/i386/preseed-using.html
https://raw.github.com/freegeekchicago/preseed/master/xubuntu1204x32.seed
https://github.com/freegeekchicago/preseed
http://cptyesterday.wordpress.com/2012/06/17/notes-on-using-expert_recipe-in-debianubuntu-preseed-files/
http://pastebin.com/s7tRYxxu
https://wiki.ubuntu.com/Installer/FAQ
# started from here to mount the iso
http://askubuntu.com/questions/128995/grub2-loopback-booting-ubuntu-server-iso
http://askubuntu.com/questions/122505/how-do-i-create-completely-unattended-install-for-ubuntu

Overall:
https://wiki.ubuntu.com/SeedManagement
http://hands.com/d-i/

http://ubuntuforums.org/showthread.php?t=1622388


https://github.com/jpoppe/seedBank/


# would love to automate around this
http://superuser.com/questions/319661/what-does-the-following-disks-have-mounted-partitions-mean-while-installing-ub

Because our usb is obviosly mounted, but we don't want to display this error... possibly would like to ever remove this usb from the list of partitions listed/viewed by the UI / ubiquity


preseed/early_command=/path/to/script.sh  run the specified script before starting the installer. 

You can use preseed/early_command with the live CD; it will be run by "casper" (the component which sets up a live environment at boot time) from the initramfs. Please note that, if you want to affect files in the live environment, this means that you must prefix their filenames with /root.



automatic-ubiquity: Pass --automatic to ubiquity which enables automatic mode. Questions that have been marked seen will be skipped and pages of the interface that ask no questions (because they are all skipped) will not be shown. Implies only-ubiquity (see below).


debug-ubiquity: Pass -d to ubiquity which enables debug mode. Communication with debconf is written to /var/log/installer/debug.


ubiquity/failure_command: specify a command to be run should the install fail.
ubiquity/success_command: similar to preseed/late_command. Specify a command to be run when the install completes successfully (runs outside of /target, but /target is mounted when the command is invoked).



d-i preseed/late_command string \
in-target wget -O /tmp/files.tar.gz http://ubuntu/12.04/postinst/files.tar.gz ; \
in-target tar zxf /tmp/files.tar.gz -C /tmp/ ; \
in-target /bin/sh /tmp/files/post.sh ; \
in-target touch /root/test
