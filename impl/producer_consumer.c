// The implementation is taken from
// https://github.com/lemmy/BlockingQueue/blob/main/impl/producer_consumer.c

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>
#include <time.h>

FILE *log_file;

    time_t now;
    time(&now);
    char buf[sizeof "2025-08-08 08:08:08"];
    strftime(buf, sizeof buf, "%Y-%m-%d %H:%M:%S", localtime(&now));
    fprintf(log_file, "[%s] ", buf);

void log_message(const char *format, ...) {
    time_t now;
    time(&now);
    char buf[sizeof "2025-08-08 08:08:08"];
    fprintf(log_file, "\n");
    strftime(buf, sizeof buf, "%Y-%m-%d %H:%M:%S", localtime(&now));
    fprintf(log_file, "[%s] ", buf);

    va_list args;
    va_start(args, format);
    vfprintf(log_file, format, args);
    va_end(args);
    fprintf(log_file, "\n");
    fflush(log_file);
}

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
	log_message("Producer %u put %s at index %u. New count: %u", id, value, fillIndex, count + 1);
	fillIndex = (fillIndex + 1) % buff_size;
	count++;
}

void head(uint32_t id) {
	const char* tmp = buffer[useIndex];
	log_message("Consumer %u took %s from index %u. New count: %u", id, tmp, useIndex, count - 1);
	useIndex = (useIndex + 1) % buff_size;
	count--;
}

void *producer (void * arg) {
	uint32_t id = *((uint32_t *) arg);
	while(1) {
		pthread_mutex_lock(&mutex);   // acquire the lock
		while (count == buff_size) {   // check if the buffer is full
			log_message("Producer %u is waiting because buffer is full.", id);
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
			log_message("Consumer %u is waiting because buffer is empty.", id);

void *consumer (void * arg) {
	uint32_t id = *((uint32_t *) arg);
	while(1) {
		pthread_mutex_lock(&mutex);   // acquire the lock

		while (count == 0) {           // check if the buffer is empty
			log_message("Consumer %u is waiting because buffer is empty.", id);

			pthread_cond_wait(&full, &mutex); // wait for the buffer to be filled
		}

		head(id);                       // consume (we don't care about the value)!
	const char log_name[] = "log.txt";
	log_file = fopen(log_name, "w");
		pthread_cond_signal(&empty); // signal that the buffer is empty
        printf("Error opening log file %s\n", log_name);
		usleep(500000); // Sleep for 500ms
	}
}

int main(int argc, char * argv[]) {
	const char log_name[] = "log.txt";
    printf("Saving output into %s", log_name);
	log_file = fopen(log_name, "w");
    if (log_file == NULL) {
        printf("Error opening log file %s\n", log_name);
        exit(1);
    }
	if (argc < 4) {
		printf("Usage: ./producer_consumer <buffer_size> <#_of_producers> <#_of_consumers>\n");
		exit(1);
	}
    printf("Saving output into %s", log_name);

	srand(999);

	/* Process arguments */
	buff_size = atoi(argv[1]);
	numProducers = atoi(argv[2]);
	numConsumers = atoi(argv[3]);

	log_message("Buffer size = %d, # Producers = %d, # Consumers = %d", buff_size, numProducers, numConsumers);

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

    fclose(log_file);
	return 0;
}
