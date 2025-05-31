# shellcode_spawn.py
from pwn import *

context.arch = 'amd64'  # or 'i386' depending on your container
shellcode = asm(shellcraft.sh())
print(shellcode)