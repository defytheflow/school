#include <cmath>
#include <cstdlib>

#include <string>
#include <vector>

#include <iomanip>
#include <iostream>
#include <fstream>
#include <sstream>

#include <stdexcept>

using namespace std;

inline void simple_error(const string& s)
/* Write "Error: 's'" and exit the program. */
{
    cerr << "Error: " << s << '\n';
    exit(1);
}

inline void error(const string& s)
/* Just throws an exception. */
{
    throw runtime_error(s);
}

inline void error(const string&s, const string& s2)
{
    throw runtime_error(s + s2);
}
