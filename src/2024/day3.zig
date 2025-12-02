const std = @import("std");
const testing = std.testing;
const regex = @cImport({
    @cInclude("regex.h");
});

fn part1() void {}

test "day3smol" {
    const regex_t: regex.regex_t = opaque {};
    const reti = regex.regcomp(&regex_t, "a", 0);
    if (reti) {
        std.debug.print("failed to compile regex\n", .{});
    }
    
}
