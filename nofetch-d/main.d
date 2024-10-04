import std.stdio;
import std.random;
import std.file;
import std.string;
import std.algorithm;

void main() {
  const string[] strings = [
    "probably a computer",
    "there's probably some ram in there",
    "init should ideally be running",
    "yeah",
    "you should probably go outside",
    "i would be lead to believe that / is mounted",
    "hey, what's this knob do?",
    "i use arch btw",
  ];

  auto randStr = strings[uniform(0, $)];
  writeln("\n> ", randStr);

  auto content = readText("/proc/version");
  auto len = content.indexOf("(");
  content = content[0 .. len];
  writeln("> ", content, "\n");
}
