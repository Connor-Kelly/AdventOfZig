const std = @import("std");
const testing = std.testing;
const parseInt = std.fmt.parseInt;

pub fn part1(alloc: std.mem.Allocator, input: []u8) !u32 {
    var first_items = try std.ArrayList(i32).initCapacity(alloc, 0);
    defer first_items.deinit(alloc);
    var last_items = try std.ArrayList(i32).initCapacity(alloc, 0);
    defer last_items.deinit(alloc);
    var split = std.mem.splitScalar(u8, input, '\n');

    while (split.next()) |line| {
        var elems = std.mem.splitScalar(u8, line, ' ');
        const first = elems.first();
        var last: []const u8 = "";
        while (elems.next()) |e| {
            last = e;
        }

        try first_items.append(alloc, try parseInt(i32, first, 10));
        try last_items.append(alloc, try parseInt(i32, last, 10));
    }
    std.mem.sort(i32, first_items.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, last_items.items, {}, comptime std.sort.asc(i32));

    std.debug.assert(first_items.items.len == last_items.items.len);
    var diff: u32 = 0;
    for (0..first_items.items.len) |i| {
        diff = diff + @abs(first_items.items[i] - last_items.items[i]);
    }

    return diff;
}

test "day1smol" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/d1_small.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part1(alloc, inputs_string);
    try testing.expectEqual(diff, 11);
}

test "day1main" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/d1_main.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part1(alloc, inputs_string);
    try testing.expectEqual(diff, 1941353);
}

pub fn part2(alloc: std.mem.Allocator, input: []u8) !u32 {
    var first_items = try std.ArrayList(i32).initCapacity(alloc, 0);
    defer first_items.deinit(alloc);
    var last_items = try std.ArrayList(i32).initCapacity(alloc, 0);
    defer last_items.deinit(alloc);
    var split = std.mem.splitScalar(u8, input, '\n');

    while (split.next()) |line| {
        var elems = std.mem.splitScalar(u8, line, ' ');
        const first = elems.first();
        var last: []const u8 = "";
        while (elems.next()) |e| {
            last = e;
        }

        try first_items.append(alloc, try parseInt(i32, first, 10));
        try last_items.append(alloc, try parseInt(i32, last, 10));
    }
    // count how many times each item in first appears in last
    var count: i32 = 0;

    for (first_items.items) |value| {
        count +=
            @as(i32, @intCast(std.mem.count(i32, last_items.items, &[_]i32{value}))) *
            value;
    }

    return @intCast(count);
}

test "day2smol" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/d1_small.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part2(alloc, inputs_string);
    try testing.expectEqual(diff, 31);
}

test "day2main" {
    const alloc = testing.allocator;
    const inputs_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/d1_main.txt", std.math.maxInt(u32));
    defer alloc.free(inputs_string);

    const diff = try part2(alloc, inputs_string);
    try testing.expectEqual(diff, 22539317);
}
