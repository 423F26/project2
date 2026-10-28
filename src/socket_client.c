#define _POSIX_C_SOURCE 200809L
#include "socket_client.h"

#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/un.h>
#include <unistd.h>

const char *pedal_socket_path(void)
{
    const char *path = getenv("PEDAL_CONTROL_SOCKET");
    return path && *path ? path : "/run/guitar-effect.sock";
}

char *pedal_send(const char *command)
{
    const char *path = pedal_socket_path();
    if(!command || !*command || strlen(command) > 4095 || strlen(path) >= sizeof(((struct sockaddr_un *)0)->sun_path)) {
        errno = EINVAL;
        return NULL;
    }
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if(fd < 0) return NULL;
    struct timeval timeout = {.tv_sec = strncmp(command, "lv2-", 4) == 0 ? 15 : 2};
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
    struct sockaddr_un address = {.sun_family = AF_UNIX};
    strcpy(address.sun_path, path);
    if(connect(fd, (struct sockaddr *)&address, sizeof(address)) < 0) { close(fd); return NULL; }
    size_t remaining = strlen(command);
    const char *cursor = command;
    while(remaining) {
        ssize_t count = send(fd, cursor, remaining, MSG_NOSIGNAL);
        if(count <= 0) { close(fd); return NULL; }
        cursor += count;
        remaining -= (size_t)count;
    }
    size_t capacity = 8192, used = 0;
    char *reply = malloc(capacity);
    if(!reply) { close(fd); return NULL; }
    while(used < 1048576) {
        if(used + 4096 + 1 > capacity) {
            size_t next = capacity * 2;
            char *grown = realloc(reply, next);
            if(!grown) { free(reply); close(fd); return NULL; }
            reply = grown; capacity = next;
        }
        ssize_t count = recv(fd, reply + used, capacity - used - 1, 0);
        if(count < 0) { free(reply); close(fd); return NULL; }
        if(count == 0) break;
        used += (size_t)count;
        if(memchr(reply, '\n', used)) break;
    }
    close(fd);
    if(!used) { free(reply); errno = EPROTO; return NULL; }
    reply[used] = '\0';
    return reply;
}
