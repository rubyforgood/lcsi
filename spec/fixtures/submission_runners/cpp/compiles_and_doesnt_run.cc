#include <stdexcept>

int main(){
  throw std::invalid_argument( "this failure result is expected" );
}
