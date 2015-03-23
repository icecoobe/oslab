#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 'filename' without file-extension
	exit
fi

filename=$1

nasm -f bin -o ${filename}.com -l ${filename}.lst ${filename}.asm

