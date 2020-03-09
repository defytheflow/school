#include <random.h>

#include <assert.h>
#include <stdlib.h>
#include <time.h>

int rand_int(int min, int max)
/* Returns a pseudo-random integer in range[min, max]. */
{
        return (rand() % (max - min + 1)) + min;
}

void randomize_array(int* array, size_t size, int min, int max)
/* Fills 'array' with 'size' random integers in range[min, max]. */
{
        assert(array != NULL && "'randomize_array' - null pointer error.");

        for (size_t i = 0; i < size; ++i)
                array[i] = rand_int(min, max);
}
