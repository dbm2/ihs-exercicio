#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <curl/curl.h>
#include <omp.h>
#include <string.h>
#include <unistd.h>

///////////////////////////////////
/////// PARAMETERS FOR HTTP ///////

#define URL "http://172.22.44.126:3000/"
#define SWITCHES_ENDPOINT "switches/"
#define BUTTONS_ENDPOINT "buttons/"
#define DISPLAY_ENDPOINT "display"
#define VALUE_REQUEST "/value/"

//////////////////////////////////////
/////// HTTP REQUEST FUNCTIONS ///////

bool getDisplayValue(int*);
bool submitSwitchValue(int, int);
bool submitButtonValue(int, int);

bool makeRequest(char*, bool, char*);


/////////////////////////////////
/////// HELPERS FUNCTIONS ///////

void int_to_bin_digit(unsigned int, int, int*)

///////////////////////////
/////// APPLICATION ///////

int displayCurrentValue = -1;
int switchesCurrentValues[18] = {0}, switchesSetedValues[18] = {0};
int buttonsCurrentValue[4] = {0}, buttonsSetedValues[18] = {0};

void consoleDebuggerWorker() {
    while (true) {
        printf("Debug options:\n");
        printf("1 - Set new Switch Value.\n");
        printf("2 - Set new Button Value.\n");

        char c;
        scanf(" %c",&c);
        if (c == '1' || c == '2') {
            int id, value;

            printf("Enter the Switch's (0-17) or Button's (0-3) position.\n");
            scanf(" %d",&id);

            printf("Enter the new value (0 or 1).\n");
            scanf(" %d",&value);

            if (value == 1 || value == 0) {
                if (c == '1' && id >= 0 && id <= 17) {
                    switchesSetedValues[id] = value;
                    usleep(1000);
                } else if (c == '2' && id >= 0 && id <= 3) {
                    buttonsSetedValues[id] = value;
                    usleep(1000);
                }
            }
        }

        printf("\n");
    }
}

void updateDisplayWorker() {
    while (true) {
        //int currentDisplayValue = 0;
        //bool getDisplayStatus = getDisplayValue(&currentDisplayValue);
        //if (getDisplayStatus) {
        //    if (currentDisplayValue != displayCurrentValue) {
        //        printf("Display's value updated to: %d.\n", currentDisplayValue);
        //        displayCurrentValue = currentDisplayValue;
        //    }
        //    usleep(100);
        //} else {
        //    printf("Error: was not possible to get Display's value from server. Trying againg in 10 seconds...\n");
        //    usleep(10000);
        //}
    }
}

void submitSwitchesUpdatesWorker() {
    while (true) {
        //for (int i = 0; i < 18; i++) {
        //    if (switchesCurrentValues[i] != switchesSetedValues[i]) {
        //        printf("New state detected for Switch %d: %d.\n", i, switchesSetedValues[i]);

        //        bool submitSwitchStatus = submitSwitchValue(i, switchesSetedValues[i]);
        //        if (submitSwitchStatus) {
        //            switchesCurrentValues[i] = switchesSetedValues[i];
        //            printf("New value seted for Switch %d: %d.\n", i, switchesSetedValues[i]);
        //        } else {
        //            printf("Error: was not possible to send Switch's value to server. Trying againg in 10 seconds...\n");
        //            usleep(10000);
        //            break;
        //        }
        //    }
        //}
    }
}

void submitButtonsUpdatesWorker() {
    while (true) {
        //for (int i = 0; i < 4; i++) {
        //    if (buttonsCurrentValue[i] != buttonsSetedValues[i]) {
        //        printf("New state detected for Button %d: %d.\n", i, buttonsSetedValues[i]);

        //        bool submitButtonStatus = submitButtonValue(i, buttonsSetedValues[i]);
        //      if (submitButtonStatus) {
        //            buttonsCurrentValue[i] = buttonsSetedValues[i];
        //            printf("New value seted for Button %d: %d.\n", i, buttonsSetedValues[i]);
        //        } else {
        //            printf("Error: was not possible to send Button's value to server. Trying againg in 10 seconds...\n");
        //            usleep(10000);
        //            break;
        //        }
        //    }
        //}
    }
}

void readSwitchesWorker(int *device) {
	int switches;
	read(*device, &switches, 4);
	printf("switches: %d", switches);
	int_to_bin_digit(switches, 18, switchesSetedValues);
}

void readButtonsWorker(int *device) {

}

int main() {

	int device = open("/dev/de2i150_altera", O_RDWR);

    curl_global_init(CURL_GLOBAL_ALL);

    #pragma omp parallel num_threads(4) shared(device)
    {
    	#pragma omp sections 
    	{
    		//#pragma omp section
    		//{
    		//	consoleDebuggerWorker();
    		//}
    		#pragma omp section
    		{
    			updateDisplayWorker();
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
    			readSwitchesWorker(&device);
    		}
    	}
            
    }

    curl_global_cleanup();

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
        /* out of memory! */
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

void int_to_bin_digit(unsigned int in, int count, int* out)
{
    unsigned int mask = 1U << (count-1);
    int i;
    for (i = 0; i < count; i++) {
        out[i] = (in & mask) ? 1 : 0;
        in <<= 1;
    }
}