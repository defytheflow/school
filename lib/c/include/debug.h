/*
 *  File:       debug.h
 *  Purpose:    macro definitions for debugging
 *
 *  Defined macros:
 *      dbprintf(format, ...)
 */
#ifndef DEBUG_H
#define DEBUG_H

#include <stdio.h>

/*
 * Works like fprintf(stderr, format, ...).
 * Prints file name, line number, function name before 'format'.
 */
#define dbprintf(format, ...)                              \
        fprintf(stderr, "%s:%d:%s(): " format, __FILE__,  \
                __LINE__, __func__, ##__VA_ARGS__)        \

#endif  // DEBUG_H
