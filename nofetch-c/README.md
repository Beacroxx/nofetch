nofetch rewritten in C.

```
to compile the C program, run
```
clang -nostdlib -lc -masm=intel main.c -o nofetch
```

## ! IMPORTANT !
this code will segfault if you do not have a /proc/version file where the opening bracket `(` is in the first 45 characters.
it will also print out garbage at the end if your kernel name is too short.
this can be fixed by adjusting the buffer length inside the file on line 15.
