# 2025 day 2

This puzzle was relatively simple to solve, and I simply solved it correctly, but
inefficiently on the first check for invalidity. I was pretty confident that it would
be relatively simple to translate into the part 2, which I expected to most likely
ask for the count of the times a number repeated, and multiply it or something.\
It turned out that in testing the first part, I first wrote the solution for the validity
checker for part 2, realized I was wrong and added a few lines to make sure everything
only repeated once.

When it came to the actual solve, it turned out that my string shenanigans
were wildly ineffcient, but it seemed pretty right, structurally speaking, so
I decided fk'it I can wait. So I ran it, and it took 5 minutes, before I stopped it. 
So I added multithreading. (I really wish Zig team had finished up 0.16 so I'd have
an async api, but I'm only complaining a little bit.)

It'd been a minute since I'd done any multithreading, so I tried out some of the
different things in `std.Thread`. Still not sure whats going on with the WaitGroups,
since they didnt work like I thought they would, but `Thread`, `Mutex`, and 
`std.atomic.Value` all work wonderfully, except that `std.atomic.Value` for some
reason takes neither an `std.mem.Allocator` nor a `*std.mem.Allocator`. I wanted
an atomic to the allocator so that I wouldn't get overlapping alloc calls, since
it kept stack tracing when all the threads used the same allocator. (This might
have fixed itself later, not sure what was going on...)

Anyways, multithreading in Zig is remarkably clean. My algo was bad, but when you run
it on all the threads, its not that bad. My main concern is that there isnt a great way
to return data from the thread when calling a diverse setup of data and when you 
have an error, there doesnt seem to be a great solution for that. The best I could
think of for this one is to, for each pair (the input to the threaded function),
you could prealloc a List and pass a pointer to the preallocated elements
for the threaded function to set when its finished. Even if the type of that element
can be an error union, its just kind of not pretty, I expect future dev on the lang
will help this sort of thing dramatically.

Either way, a full run of this takes about 8m30s on my Framework laptop, which is
coincidentally a perfect amount of time to grab a drink, make some grilled cheese,
and pet my dog for a bit.

![dog](../../assets/day2.jpeg)

(she's doesn't like when I take pictures of her...)