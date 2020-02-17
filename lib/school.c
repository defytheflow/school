#include "school.h"

#include <stdio.h>

void print_int_array(const int* array, size_t n)
{
        printf("[");
        for (size_t i = 0; i < n; ++i) {
                printf("%d, ", array[i]);
        }
        printf("\b\b]\n");
}

void print_char_array(const char* array, size_t n)
{
        printf("[");
        for (size_t i = 0; i < n; ++i) {
                printf("'%c', ", array[i]);
        }
        printf("\b\b]\n");
}

void print_float_array(const float* array, size_t n)
{
        printf("[");
        for (size_t i = 0; i < n; ++i) {
                printf("%.2f, ", array[i]);
        }
        printf("\b\b]\n");
}

void print_double_array(const double* array, size_t n)
{
        printf("[");
        for (size_t i = 0; i < n; ++i) {
                printf("%.2lf, ", array[i]);
        }
        printf("\b\b]\n");
}


void print_generic_array(void* source, int n, int size, void (*print_func)(void *))
{
        printf("[");
        for (int i = 0; i < n; ++i) {
                print_func((char*)source + i * size);
        }
        printf("\b\b]\n");
}
