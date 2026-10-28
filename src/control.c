#include "socket_client.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
    if(argc < 2) {
        fprintf(stderr, "Usage: pedalctl <status|state|clean|effect|toggle|amount|board|config|tuner|midi-events|lv2-list|lv2-load> [arguments]\n");
        return 2;
    }
    char command[4096] = "";
    size_t used = 0;
    for(int i = 1; i < argc; ++i) {
        int count = snprintf(command + used, sizeof(command) - used, "%s%s", i == 1 ? "" : " ", argv[i]);
        if(count < 0 || (size_t)count >= sizeof(command) - used) {
            fprintf(stderr, "command is too long\n");
            return 2;
        }
        used += (size_t)count;
    }
    char *reply = pedal_send(command);
    if(!reply) { fprintf(stderr, "pedalctl: %s: %s\n", pedal_socket_path(), strerror(errno)); return 1; }
    fputs(reply, stdout);
    int failed = strncmp(reply, "error:", 6) == 0;
    free(reply);
    return failed ? 1 : 0;
}
