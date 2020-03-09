#ifndef RANDOM_H
#define RANDOM_H

#include <stddef.h>

/* Returns a pseudo-random integer in range[min, max]. */
int rand_int(int min, int max);

/* Fills 'array' with 'size' random integers in range[min, max]. */
void randomize_array(int* array, size_t size, int min, int max);

#endif  // RANDOM_H
