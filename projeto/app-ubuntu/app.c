#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <curl/curl.h>
#include <omp.h>
#include <string.h>
#include <unistd.h>
#include <math.h>

///////////////////////////////////
/////// PARAMETERS FOR HTTP ///////

#define URL "http://172.22.44.126:3000/"
#define SWITCHES_ENDPOINT "switches/"
#define BUTTONS_ENDPOINT "buttons/"
#define DISPLAY_ENDPOINT "display"
#define VALUE_REQUEST "/value/"

//////////////////////////////////////
/////// HTTP REQUEST FUNCTIONS ///////

bool getDisplayValue(int *valueResult);
bool submitSwitchValue(int id, int value);
bool submitButtonValue(int id, int value);

bool makeRequest(char *requestURL, bool requestIsPost, char *resultString);


/////////////////////////////////
/////// HELPERS FUNCTIONS ///////

void int_to_bin_digit(int in, int count, int* out);

///////////////////////////
/////// APPLICATION ///////

unsigned char intDigit[] = {64, 121, 36, 48,
                            25, 18, 2, 120, 
                            0, 16};

unsigned char hexdigit[] = {0x3F, 0x06, 0x5B, 0x4F,
                            0x66, 0x6D, 0x7D, 0x07, 
                            0x7F, 0x6F, 0x77, 0x7C,
                            0x39, 0x5E, 0x79, 0x71};

int displayCurrentValue = -1;
int switchesCurrentValues[18] = {0}, switchesSetedValues[18] = {0};
int buttonsCurrentValue[4] = {1}, buttonsSetedValues[4] = {1};

int parseIntegerToDisplay(int value) {

    uint8_t n1 = value / 1000;
    uint8_t n2 = (value / 100) % 10;
    uint8_t n3 = (value / 10) % 10;
    uint8_t n4 = value % 10;

    printf("n1: %d\n", n1);
    printf("n2: %d\n", n2);
    printf("n3: %d\n", n3);
    printf("n4: %d\n", n4);

    int displayValue = intDigit[n4] | intDigit[n3];

    printf("display: %d\n", displayValue);

    return displayValue;
}

void updateDisplayWorker(int *device) {
    while (true) {
        int currentDisplayValue = 0;

        bool getDisplayStatus = getDisplayValue(&currentDisplayValue);

        if (getDisplayStatus) {
            if (currentDisplayValue != displayCurrentValue) {
                printf("Display's value updated to: %d.\n", currentDisplayValue);
                displayCurrentValue = currentDisplayValue;

				int valueParsed = hexdigit[currentDisplayValue & 0xF]
				      | (hexdigit[(currentDisplayValue >>  4) & 0xF] << 8)
				      | (hexdigit[(currentDisplayValue >>  8) & 0xF] << 16)
				      | (hexdigit[(currentDisplayValue >> 12) & 0xF] << 24);
				valueParsed = ~valueParsed;

                //int valueParsed = parseIntegerToDisplay(currentDisplayValue);

   				write(*device, &valueParsed, 4);
            }
        }
    }
}

void submitSwitchesUpdatesWorker() {
    while (true) {
        for (int i = 0; i < 18; i++) {
            if (switchesCurrentValues[i] != switchesSetedValues[i]) {
                printf("New state detected for Switch %d: %d.\n", i, switchesSetedValues[i]);

                bool submitSwitchStatus = submitSwitchValue(i, switchesSetedValues[i]);

                if (submitSwitchStatus) {
                    switchesCurrentValues[i] = switchesSetedValues[i];
                    printf("New value seted for Switch %d: %d.\n", i, switchesSetedValues[i]);
                }
            }
        }
    }
}

void submitButtonsUpdatesWorker() {
    while (true) {
        for (int i = 0; i < 4; i++) {
            if (buttonsCurrentValue[i] != buttonsSetedValues[i]) {
                printf("New state detected for Button %d: %d.\n", i, buttonsSetedValues[i]);

              	bool submitButtonStatus = submitButtonValue(i, buttonsSetedValues[i]);
 
              	if (submitButtonStatus) {
                    buttonsCurrentValue[i] = buttonsSetedValues[i];
                    printf("New value seted for Button %d: %d.\n", i, buttonsSetedValues[i]);
                }
            }
        }
    }
}

