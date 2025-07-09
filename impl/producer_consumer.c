// The implementation is taken from
// https://github.com/lemmy/BlockingQueue/blob/main/impl/producer_consumer.c

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>

uint32_t buff_size, numProducers, numConsumers;
char (*buffer)[3];
// `fillIndex` is the index where the next item will be placed in the buffer.
uint32_t fillIndex = 0;
// `useIndex` is the index of the next item to be removed from the buffer.
uint32_t useIndex = 0;
// `count` is the number of items currently in the buffer.
uint32_t count = 0;

// See https://stackoverflow.com/a/2087046/6291195 to relate this to the Java impl.
pthread_cond_t empty, full;
pthread_mutex_t mutex;

void append(const char* value, uint32_t id) {
	strcpy(buffer[fillIndex], value);
	printf("Producer %u put \"%s\" at index %u. New count: %u\n", id, value, fillIndex, count + 1);
	fillIndex = (fillIndex + 1) % buff_size;
	count++;
}

void head(uint32_t id) {
	const char* tmp = buffer[useIndex];
	printf("Consumer %u took \"%s\" from index %u. New count: %u\n", id, tmp, useIndex, count - 1);
	useIndex = (useIndex + 1) % buff_size;
	count--;
}

void *producer (void * arg) {
	uint32_t id = *((uint32_t *) arg);
	while(1) {
		pthread_mutex_lock(&mutex);   // acquire the lock
		while (count == buff_size) {   // check if the buffer is full
			printf("Producer %u: buffer full, waiting...\n", id); fflush(stdout);
		    pthread_cond_wait(&empty, &mutex);
		}

		char value[3];
		value[0] = 'a' + (rand() % 26);
		value[1] = '0' + (id % 10);
		value[2] = '\0';
		append(value, id);        // produce!

		pthread_cond_signal(&full); // broadcast that the buffer is full
        pthread_mutex_unlock(&mutex); // release the lock
		usleep(500000); // Sleep for 500ms
	}
}

void *consumer (void * arg) {
	uint32_t id = *((uint32_t *) arg);
	while(1) {
		pthread_mutex_lock(&mutex);   // acquire the lock

		while (count == 0) {           // check if the buffer is empty
			printf("Consumer %u: buffer empty, waiting...\n", id); fflush(stdout);

			pthread_cond_wait(&full, &mutex); // wait for the buffer to be filled
		}

		head(id);                       // consume (we don't care about the value)!

		pthread_cond_signal(&empty); // signal that the buffer is empty
		pthread_mutex_unlock(&mutex); // release the lock
		usleep(500000); // Sleep for 500ms
	}
}

int main(int argc, char * argv[]) {
	if (argc < 4) {
		printf ("Usage: ./producer_consumer <buffer_size> <#_of_producers> <#_of_consumers> \n");
		exit(1);
	}

	srand(999);

	/* Process arguments */
	buff_size = atoi(argv[1]);
	numProducers = atoi(argv[2]);
	numConsumers = atoi(argv[3]);

	printf("Buffer size = %d, # Producers = %d, # Consumers = %d\n", buff_size, numProducers, numConsumers);

	pthread_mutex_init(&mutex, NULL);
	pthread_cond_init(&empty, NULL);
	pthread_cond_init(&full, NULL);

	/* Allocate space for the buffer */
	buffer = malloc(buff_size * sizeof(char[3]));
	pthread_t prods[numProducers], cons[numConsumers];
	uint32_t producerThreadIds[numProducers];
	uint32_t consumerThreadIds[numConsumers];

	uint32_t i;
	/* Create the producer */
	for (i = 0; i < numProducers ; i++) {
		producerThreadIds[i] = i;
		pthread_create(&prods[i], NULL, producer, &producerThreadIds[i]);
	}

	/* Create the consumers */
	for (i = 0; i < numConsumers; i++) {
		consumerThreadIds[i] = i;
		pthread_create(&cons[i], NULL, consumer, &consumerThreadIds[i]);
	}

	/* Wait for all threads to finish */
	for (i = 0; i < numProducers ; i++)
		pthread_join(prods[i], NULL);

	for (i = 0; i < numConsumers; i++)
		pthread_join(cons[i], NULL);

	return 0;
}
