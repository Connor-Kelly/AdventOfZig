const std = @import("std");
const testing = std.testing;

fn parseLine(alloc: std.mem.Allocator, line: []const u8) ![]u32 {
    var levelsStrs = std.mem.splitScalar(u8, line, ' ');

    var levels = try std.ArrayList(u32).initCapacity(alloc, 1);
    defer levels.deinit(alloc);
    while (levelsStrs.next()) |value| {
        const level = try std.fmt.parseInt(u32, value, 10);
        try levels.append(alloc, level);
    }
    return try levels.toOwnedSlice(alloc);
}

fn isIncreasing(a: usize, b: usize) ?bool {
    if (a == b) {
        return null;
    } else if (a < b) {
        return true;
    }
    return false;
}

fn isSafe(levels: []u32) !bool {
    if (levels.len <= 2) {
        return false;
    }

    var lastLevel = levels[0];
    const isInc: ?bool = isIncreasing(levels[1], lastLevel);
    for (levels[1..]) |nextLevel| {
        defer lastLevel = nextLevel;
        const difference: usize = @max(nextLevel, lastLevel) - @min(nextLevel, lastLevel);
        if ((difference < 1) or (difference > 3)) {
            // std.debug.print("checkign line: {s}\n", .{line});
            // std.debug.print("diff {any} | {d} {d}\n", .{ difference, lastLevel, nextLevel });
            return false;
        }
        if (if (isInc.?) (nextLevel >= lastLevel) else (nextLevel <= lastLevel)) {
            // std.debug.print("checkign line: {s}\n", .{line});
            // std.debug.print("inc {any} | {d} {d}\n", .{ isInc, lastLevel, nextLevel });
            return false;
        }
    }
    return true;
}

pub fn part1(alloc: std.mem.Allocator, input: []u8) !u32 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var safeLines: u32 = 0;
    while (lines.next()) |line| {
        const ln = try parseLine(alloc, line);
        defer alloc.free(ln);
        if (try isSafe(ln)) {
            safeLines += 1;
        }
    }

    return safeLines;
}

test "day2smol" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2024/day2/small.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part1(alloc, inputs_string);
    try testing.expectEqual(2, diff);
}

test "day2main" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2024/day2/main.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part1(alloc, inputs_string);
    try testing.expectEqual(242, diff);
}

fn isSafeWithOneMissing(alloc: std.mem.Allocator, line: []const u8) !bool {
    var levels = try parseLine(alloc, line);
    defer alloc.free(levels);

    if (try isSafe(levels)) {
        return true;
    }

    for (0..levels.len) |i| {
        const lev = try std.mem.concat(alloc, u32, &[_][]u32{ levels[0..i], levels[i + 1 ..] });
        defer alloc.free(lev);
        if (try isSafe(lev)) {
            return true;
        }
    }
    return false;
}

pub fn part2(alloc: std.mem.Allocator, input: []u8) !u32 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var safeLines: u32 = 0;
    while (lines.next()) |line| {
        if (try isSafeWithOneMissing(alloc, line)) {
            safeLines += 1;
        }
    }

    return safeLines;
}

test "day2smolpart2" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2024/day2/small.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part2(alloc, inputs_string);
    try testing.expectEqual(4, diff);
}

test "day2mainpart2" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2024/day2/main.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part2(alloc, inputs_string);
    try testing.expectEqual(311, diff);
}
