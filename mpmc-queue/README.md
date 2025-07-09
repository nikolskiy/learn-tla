# Multi-Producer Multi-Consumer (MPMC) Fixed-Size Queue

Let's start with a simple representation.

![queue representation 1](./svg/1-mpmc-queue.svg)

Now let's say producer P1 has a job T that needs to be processed.

![queue representation 2](./svg/2-mpmc-queue.svg)

Since our queue is empty, it puts the job into the first available cell.

![queue representation 3](./svg/3-mpmc-queue.svg)

Now the same producer has another job L.

![queue representation 4](./svg/4-mpmc-queue.svg)

It places it into the second cell.

![queue representation 5](./svg/5-mpmc-queue.svg)

Another job A

![queue representation 6](./svg/6-mpmc-queue.svg)

is placed in the last available cell.

![queue representation 7](./svg/7-mpmc-queue.svg)

If any of the producers have another job, they would have to wait.

![queue representation 8](./svg/8-mpmc-queue.svg)

Now let's say consumer C1 becomes available.

![queue representation 9](./svg/9-mpmc-queue.svg)

It picks up the job from the fist cell. Now there is one more spot.

![queue representation 10](./svg/10-mpmc-queue.svg)

Producers can now put the last job into the available cell.

![queue representation 11](./svg/11-mpmc-queue.svg)

Eventually jobs L and A get picket up by other consumers.

![queue representation 12](./svg/12-mpmc-queue.svg)

We have only last job left. Producers have nothing more to add.

![queue representation 13](./svg/13-mpmc-queue.svg)

All produced jobs are processed. We are back to the original state where we started.

![queue representation 14](./svg/14-mpmc-queue.svg)

Let's note that this is only possible scenario.
Describing them all like that would take a long time.
The picture gives us a general idea how things suppose to work.
