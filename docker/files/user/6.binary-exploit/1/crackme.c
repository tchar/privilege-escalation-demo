#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]){ 
	if(argc==2){
		printf("Checking Licence: %s\n", argv[1]);
		if(strcmp(argv[1], "hello_stranger")==0){
			printf("Access Granted!\n");
			printf("Your are 1337 h4xx0r\n");
		}
		else{
			printf("Wrong!\n");
		}	
	}
	else{
		fprintf(stderr, "Usage: %s <name>\n", argv[0]);
		return 1;
	}
	
	return 0;
}
