#! /bin/bash
make name=boot
make name=sector2
sudo dd if=bin/boot of=/dev/sdc count=1 bs=446
sudo dd if=bin/sector2 of=/dev/sdc count=1 bs=512 seek=1

echo done!
