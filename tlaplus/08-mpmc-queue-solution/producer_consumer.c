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

FILE *log_file;
time_t last_log_time;

void log_message(const char *format, ...) {
    time(&last_log_time);
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
    fflush(log_file);
}

void *heartbeat_monitor(void *arg) {
    int dot_counter = 0;
	printf("\nHeartbeat monitor:\n");
    while (1) {
        time_t current_time;
        time(&current_time);
        if (difftime(current_time, last_log_time) > 15) {
            printf("\nError: No log message for 15 seconds. Stopping everything.\n");
            exit(1);
        }
        if (difftime(current_time, last_log_time) > 1) {
            printf("-");
        }
		else {
			printf(".");
		}
        fflush(stdout);
        dot_counter++;
        if (dot_counter % 30 == 0) {
            printf("\n");
        }
        sleep(1);
    }
    return NULL;
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
pthread_cond_t consumers, producers;
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
		while (count == buff_size) {  // check if the buffer is full
			log_message("Producer %u is waiting because the buffer is full.", id);
		    pthread_cond_wait(&producers, &mutex); // wait for changes in the buffer
		}

		char value[3];
		value[0] = 'a' + (rand() % 26);
		value[1] = '0' + (id % 10);
		value[2] = '\0';
		append(value, id);            // produce!

		pthread_cond_signal(&consumers); // signal that we updated the buffer
        pthread_mutex_unlock(&mutex); // release the lock
		// usleep(500000); // Sleep for 500ms
	}
}

void *consumer (void * arg) {
	uint32_t id = *((uint32_t *) arg);
	while(1) {
		pthread_mutex_lock(&mutex);   // acquire the lock

		while (count == 0) {          // check if the buffer is empty
			log_message("Consumer %u is waiting because the buffer is empty.", id);
			pthread_cond_wait(&consumers, &mutex); // wait for changes in the buffer
		}

		head(id);                      // consume (we don't care about the value)!
		pthread_cond_signal(&producers);  // signal that we updated the buffer
        pthread_mutex_unlock(&mutex);  // release the lock
		// usleep(500000); // Sleep for 500ms
	}
}

int main(int argc, char * argv[]) {
	const char log_name[] = "log.txt";
    printf("Saving output into %s \n", log_name);
	log_file = fopen(log_name, "w");
    if (log_file == NULL) {
        fprintf(stderr, "Error opening log file. \n");
        exit(1);
    }
	if (argc < 4) {
		printf("Usage: ./producer_consumer <buffer_size> <#_of_producers> <#_of_consumers> \n");
		exit(1);
	}

	srand(999);

	/* Process arguments */
	buff_size = atoi(argv[1]);
	numProducers = atoi(argv[2]);
	numConsumers = atoi(argv[3]);

	log_message("Buffer size = %d, # Producers = %d, # Consumers = %d", buff_size, numProducers, numConsumers);

	pthread_mutex_init(&mutex, NULL);
	pthread_cond_init(&consumers, NULL);
	pthread_cond_init(&producers, NULL);

	/* Allocate space for the buffer */
	buffer = malloc(buff_size * sizeof(char[3]));
	pthread_t prods[numProducers], cons[numConsumers];
	uint32_t producerThreadIds[numProducers];
	uint32_t consumerThreadIds[numConsumers];

    pthread_t heartbeat_thread;
    pthread_create(&heartbeat_thread, NULL, heartbeat_monitor, NULL);

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

	pthread_join(heartbeat_thread, NULL);

    fclose(log_file);
	return 0;
}
