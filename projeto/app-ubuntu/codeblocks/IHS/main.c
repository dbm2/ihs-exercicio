#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <pthread.h>
#include <curl/curl.h>

///////////////////////////////////
/////// PARAMETERS FOR HTTP ///////

#define URL "http://192.168.0.12:3000"
#define SWITCHES_ENDPOINT "/switches/"
#define BUTTONS_ENDPOINT "/buttons/"
#define DISPLAY_ENDPOINT "/display/"
#define VALUE_REQUEST "/value/"

//////////////////////////////////////
/////// HTTP REQUEST FUNCTIONS ///////

bool submitSwitchValue();
bool submitButtonValue();
int getDisplayValue();

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

int stringToInt(char* string) {
    int len = strlen(string);
    int value = 0, i;

	for(i = 0; i < len; i++){
		value = value * 10 + ( string[i] - '0' );
	}

	return value;
}

///////////////////////////
/////// APPLICATION ///////

void *updateDisplayWorker(void *args){
   while (true) {
        int displayValue = getDisplayValue();
        printf("\nDisplay Value: %d", displayValue);
        Sleep(500);
    }

    return NULL;
}

int main() {


    bool submitSwitchStatus = submitSwitchValue(2, 0);
    if (submitSwitchStatus) {
        printf("\nSwitch setado com sucesso.\n");
    }

    bool submitButtonStatus = submitButtonValue(3, 1);
    if (submitButtonStatus) {
        printf("\nButton setado com sucesso.");
    }

    pthread_t thread_id;
    pthread_create(&thread_id, NULL, updateDisplayWorker, NULL);
    pthread_join(thread_id, NULL);

    return 0;
}

bool submitSwitchValue(int id, int value) {
    CURL *curl;
    CURLcode res;
    bool success = false;

    curl_global_init(CURL_GLOBAL_ALL); //In Windows, will init winsock stuff

    curl = curl_easy_init();
    if(curl) {
        char requestURL[256];
        snprintf(requestURL, sizeof requestURL, "%s%s%d%s%d", URL, SWITCHES_ENDPOINT, id, VALUE_REQUEST, value);

        curl_easy_setopt(curl, CURLOPT_URL, requestURL);

        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "");

        res = curl_easy_perform(curl);

        success = (res == CURLE_OK);

        curl_easy_cleanup(curl);
    }

    curl_global_cleanup();

    return success;
}

bool submitButtonValue(int id, int value) {
    CURL *curl;
    CURLcode res;
    bool success = false;

    curl_global_init(CURL_GLOBAL_ALL); //In Windows, will init winsock stuff

    curl = curl_easy_init();
    if(curl) {
        char requestURL[256];
        snprintf(requestURL, sizeof requestURL, "%s%s%d%s%d", URL, BUTTONS_ENDPOINT, id, VALUE_REQUEST, value);

        curl_easy_setopt(curl, CURLOPT_URL, requestURL);

        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "");

        res = curl_easy_perform(curl);

        success = (res == CURLE_OK);

        curl_easy_cleanup(curl);
    }

    curl_global_cleanup();

    return success;
}

int getDisplayValue() {
    CURL *curl;
    CURLcode res;
    struct MemoryStruct chunk;

    int displayValue = 0;

    chunk.memory = malloc(1);
    chunk.size = 0;

    curl_global_init(CURL_GLOBAL_ALL);

    curl = curl_easy_init();
    if(curl) {
        char requestURL[256];
        snprintf(requestURL, sizeof requestURL, "%s%s%s", URL, DISPLAY_ENDPOINT, VALUE_REQUEST);

        curl_easy_setopt(curl, CURLOPT_URL, requestURL);

        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);

        curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)&chunk);

        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

        res = curl_easy_perform(curl);
        if(res == CURLE_OK) {
            displayValue = stringToInt(chunk.memory);
        }

        curl_easy_cleanup(curl);

        free(chunk.memory);
    }

    curl_global_cleanup();

    return displayValue;
}
