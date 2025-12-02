# Day 2

Zig feels like it's missing interfaces, its really kind of missing the types required for complexity requiring mirroring inheritance in any way. This is both a purism boon and a concern in larger software. I'm not quite sure how one would be able to create generic all-encompassing data structures. Other languages, like Rust seem to use functional programming as well as macros.

One of the more important things that make Rust really good is the all encompassing iterators that rust uses. Its a really good interface, and its a really low overhead, but requires some function composition that seems to be purposefully non-ergonomic in Zig.

```zig
var lines = std.mem.splitScalar(u8, input, '\n');
while (lines.next()) |line| {
    // do things with the lines
}
```

whereas in rust you do something like this:

```rs
input.split('\n').for_each(|line| {
    // do things with the lines
})
```

while these are relatively close implementations for the simple example, this relies on the fact that the `std.mem.splitScalar`'s return is a `SplitIterator` which just so happens to have `SplitIterator::next()` which is an iterator, but not required to be an iterator with a consistent interface. \
I'm sure there are things in the language that allow for this, but they aren't trivially useful, and / or are not used in the standard library. Take for instance Rust's `Iterator::collect<Vec<T>>` which takes an iterator, attempts to drain the entirety of the iterator, and converts it into a Vec (a rust equivalent of a dynamic array) of generic type `T`. If I wanted to replicate `Iterator::collect<Vec<T>>`, I'd need to write a pretty comptime generic that anytyped the iterator, checked the type for the `next()` function, its inputs / outputs and then kind of hope for the best.\
I don't very much like this pattern, though I understand the premise of why it exists.

There's a decent chance that you can use dependency injection into fields as a generalized pattern, though I'm not sure how I feel about using a generalized pattern as an important part of organizing everything is a big codebase. (it might be a good time to take a look at Bun or Ghostty for a better idea.)

