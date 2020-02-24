#include "input.h"

#include <stdio.h>
#include <assert.h>

size_t get_line(char* buffer, size_t size)
/*
 * Reads in at most one less than 'size' characters and stores them into
 * the 'buffer'. Reading stops after an EOF or a newline. If a newline is
 * read, it is stored into the buffer. A terminating null byte ('\0') is
 * stored after the last character in the 'buffer'.
 * Returns the number of characters read into the 'buffer'.
 */
{
        assert(buffer != NULL && "'get_line' - null pointer error.");

        int c, i;

        i = 0;
        while ((c = getchar()) != EOF && c != '\n' && i < size - 1)
                buffer[i++] = c;

        if (c == '\n')
                buffer[i++] = c;

        buffer[i] = '\0';
        return i;
}

size_t get_string(char* buffer, size_t size)
/*
 * Reads in at most one less than 'size' characters and stores them into
 * the 'buffer'. Reading stops after an EOF or a newline.
 * Newline is not stored into the 'buffer'. A terminating null byte ('\0') is
 * stored after the last character in the 'buffer'.
 * Returns the number of characters read into the 'buffer'.
 */
{
        assert(buffer != NULL && "'get_line' - null pointer error.");

        int c, i;

        i = 0;
        while ((c = getchar()) != EOF && c != '\n' && i < size - 1)
                buffer[i++] = c;

        buffer[i] = '\0';
        return i;
}

