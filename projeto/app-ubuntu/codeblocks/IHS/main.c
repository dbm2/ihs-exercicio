#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <curl/curl.h>
#include <omp.h>

///////////////////////////////////
/////// PARAMETERS FOR HTTP ///////

#define URL "http://192.168.0.12:3000/"
#define SWITCHES_ENDPOINT "switches/"
#define BUTTONS_ENDPOINT "buttons/"
#define DISPLAY_ENDPOINT "display"
#define VALUE_REQUEST "/value/"

//////////////////////////////////////
/////// HTTP REQUEST FUNCTIONS ///////

int getDisplayValue();
bool submitSwitchValue(int id, int value);
bool submitButtonValue(int id, int value);

bool makeRequest(char *requestURL, bool requestIsPost, char *resultString);

///////////////////////////
/////// APPLICATION ///////

void updateDisplayWorker() {
    while (true) {
        int displayValue = getDisplayValue();
        printf("Display Value: %d\n", displayValue);
        Sleep(1000);
    }
}


void submitSwitchesUpdatesWorker() {
    while (true) {
        bool submitSwitchStatus = submitSwitchValue(2, 0);
        if (submitSwitchStatus) {
            printf("Switch setado com sucesso.\n");
        }
        Sleep(1000);
    }
}

void submitButtonsUpdatesWorker() {
    while (true) {
        bool submitButtonStatus = submitButtonValue(3, 1);
        if (submitButtonStatus) {
            printf("Button setado com sucesso.\n");
        }
        Sleep(1000);
    }
}

//curl_global_init(CURL_GLOBAL_ALL); //In Windows, will init winsock stuff
//char requestURL[256];
//snprintf(requestURL, sizeof requestURL, "%s%s%d%s%d", URL, SWITCHES_ENDPOINT, id, VALUE_REQUEST, value);
//




int main() {

    int tid;

    curl_global_init(CURL_GLOBAL_ALL);

    #pragma omp parallel num_threads(3) private(tid)
    {
        tid = omp_get_thread_num();
        if (tid == 0)
            updateDisplayWorker();
        else if (tid == 1)
            submitSwitchesUpdatesWorker();
        else if (tid == 2)
            submitButtonsUpdatesWorker();
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

int getDisplayValue() {

    char requestURL[256];
    snprintf(requestURL, sizeof requestURL, "%s%s%s", URL, DISPLAY_ENDPOINT, VALUE_REQUEST);

    char resultString[256];
    bool getSuccess = makeRequest(requestURL, false, &resultString);

    return atoi(resultString);
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
