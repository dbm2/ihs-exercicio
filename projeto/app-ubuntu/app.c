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

int displayCurrentValue = -1;
int switchesCurrentValues[18] = {0}, switchesSetedValues[18] = {0};
int buttonsCurrentValue[4] = {1}, buttonsSetedValues[18] = {1};

void updateDisplayWorker() {
    while (true) {
        //int currentDisplayValue = 0;
        //bool getDisplayStatus = getDisplayValue(&currentDisplayValue);
        //if (getDisplayStatus) {
        //    if (currentDisplayValue != displayCurrentValue) {
        //        printf("Display's value updated to: %d.\n", currentDisplayValue);
        //        displayCurrentValue = currentDisplayValue;
        //    }
        //    sleep(100);
        //} else {
        //    printf("Error: was not possible to get Display's value from server. Trying againg in 10 seconds...\n");
        //    sleep(10000);
        //}
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
                } else {
                    printf("Error: was not possible to send Switch's value to server. Trying againg in 10 seconds...\n");
                    sleep(10000);
                    break;
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
                } else {
                    printf("Error: was not possible to send Button's value to server. Trying againg in 10 seconds...\n");
                    sleep(10000);
                    break;
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
		int_to_bin_digit(buttons, 18, buttonsSetedValues);
    }
}


int main() {

    int device = open("/dev/de2i150_altera", O_RDWR);

    curl_global_init(CURL_GLOBAL_ALL);

    #pragma omp parallel num_threads(3) shared(device)
    {
    	#pragma omp sections 
    	{
    		//#pragma omp section
    		//{
    		//	updateDisplayWorker();
    		//}
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

    //curl_global_cleanup();

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
