#include "implementation.h"

__global__ void constructSuffixTree(Node* root, char16_t* text, int* indices, int totalLength, int numStrings){
	const int tid = threadIdx.x + blockDim.x*blockIdx.x;
	const int nThreads = blockDim.x*gridDim.x;
	const int iter = numStrings%nThreads == 0? numStrings/nThreads : numStrings/nThreads+1;

	for(int i = 0; i < iter; i++){
		int dataid = tid + i*nThreads;
		if(dataid < numStrings){
			int start = indices[dataid];
			int end = dataid == numStrings-1? totalLength : indices[dataid+1];
			for(; text[start] != '#'; start++){
			char16_t c = text[start];
			char16_t index = charToIndex(c);
				Node** address = &(root->children[index]);
				Node* child = *address;
				if(child == NULL){
					child = createNode(start,end);
					addNode(address,child,text);
				} else {
					child = createNode(start,end);
					combineNode(address,child,text);
				}
			}
		}
	}
}

char16_t* impl1(char16_t* text, int* indices, int totalLength, int numStrings, int bsize, int bcount){
	Timer timer;
	Node root;
	root.start=0;
	root.end=0;
	for(int i = 0; i < NUM_CHILDREN; i++)
		root.children[i] = NULL;
	root.suffixIndex = 0;

	char16_t* d_text = NULL;
        int* d_indices = NULL;
	Node* d_root = NULL;

        cudaMalloc((void**)&d_text, sizeof(char16_t)*totalLength);
        cudaMalloc((void**)&d_indices, sizeof(int)*numStrings);
        cudaMalloc((void**)&d_root, sizeof(Node));

        cudaMemcpy(d_text, text, sizeof(char16_t)*totalLength, cudaMemcpyHostToDevice);
        cudaMemcpy(d_indices, indices, sizeof(int)*numStrings, cudaMemcpyHostToDevice);
	cudaMemcpy(d_root,&root,sizeof(Node),cudaMemcpyHostToDevice);

	timer.set();

	constructSuffixTree<<<bcount,bsize>>>(d_root,d_text,d_indices,totalLength,numStrings);

	CUDAErrorCheck(cudaPeekAtLastError());
	CUDAErrorCheck(cudaDeviceSynchronize());
	
	cout << "impl1 stringPerThread running time: " << timer.get() << " ms" << endl;

//	printTree<<<1,1>>>(d_root,d_text);
	//cudaDeviceSynchronize();

	char16_t* output = NULL;
	int size = getSerialSuffixTree(d_root,d_text,&output);
	printf("Output size: %d\n",size);

	// free
	cudaFree(d_text);
	cudaFree(d_indices);
	cudaFree(d_root);

	return output;
}

