
# 2025 Day 1

Problem is relatively simple. Nice to make use of the switch case syntax in Zig. 

I spent most of the time trying to figure out what all 

# Ref

How to get the day packages to compile:
- https://stackoverflow.com/questions/75762207/how-to-test-multiple-files-in-zig

```zig
// @ root.zig
comptime {
    _ = @import("./2025/day1.zig");
    // ...
}
```