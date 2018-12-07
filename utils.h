#ifndef UTILS_H
#define UTILS_H

#include <iostream>
#include <exception>
#include <sstream>
#include <fstream>
#include <vector>
#include <sys/time.h>
#include <uchar.h>

using namespace std;


class Timer {
	struct timeval startingTime;
public:
	void set();
	double get();
};

class NotAllowedSymbolException: public exception{
public:
//	virtual const char16_t* what() const throw();
//	cout<<"ERROR: Input may only contain alphanumeric characters.";
};

void saveResults(ofstream& outFile, char16_t* solution);

vector<string> parseFile(ifstream& inFile);

void parseStrings(vector<string> strings,
				  char16_t*& text, int*& indices, int*& suffixIndices,
		int& totalLength, int& numStrings, int& numSuffixes) 
		throw (NotAllowedSymbolException);

void preParseStrings(vector<string> strings,
				  char16_t*& text, int*& indices, int*& suffixIndices,
				  int& totalLength, int& numStrings, int& numSuffixes, int numberOfChildren)
throw (NotAllowedSymbolException);

#endif

