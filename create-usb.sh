USB=/dev/sdc
SRCISO=/srv/mirror/iso/ubuntu-12.04.1-desktop-amd64.iso
SRCISONAME=$(basename $SRCISO)
DSTMOUNT=$(mktemp -d)
SRCMOUNT=$(mktemp -d)

mount -o loop ${SRCISO} ${SRCMOUNT}

parted -s ${USB} mklabel msdos 
parted -s -- ${USB} mkpart primary fat32 2 -1
parted -s -- ${USB} set 1 boot on
mkfs.vfat -n 'Infraboot' ${USB}1
mount ${USB}1 ${DSTMOUNT}
mkdir ${DSTMOUNT}/boot
grub-install --root-directory=${DSTMOUNT} ${USB}
cat <<EOF>${DSTMOUNT}/boot/grub/grub.cfg
if loadfont /boot/grub/font.pf2 ; then
	set gfxmode=auto
	insmod efi_gop
	insmod efi_uga
	insmod gfxterm
	terminal_output gfxterm
fi

set menu_color_normal=white/black
set menu_color_highlight=black/light-gray

set timeout=10
set default=0
set isofile="/${SRCISONAME}"

menuentry "Live Laptop on USB" {
 loopback loop \$isofile
 linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=\$isofile splash --
 initrd (loop)/casper/initrd.lz
}

menuentry "Try Ubuntu without installing" {
  loopback loop \$isofile
	set gfxpayload=keep
	linux	(loop)/casper/vmlinuz boot=casper iso-scan/filename=\$isofile file=/isodevice/preseed.seed quiet splash --
	initrd	(loop)/casper/initrd.lz
}

menuentry "Fully Automated Laptop install to Disk" {
  loopback loop \$isofile
	set gfxpayload=keep
	linux	(loop)/casper/vmlinuz boot=casper iso-scan/filename=\$isofile file=/isodevice/preseed.seed quiet splash locale=en_US preseed/locale=en_US keyboard-configuration/layoutcode=us console-setup/layoutcode=en debug-ubiquity automatic-ubiquity noeject noprompt  --
	initrd	(loop)/casper/initrd.lz
}

EOF
cp -av ${SRCMOUNT}/efi ${DSTMOUNT}/efi
cp -av ${SRCMOUNT}/boot/grub/*efi* ${DSTMOUNT}/boot/grub/
cp -av ${SRCMOUNT}/.disk ${DSTMOUNT}/.disk
cp -av ${SRCMOUNT}/boot/grub/font.pf2 ${DSTMOUNT}/boot/grub/
cp preseed.seed ${DSTMOUNT}
cp -av ${SRCISO} ${DSTMOUNT}
sync # makes sure the iso is synced before unmounting
umount ${DSTMOUNT}
umount ${SRCMOUNT}
rmdir ${SRCMOUNT}
rmdir ${DSTMOUNT}
