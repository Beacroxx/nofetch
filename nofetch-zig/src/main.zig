const std = @import("std");

pub fn main() !void {
  const strings = [_][]const u8{
    "probably a computer",
    "there's probably some ram in there",
    "init should ideally be running",
    "yeah",
    "you should probably go outside",
    "i would be lead to believe that / is mounted",
    "hey, what's this knob do?",
    "i use arch btw",
  };

  var prng = std.rand.DefaultPrng.init(blk: {
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    break :blk seed;
  });
  const rand = prng.random();
  const randStr = strings[rand.intRangeAtMost(u8, 0, 7)];
  std.debug.print("\n> {s}\n", .{randStr});

    var file = std.fs.openFileAbsolute("/proc/version", .{ .mode = .read_only }) catch |err| {
        std.debug.print("Error opening file: {}\n", .{err});
        return;
    };
    defer file.close();

    var buffer: [1024]u8 = undefined;
    const bytes_read = try file.readAll(buffer[0..]);

    const idx = std.mem.indexOf(u8, buffer[0..bytes_read], "(") orelse bytes_read;
    const version = buffer[0..idx];
    std.debug.print("> {s}\n\n", .{version});
}
