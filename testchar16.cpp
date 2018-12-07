//
// Created by user on 12/7/18.
//

#include <iostream>
#include <fstream>
#include <vector>
#include <numeric>
#include "cuda_error_check.h"
#include "implementation.h"
#include "utils.h"
#include "sequential.cpp"
#include <uchar.h>


int main(){




for(int i=0;i<1009;i++) {
    char16_t c=i;
//    c[1]= i;
    wcout << (wchar_t)c;
    }

return 0;
}

///usr/local/cuda/bin/nvcc -o testchar16 testchar16.cu