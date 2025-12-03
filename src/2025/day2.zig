const std = @import("std");
const testing = std.testing;

fn isInvalidNumber(alloc: std.mem.Allocator, number: u128) !bool {
    const numString = try std.fmt.allocPrint(alloc, "{d}", .{number});
    defer alloc.free(numString);
    index: for (1..numString.len) |i| {
        var splits = std.mem.splitSequence(u8, numString, numString[0..i]);
        var numEmpties: usize = 0;
        while (splits.next()) |l| {
            if (l.len > 0) continue :index;
            numEmpties += 1;
            if (numEmpties > 3) continue :index;
        }
        return true;
    }
    return false;
}

test "invalid numbers are invalid" {
    const alloc = testing.allocator;
    try testing.expectEqual(true, isInvalidNumber(alloc, 11));
    try testing.expectEqual(true, isInvalidNumber(alloc, 22));
    try testing.expectEqual(true, isInvalidNumber(alloc, 99));
    try testing.expectEqual(true, isInvalidNumber(alloc, 1010));
    try testing.expectEqual(true, isInvalidNumber(alloc, 1188511885));
    try testing.expectEqual(true, isInvalidNumber(alloc, 446446));
    try testing.expectEqual(true, isInvalidNumber(alloc, 38593859));
}

test "valid numbers are valid" {
    const alloc = testing.allocator;
    try testing.expectEqual(false, isInvalidNumber(alloc, 1));
    try testing.expectEqual(false, isInvalidNumber(alloc, 2));
    try testing.expectEqual(false, isInvalidNumber(alloc, 101));
    try testing.expectEqual(false, isInvalidNumber(alloc, 998));
    try testing.expectEqual(false, isInvalidNumber(alloc, 999));
    try testing.expectEqual(false, isInvalidNumber(alloc, 1110));
    try testing.expectEqual(false, isInvalidNumber(alloc, 1288511885));
    try testing.expectEqual(false, isInvalidNumber(alloc, 4464460));
    try testing.expectEqual(false, isInvalidNumber(alloc, 3859359));
}

fn computeInvalidsInLine(alloc: std.mem.Allocator, iterMutex: *std.Thread.Mutex, lineIter: *std.mem.SplitIterator(u8, .scalar), count: *std.atomic.Value(u128)) void {
    while (true) {
        iterMutex.lock();
        const line = lineIter.next();
        iterMutex.unlock();
        if (line == null) {
            return;
        }

        var nums = std.mem.splitScalar(u8, line.?, '-');
        const first = nums.next().?;
        const last = nums.next().?;
        var number = std.fmt.parseInt(u128, first, 10) catch {
            return;
        };
        const end = std.fmt.parseInt(u128, last, 10) catch {
            return;
        };
        while (number <= end) {
            defer number += 1;
            if (isInvalidNumber(alloc, number) catch {
                return;
            }) {
                _ = count.fetchAdd(number, .monotonic);
            }
        }
    }
}

fn part1(alloc: std.mem.Allocator, input: []const u8) !u128 {
    var count = std.atomic.Value(u128){ .raw = 0 };
    var lines = std.mem.splitScalar(u8, input, ',');
    var iterMutex = std.Thread.Mutex{};
    const cpuCount = try std.Thread.getCpuCount();
    var threads = try std.ArrayList(std.Thread).initCapacity(alloc, cpuCount);
    defer threads.deinit(alloc);
    for (0..cpuCount) |_| {
        const thread = try std.Thread.spawn(.{ .allocator = alloc }, computeInvalidsInLine, .{ alloc, &iterMutex, &lines, &count });
        try threads.append(alloc, thread);
    }

    for (threads.items) |thread| {
        thread.join();
    }

    return count.raw;
}

test "part1small" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day2/small.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part1(alloc, input_string);
    try testing.expectEqual(1227775554, sum);
}

test "part1main" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day2/main.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part1(alloc, input_string);
    try testing.expectEqual(43952536386, sum);
}

fn isInvalidNumberP2(alloc: std.mem.Allocator, number: u128) !bool {
    const numString = try std.fmt.allocPrint(alloc, "{d}", .{number});
    defer alloc.free(numString);
    index: for (1..numString.len) |i| {
        var splits = std.mem.splitSequence(u8, numString, numString[0..i]);
        while (splits.next()) |l| {
            if (l.len > 0) continue :index;
        }
        return true;
    }
    return false;
}

test "invalid numbers are invalid p2" {
    const alloc = testing.allocator;
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 11));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 22));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 99));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 111));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 999));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 1010));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 1188511885));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 446446));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 38593859));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 565656));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 824824824));
    try testing.expectEqual(true, isInvalidNumberP2(alloc, 212121212121));
}

test "valid numbers are valid p2" {
    const alloc = testing.allocator;
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 1));
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 2));
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 101));
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 998));
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 1110));
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 1288511885));
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 4464460));
    try testing.expectEqual(false, isInvalidNumberP2(alloc, 3859359));
}

fn computeInvalidsInLineP2(alloc: std.mem.Allocator, iterMutex: *std.Thread.Mutex, lineIter: *std.mem.SplitIterator(u8, .scalar), count: *std.atomic.Value(u128)) void {
    while (true) {
        iterMutex.lock();
        const line = lineIter.next();
        iterMutex.unlock();
        if (line == null) {
            std.debug.print("!finished!\n", .{});
            return;
        }
        std.debug.print("> {s}\n", .{line.?});

        var nums = std.mem.splitScalar(u8, line.?, '-');
        const first = nums.next().?;
        const last = nums.next().?;
        var number = std.fmt.parseInt(u128, first, 10) catch {
            return;
        };
        const end = std.fmt.parseInt(u128, last, 10) catch {
            return;
        };
        while (number <= end) {
            defer number += 1;
            if (isInvalidNumberP2(alloc, number) catch {
                return;
            }) {
                std.debug.print(">!> {d}\n", .{number});
                _ = count.fetchAdd(number, .monotonic);
            }
        }
    }
}

fn part2(alloc: std.mem.Allocator, input: []const u8) !u128 {
    var count = std.atomic.Value(u128){ .raw = 0 };
    var lines = std.mem.splitScalar(u8, input, ',');
    var iterMutex = std.Thread.Mutex{};
    const cpuCount = try std.Thread.getCpuCount() * 2;
    var threads = try std.ArrayList(std.Thread).initCapacity(alloc, cpuCount);
    defer threads.deinit(alloc);
    for (0..cpuCount) |_| {
        const thread = try std.Thread.spawn(.{ .allocator = alloc }, computeInvalidsInLineP2, .{ alloc, &iterMutex, &lines, &count });
        try threads.append(alloc, thread);
    }

    for (threads.items) |thread| {
        thread.join();
    }

    return count.raw;
}

test "part2small" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day2/small.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part2(alloc, input_string);
    try testing.expectEqual(4174379265, sum);
}

// runs in 4m 12s 785ms on my Framework laptop
test "part2main" {
    const alloc = testing.allocator;
    const input_string = try std.fs.cwd().readFileAlloc(alloc, "inputs/2025/day2/main.txt", std.math.maxInt(u32));
    defer alloc.free(input_string);

    const sum = try part2(alloc, input_string);
    try testing.expectEqual(54486209192, sum);
}
