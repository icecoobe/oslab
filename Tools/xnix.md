*nix
====

For `GNU/Linux`, `Unix` and `Mac OS X`, use `dd` is enough.

```
$ dd if=xx.bin of=xx.img seek=0 bs=512 count=1 conv=notrunc
```