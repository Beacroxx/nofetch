nofetch rewritten in assembly to be as small as possible. (305 bytes)
it runs in approximately 50µs on my machine.
needs the symlink

to compile the assembly, run
```
sudo ln -sf /proc/version /version
nasm main.asm -o nofetch
chmod +x ./nofetch
```
## ! IMPORTANT !
this code will segfault if you do not have a /proc/version file where the opening bracket `(` is in the first 32 characters.
it will also print out garbage at the end if your kernel name is too short.
this can be fixed by adjusting the buffer length inside the file on line 74.
