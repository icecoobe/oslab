# Assume we have a asm file named XX.asm
# and the target name is XX for simplicity
# Build:
# make name=XX
# 
# Also, we can put vm-writing codes here, 
# but it makes no sense.

${name}:${name}.asm
	@echo Building ${name}.asm
	nasm -f bin -o bin/${name} -l bin/${name}.lst ${name}.asm -Iinc
