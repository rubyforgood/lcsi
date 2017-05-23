#include <iostream>
#include <string>

using namespace std;

int main(){
  for (string line; getline(cin, line);) {
    string start = line.substr(0,1);
    cout << line.substr(1, string::npos) << start << "ay" << endl;
  }
  return 0;
}
