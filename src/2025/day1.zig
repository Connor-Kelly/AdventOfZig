const std = @import("std");
const testing = std.testing;

fn parseLine(line: []const u8) error{ Overflow, InvalidCharacter }!i32 {
    std.debug.assert(line.len >= 2);
    switch (line[0]) {
        'L' => {
            return -1 * try std.fmt.parseInt(i32, line[1..], 10);
        },
        'R' => {
            return try std.fmt.parseInt(i32, line[1..], 10);
        },
        else => return error.InvalidCharacter,
    }
}

fn part1(alloc: std.mem.Allocator, input: []const u8) !usize {
    _ = alloc;
    var countAtZero: usize = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    var position: i32 = 50;
    while (lines.next()) |line| {
        const value = try parseLine(line);
        // std.debug.print("position {d} : rotationLine: {s} | value {d}\n", .{ position, line, value });
        position += value;
        while (position < 0) {
            position += 100;
        }
        while (position > 99) {
            position -= 100;
        }
        if (position == 0) {
            countAtZero += 1;
        }
    }

    return countAtZero;
}

test "part1small" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day1/small.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const numZeroed = try part1(alloc, input_string);
    try testing.expectEqual(3, numZeroed);
}
test "part1main" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day1/main.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const numZeroed = try part1(alloc, input_string);
    try testing.expectEqual(1048, numZeroed);
}

fn part2(alloc: std.mem.Allocator, input: []const u8) !usize {
    _ = alloc;
    var countAtZero: usize = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    var position: i32 = 50;
    // std.debug.print("\nstart position: {d}", .{position});
    while (lines.next()) |line| {
        const value = try parseLine(line);
        // std.debug.print("position {d}\t: rotationLine: {s} | value {d}\n", .{ position, line, value });
        const lastPosition = position;
        position += value;
        // std.debug.print("\nrotated {s} to point at {d} / {d} -> {d}\t", .{ line, @mod(position, 100), lastPosition, position });
        if (@rem(position, 100) == 0) {
            // std.debug.print(" ! ", .{});
            countAtZero += 1;
        }

        if (@max(position, lastPosition) > 0 and @min(position, lastPosition) < 0) {
            // std.debug.print(" *", .{});
            countAtZero += 1;
        }
        const overflows = @abs(@divTrunc(position, 100));
        position = @mod(position, 100);
        if (overflows > 0) {
            // std.debug.print(" {d}", .{overflows});
            countAtZero += if (position == 0) overflows - 1 else overflows;
        }
    }
    // std.debug.print("\n", .{});

    return countAtZero;
}

test "part2example" {
    const alloc = testing.allocator;
    const numZeroed = try part2(alloc, "R1000");
    try testing.expectEqual(10, numZeroed);
}

test "part2small" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day1/small.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const numZeroed = try part2(alloc, input_string);
    try testing.expectEqual(6, numZeroed);
}

test "part2main" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day1/main.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const numZeroed = try part2(alloc, input_string);
    try testing.expectEqual(6498, numZeroed);
}
