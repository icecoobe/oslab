#! /bin/bash
make name=boot
make name=locallabel
sudo dd if=bin/boot of=/dev/sdc count=1 bs=446
sudo dd if=bin/locallabel of=/dev/sdc count=1 bs=512 seek=1

echo done!
