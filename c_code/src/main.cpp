#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <paths.h>
#include <termios.h>
#include <sysexits.h>
#include <sys/param.h>
#include <sys/select.h>
#include <sys/time.h>
#include <time.h>
#include <cassert>
#include <iostream>


using namespace std;

void write_int(const int fileID, const int value)
{
	int wBytes = write( fileID, &value, sizeof(int) );
	assert( wBytes == (sizeof(int)) );
}

int read_int(const int fileID)
{
	int value;
    int rBytes = read( fileID, &value, sizeof(int) );
    assert( rBytes == (sizeof(int)) );
	return value;
}

int main (int argc, char * argv []){

	cout << "(II) Initialisation des composants..." << endl;

    int fileID = -1;
    
    fileID = open("/dev/ttyUSB1", O_RDWR | O_NOCTTY );
    if(fileID == -1)
    {
        printf("Impossible d'ouvrir ttyUSB1 !\n");
        return -1;
    }

    struct termios t;
    tcgetattr(fileID, &t); // recupère les attributs
    cfmakeraw(&t); // Reset les attributs
    t.c_cflag     = CREAD | CLOCAL;     // turn on READ
    t.c_cflag    |= CS8;
    t.c_cc[VMIN]  = 0;
    t.c_cc[VTIME] = 255;     // 5 sec timeout

    cfsetispeed(&t, B921600);
    cfsetospeed(&t, B921600);
    tcsetattr(fileID, TCSAFLUSH, &t); // envoie le tout au driver    

	uint8_t table[128];
	for(uint8_t x = 0; x < 128; x += 1)
	{  
        table[x] = rand()%256;
    }
	for(uint8_t x = 0; x < 128; x += 1)
	{  
        if( x%32 == 0 ) printf("\n");
        printf("%3d ", table[x]);
    }
    printf("\n");
    printf("\n");

    
	for(uint8_t x = 0; x < 128; x += 1)
	{  
        int wBytes = write( fileID, table + x, sizeof(uint8_t) );
        assert( wBytes == (sizeof(uint8_t)) );
    }

   	uint8_t results[128];
	for(uint8_t x = 0; x < 128; x += 1)
	{  
        int rBytes = read( fileID, results + x, sizeof(uint8_t) );
        assert( rBytes == (sizeof(uint8_t)) );
    }

    
    for(uint8_t x = 0; x < 128; x += 1)
	{  
        if( x%32 == 0 ) printf("\n");
        printf("%3d ", results[x]);
    }
    printf("\n");
    printf("\n");

    close( fileID );
    
    return 0;
}
