# Day 1

Its a pretty simple problem, just getting myself good with the standard library and figuring out the build / test system.

## Things learned

-   usual stdlib things are usually in `std.mem`
-   errors as values are a little annoying in zig
-   parseInt is in `std.fmt.parseInt`
-   type coersion between ints in zig are kind of nasty, should think about those more before those types.
-   `std.testing.allocator` is very useful for finding memory leaks, purely bc I haven't done manual memory management in a hot minute
-   testing in your code is super useful, the test cli / aparatus is somewhat sketchy, not sure how exactly that works for sure
