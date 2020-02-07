#ifndef SCHOOL_H
#define SCHOOL_H

#include <stddef.h>

// A Generic for printing arrays.
#define print_array(array, n)                 \
        _Generic((*array),                    \
                int:    print_int_array,      \
                char:   print_char_array,     \
                float:  print_float_array,    \
                double: print_double_array)   \
        (array, n)

void print_int_array(const int* array, size_t n);

void print_char_array(const char* array, size_t n);

void print_float_array(const float* array, size_t n);

void print_double_array(const double* array, size_t n);

#endif  // SCHOOL_H
