# AdventOfZig

In this repo, I'm using [Advent of Code](https://adventofcode.com/) to get up to speed on Zig, and what Andrew Kelly has been up to.

To keep this relatively simple, the solution for each of the problems is in `src/<year>/<daynumber>.zig`, each of the test cases for those solutions are stored in Zig's built in test runner: `test "mytest" {}`, and the input to those problems is stored in `input/<year>/<daynumber>/[small|main].txt`. I've committed the sample inputs as well as my personal inputs because it makes it much easier to run.

You can run all the tests with the following:

```sh
zig build test
```

I use the following when I'm doing dev to watch the tests:

```sh
zig build --watch test
```
