const strings = [
  "probably a computer",
  "there's probably some ram in there",
  "init should ideally be running",
  "yeah",
  "you should probably go outside",
  "i would be lead to believe that / is mounted",
  "hey, what's this knob do?",
  "i use arch btw",
];

const randInt = (max) => Math.floor(Math.random() * max);
const randStr = strings[randInt(strings.length)];
console.log("\n> " + randStr);
const file = Bun.file("/proc/version");
let content = await file.text();
const len = content.indexOf("(");
content = content.substring(0, len);
console.log("> " + content + "\n");
