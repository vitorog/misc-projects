#ifndef BIG_INT_H
#define BIG_INT_H

#include <iostream>
#include <list>

class BigInt{
public:
    BigInt(std::list<char> n);
    BigInt(int n);
    inline void operator=(const BigInt&);
    inline BigInt operator*(const int);
    inline void operator*=(const int);
    friend std::ostream& operator<<(std::ostream&, const BigInt&);
    inline void Print() const;
    std::list<char> num_;
};

#endif // BIG_INT_H
