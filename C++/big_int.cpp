/* Created by Vitor Shade - 08-04-13 */
#include "big_int.h"

std::ostream& operator<<(std::ostream& stream, const BigInt& n){
    n.Print();
    return stream;
}

BigInt::BigInt(std::list<char> n){
    num_ = n;
}

BigInt::BigInt(int n){
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

void BigInt::Print() const{
    std::list<char>::const_iterator it;
    for(it = num_.begin(); it != num_.end(); it++){
        std::cout << (int)(*it);
    }
}

void BigInt::operator=(const BigInt& b){
    this->num_ = b.num_;
}

BigInt BigInt::operator*(const int num)
{
    int carry = 0;
    std::list<char>::reverse_iterator it;
    std::list<char> result_;
    for(it = num_.rbegin(); it!= num_.rend(); it++){
        int r = ((*it)*num)+carry;
        if(r>=10){
            carry=r/10;
            r%=10;
        }
        result_.push_front(r);
    }
    while(carry!=0){
        result_.push_front(carry%10);
        carry/=10;
    }
    return BigInt(result_);
}

void BigInt::operator*=(const int num){
    BigInt op(this->num_);
    this->num_ = (op*num).num_;
}

int main()
{
    BigInt n(10);
    std::cout << n*125891280 << std::endl;
    return 0;
}