void readInputsWorker(int *device) {
    while (true) {
        int switches = 1 + '0';
        read(*device, &switches, 4);
		int_to_bin_digit(switches, 18, switchesSetedValues);

        int buttons = 2 + '0';
        read(*device, &buttons, 4);
		int_to_bin_digit(buttons, 4, buttonsSetedValues);
	}
}


int main() {

    int device = open("/dev/de2i150_altera", O_RDWR);

    curl_global_init(CURL_GLOBAL_ALL);

    #pragma omp parallel num_threads(4) shared(device)
    {
    	#pragma omp sections 
    	{
    		#pragma omp section
    		{
    			updateDisplayWorker(&device);
    		}
    		#pragma omp section
    		{
    			submitSwitchesUpdatesWorker();
    		}
    		#pragma omp section
    		{
    			submitButtonsUpdatesWorker();
    		}
			#pragma omp section
			{
				readInputsWorker(&device);
			}
    	}
            
    }

    curl_global_cleanup();

  	close(device);

    return 0;
}


bool submitSwitchValue(int id, int value) {
    char requestURL[256];
    snprintf(requestURL, sizeof requestURL, "%s%s%d%s%d", URL, SWITCHES_ENDPOINT, id, VALUE_REQUEST, value);

    bool submitSuccess = makeRequest(requestURL, true, NULL);

    return submitSuccess;
}

bool submitButtonValue(int id, int value) {
    char requestURL[256];
    snprintf(requestURL, sizeof requestURL, "%s%s%d%s%d", URL, BUTTONS_ENDPOINT, id, VALUE_REQUEST, value);

    bool submitSuccess = makeRequest(requestURL, true, NULL);

    return submitSuccess;
}

bool getDisplayValue(int *valueResult) {

    char requestURL[256];
    snprintf(requestURL, sizeof requestURL, "%s%s%s", URL, DISPLAY_ENDPOINT, VALUE_REQUEST);

    char *resultString = (char*) malloc(sizeof(char) * 256);
    bool getSuccess = makeRequest(requestURL, false, resultString);

    *valueResult =  atoi(resultString);

    return getSuccess;
}

////////////////////////////////////////////////////
/////// HELPERS FOR HANDLE HTTP GET RESPONSE ///////

struct MemoryStruct {
  char *memory;
  size_t size;
};

static size_t WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp) {
    size_t realsize = size * nmemb;
    struct MemoryStruct *mem = (struct MemoryStruct *)userp;

    mem->memory = realloc(mem->memory, mem->size + realsize + 1);
    if(mem->memory == NULL) {
        printf("not enough memory (realloc returned NULL)\n");
        return 0;
    }

    memcpy(&(mem->memory[mem->size]), contents, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;

    return realsize;
}

bool makeRequest(char *requestURL, bool requestIsPost, char *resultString) {
    CURL *curl = curl_easy_init();

    bool success = false;

    if (curl) {
        struct MemoryStruct chunk;
        chunk.memory = malloc(1);
        chunk.size = 0;

        curl_easy_setopt(curl, CURLOPT_URL, requestURL);

        if (requestIsPost)
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "");

        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&chunk);
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

        CURLcode res = curl_easy_perform(curl);

        if (res == CURLE_OK) {
            success = true;
            if (resultString != NULL)
                strcpy(resultString, chunk.memory);
        }

        curl_easy_cleanup(curl);
    }

    return success;
}


////////////////////////
/////// HELPERS ///////

void int_to_bin_digit(int in, int count, int* out) {

    unsigned int mask = 1U << (count - 1);

    for (int i = count - 1; i >= 0; i--, in <<= 1)
        out[i] = (in & mask) ? 1: 0;
}
