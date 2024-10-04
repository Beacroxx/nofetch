#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
__asm__(
    ".data\n.global a\na:\n.quad d\nd:\n.quad str0\n.quad str1\n.quad "
    "str2\n.quad str3\n.quad str4\n.quad str5\n.quad str6\n.quad str7\n.quad "
    "str8\n.quad str9\n.quad str10\n.quad str11\n.align 8\nstr0:\n.ascii "
    "\"\\n> probably a computer\\n> \\0\"\n.align 8\nstr1:\n.ascii \"\\n> "
    "there's probably some ram in there\\n> \\0\"\n.align 8\nstr2:\n.ascii "
    "\"\\n> init should ideally be running\\n> \\0\"\n.align 8\nstr3:\n.ascii "
    "\"\\n> yeah\\n> \\0\"\n.align 8\nstr4:\n.ascii \"\\n> you should probably "
    "go outside\\n> \\0\"\n.align 8\nstr5:\n.ascii \"\\n> i would be lead to "
    "believe that / is mounted\\n> \\0\"\n.align 8\nstr6:\n.ascii \"\\n> hey, "
    "what's this knob do?\\n> \\0\"\n.align 8\nstr7:\n.ascii \"\\n> do you "
    "have games on your phone?\\n> \\0\"\n.align 8\nstr8:\n.ascii \"\\n> you "
    "mean to tell me there aren't little men in this box?\\n> \\0\"\n.align "
    "8\nstr9:\n.ascii \"\\n> plan 4 from the front door\\n> \\0\"\n.align "
    "8\nstr10:\n.ascii \"\\n> i use arch linux btw\\n> \\0\"\n.align "
    "8\nstr11:\n.ascii \"\\n> if you're reading this, it's already too "
    "late\\n> \\0\"\n.ascii \"                                                 "
    "                                                  \\0\"");
unsigned char f, b[] = {25, 40, 36, 10, 36, 50, 31, 38, 62, 32, 23, 51};
unsigned char i = 1;
struct timespec ts;
extern char **a;
char *k, *s;
void _start() {
  clock_gettime(2, &ts);        // Get Clock with id '2'
  i = ts.tv_nsec % 12;          // use ns to get Pseudo-Random int, 0-11
  f = open("/proc/version", 0); // Open file /proc/version
  read(f, a[i] + b[i], 45);     // Read kernel Version
  s = strchr(a[i], '(');        // Find '('
  *(__UINT64_TYPE__ *)(s) = 0x0a0a34365f363878; // Terminate with "x86_64\n\n"
  write(1, a[i], s - a[i] + 8);                 // Print to stdout
  close(f);                                     // Close file
  _exit(0);                                     // Exit
}
