const std = @import("std");
const testing = std.testing;

const pair = struct { v: u32, i: usize };

fn maxJoltage(banks: []u32) u32 {
    std.debug.assert(banks.len > 2);
    var largest: pair = .{ .v = 0, .i = banks.len - 2 };
    var nextLargest: pair = .{ .v = 0, .i = banks.len - 1 };

    {
        var i = (banks.len - 1);
        while (i > 0) {
            i -= 1;
            const curr: u32 = banks[i];
            if (curr >= largest.v) {
                largest.v = curr;
                largest.i = i;
            }
        }
    }
    {
        var i = largest.i;
        while (i < banks.len - 1) {
            i += 1;
            const curr = banks[i];
            if (curr > nextLargest.v) {
                nextLargest.v = curr;
                nextLargest.i = i;
            }
        }
    }
    return 10 * largest.v + nextLargest.v;
}

test "maxJoltage works" {
    var a = [_]u32{ 9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1 };
    try testing.expectEqual(98, maxJoltage(a[0..]));
    var b = [_]u32{ 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9 };
    try testing.expectEqual(89, maxJoltage(b[0..]));
    var c = [_]u32{ 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8 };
    try testing.expectEqual(78, maxJoltage(c[0..]));
    var d = [_]u32{ 8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1 };
    try testing.expectEqual(92, maxJoltage(d[0..]));
}

fn part1(alloc: std.mem.Allocator, input: []const u8) !usize {
    var totalJolt: u32 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const banks = try alloc.alloc(u32, line.len);
        defer alloc.free(banks);
        for (line, 0..) |char, i| {
            banks[i] = try std.fmt.charToDigit(char, 10);
        }
        const jolt = maxJoltage(banks);
        // std.debug.print("line: {s} | j: {d}\n", .{ line, jolt });
        totalJolt += jolt;
    }
    return totalJolt;
}

test "part1small" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day3/small.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part1(alloc, input_string);
    try testing.expectEqual(357, sum);
}

test "part1main" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day3/main.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part1(alloc, input_string);
    try testing.expectEqual(17316, sum);
}

fn maxJoltageRec(alloc: std.mem.Allocator, bank: []u32, size: usize) ![]pair {
    if (size == 0) {
        var p = [_]pair{};
        return p[0..];
    }
    const largestIndex = std.mem.indexOfMax(u32, bank[0 .. bank.len + 1 - size]);
    const rest = try maxJoltageRec(alloc, bank[largestIndex + 1 ..], size - 1);
    defer alloc.free(rest);
    var pairs = try std.ArrayList(pair).initCapacity(alloc, rest.len + 1);
    try pairs.append(alloc, pair{ .v = bank[largestIndex], .i = largestIndex });
    try pairs.appendSlice(alloc, rest);
    return (pairs.items);
}

fn convertJoltagePairsToInt(pairs: []pair) u128 {
    std.debug.assert(pairs.len > 1);
    var value: u128 = @intCast(pairs[0].v);
    for (pairs[1..]) |p| {
        value *= 10;
        value += @intCast(p.v);
    }
    return value;
}

test "maxJoltage works p2" {
    const alloc = testing.allocator;
    {
        var a = [_]u32{ 9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1 };
        const joltageA = try maxJoltageRec(alloc, a[0..], 12);
        defer alloc.free(joltageA);
        const jtotalA = convertJoltagePairsToInt(joltageA);
        // std.debug.print("{any}\n", .{jtotalA});
        try testing.expectEqual(987654321111, jtotalA);
    }
    {
        var a = [_]u32{ 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9 };
        const joltageA = try maxJoltageRec(alloc, a[0..], 12);
        defer alloc.free(joltageA);
        const jtotalA = convertJoltagePairsToInt(joltageA);
        // std.debug.print("{any}\n", .{jtotalA});
        try testing.expectEqual(811111111119, jtotalA);
    }
    {
        var a = [_]u32{ 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8 };
        const joltageA = try maxJoltageRec(alloc, a[0..], 12);
        defer alloc.free(joltageA);
        const jtotalA = convertJoltagePairsToInt(joltageA);
        // std.debug.print("{any}\n", .{jtotalA});
        try testing.expectEqual(434234234278, jtotalA);
    }
    {
        var a = [_]u32{ 8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1 };
        const joltageA = try maxJoltageRec(alloc, a[0..], 12);
        defer alloc.free(joltageA);
        const jtotalA = convertJoltagePairsToInt(joltageA);
        // std.debug.print("{any}\n", .{jtotalA});
        try testing.expectEqual(888911112111, jtotalA);
    }
}

fn part2(alloc: std.mem.Allocator, input: []const u8) !u128 {
    var totalJolt: u128 = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const banks = try alloc.alloc(u32, line.len);
        defer alloc.free(banks);
        for (line, 0..) |char, i| {
            banks[i] = try std.fmt.charToDigit(char, 10);
        }
        const pairs = try maxJoltageRec(alloc, banks, 12);
        defer alloc.free(pairs);
        const joltage = convertJoltagePairsToInt(pairs);
        // std.debug.print("line: {s} | j: {d}\n", .{ line, joltage });
        totalJolt += joltage;
    }
    return totalJolt;
}

test "part2small" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day3/small.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part2(alloc, input_string);
    try testing.expectEqual(3121910778619, sum);
}

test "part2main" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day3/main.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part2(alloc, input_string);
    try testing.expectEqual(171741365473332, sum);
}
