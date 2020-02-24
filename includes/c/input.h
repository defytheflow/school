#ifndef INPUT_H
#define INPUT_H

#include <stddef.h>

/*
 * Reads in at most one less than 'size' characters and stores them into
 * the 'buffer'. Reading stops after an EOF or a newline. If a newline is
 * read, it is stored into the buffer. A terminating null byte ('\0') is
 * stored after the last character in the 'buffer'.
 * Returns the number of characters read into the 'buffer'.
 */
size_t get_line(char* buffer, size_t size);

/*
 * Reads in at most one less than 'size' characters and stores them into
 * the 'buffer'. Reading stops after an EOF or a newline.
 * Newline is not stored into the 'buffer'. A terminating null byte ('\0') is
 * stored after the last character in the 'buffer'.
 * Returns the number of characters read into the 'buffer'.
 */
size_t get_string(char* buffer, size_t size);

#endif  // INPUT_H
