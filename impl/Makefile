all: producer_consumer

trace: producer_consumer.c
	gcc -DNDEBUG -DTRACE producer_consumer.c -o producer_consumer -pthread

producer_consumer: producer_consumer.c
	gcc -DNDEBUG producer_consumer.c -o producer_consumer -pthread

clean:
	rm -f producer_consumer log.txt
