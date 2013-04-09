/* Created by Vitor Shade - 08-04-13 */
#include <iostream>
#include <list>
class BigInt{
public:
    BigInt(std::list<char> n){
        num_ = n;
    }
    BigInt(int n){
        if(n >= 10){
            int d = 0;
            do{
                d = n % 10;
                num_.push_front( d );
                n = n / 10;
            }while(n != 0);
        }else{
            num_.push_front(n);
        }
    }
    inline BigInt operator+(const BigInt&);
    inline void operator=(const BigInt&);
    inline BigInt operator*(const int);
    inline void operator*=(const int);
    inline void operator+=(const BigInt&);
    friend std::ostream& operator<<(std::ostream&, const BigInt&);
    inline void Print() const;
    std::list<char> num_;
};
std::ostream& operator<<(std::ostream& stream, const BigInt& n){
    n.Print();
    return stream;
}
void BigInt::Print() const{
    std::list<char>::const_iterator it;
    for(it = num_.begin(); it != num_.end(); it++){
        std::cout << (int)(*it);
    }
}
BigInt BigInt::operator+(const BigInt& b){
    const std::list<char>* a_op;
    const std::list<char>* b_op;
    if(num_.size() >= b.num_.size()){
        a_op = &this->num_;
        b_op = &(b.num_);
    }else{
        a_op = &(b.num_);
        b_op = &this->num_;
    }
    std::list<char>::const_reverse_iterator a_it = a_op->rbegin();
    std::list<char> result_num;
    int current_carry = 0;
    int next_carry = 0;
    for(std::list<char>::const_reverse_iterator b_it = b_op->rbegin();
        b_it != b_op->rend();
        b_it++){
        int r = (*a_it) + (*b_it) + current_carry;
        if(r >= 10){
            next_carry = r / 10;
            r = r % 10;
        }
        result_num.push_front(r);
        current_carry = next_carry;
        next_carry = 0;
        a_it++;
    }
    if(a_it != a_op->rend()){
        for(; a_it != a_op->rend(); a_it++){
            if(current_carry != 0){
                int r = (*a_it) + current_carry;
                if(r >= 10){
                    next_carry = r / 10;
                    r = r % 10;
                }
                result_num.push_front(r);
                current_carry = next_carry;
                next_carry = 0;
            }else{
                result_num.push_front((*a_it));
            }
        }
        if(current_carry != 0){
            result_num.push_front(current_carry);
        }
    }else{
        if(current_carry != 0){
            result_num.push_front(current_carry);
        }
    }
    return BigInt(result_num);
}
void BigInt::operator=(const BigInt& b){
    this->num_ = b.num_;
}
void BigInt::operator+=(const BigInt& b){
    BigInt result(this->num_);
    this->num_ = (result+b).num_;
}
BigInt BigInt::operator*(const int num){
    BigInt result(0);
    BigInt n(this->num_);
    int count = 0;
    while(count < num){
        result+=n;
        count++;
    }
    return result;
}
void BigInt::operator*=(const int num){
    BigInt op(this->num_);
    this->num_ = (op*num).num_;
}
