//! By convention, root.zig is the root source file when making a library.
const std = @import("std");
const year2024 = @import("./2024/year2024.zig");
const year2025 = @import("./2025/year2025.zig");

comptime {
    _ = year2024;
    // _ = @import("./2024/day2.zig");
    _ = year2025;
}
