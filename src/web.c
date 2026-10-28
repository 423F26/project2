#define _POSIX_C_SOURCE 200809L
#include "socket_client.h"
#include <arpa/inet.h>
#include <errno.h>
#include <json-c/json.h>
#include <math.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <unistd.h>

static volatile sig_atomic_t running = 1;
static void stop(int unused) { (void)unused; running = 0; }
static void response(int fd, int code, const char *type, const char *body) {
    char header[512];
    size_t len = strlen(body);
    int n = snprintf(header, sizeof(header), "HTTP/1.1 %d %s\r\nContent-Type: %s\r\nContent-Length: %zu\r\nCache-Control: no-store\r\nConnection: close\r\n\r\n", code, code == 200 ? "OK" : "Error", type, len);
    send(fd, header, (size_t)n, MSG_NOSIGNAL);
    while(len) { ssize_t sent = send(fd, body, len, MSG_NOSIGNAL); if(sent <= 0) break; body += sent; len -= (size_t)sent; }
}
static bool token(const char *s) {
    if(!s || !*s || strlen(s) > 127) return false;
    for(; *s; ++s) if(!((*s >= 'a' && *s <= 'z') || (*s >= 'A' && *s <= 'Z') || (*s >= '0' && *s <= '9') || *s == '_' || *s == '-' || *s == '.' || *s == ':')) return false;
    return true;
}
static const char *field_string(json_object *o, const char *key) {
    json_object *value;
    return json_object_object_get_ex(o, key, &value) && json_object_is_type(value, json_type_string) ? json_object_get_string(value) : NULL;
}
static bool field_number(json_object *o, const char *key, double *value) {
    json_object *item;
    if(!json_object_object_get_ex(o, key, &item) || !(json_object_is_type(item, json_type_double) || json_object_is_type(item, json_type_int))) return false;
    *value = json_object_get_double(item);
    return isfinite(*value);
}
static char *command_for(const char *path, json_object *o) {
    char buffer[4096];
    if(strcmp(path, "/api/board") == 0) {
        json_object *array;
        if(!json_object_object_get_ex(o, "pedals", &array) || !json_object_is_type(array, json_type_array)) return NULL;
        size_t used = 6;
        strcpy(buffer, "board ");
        int count = json_object_array_length(array);
        if(count > 32) return NULL;
        if(count == 0) strcpy(buffer + used, "-");
        for(int i = 0; i < count; ++i) {
            json_object *item = json_object_array_get_idx(array, i);
            const char *id = json_object_is_type(item, json_type_string) ? json_object_get_string(item) : NULL;
            if(!token(id) || used + strlen(id) + 2 >= sizeof(buffer)) return NULL;
            if(i) buffer[used++] = ',';
            used += (size_t)sprintf(buffer + used, "%s", id);
        }
    } else if(strcmp(path, "/api/import") == 0) {
        const char *uri = field_string(o, "uri");
        if(!uri || !*uri || strlen(uri) > 2048 || strpbrk(uri, "\r\n")) return NULL;
        snprintf(buffer, sizeof(buffer), "lv2-load %s", uri);
    } else if(strcmp(path, "/api/mode") == 0) {
        json_object *value;
        if(!json_object_object_get_ex(o, "enabled", &value) || !json_object_is_type(value, json_type_boolean)) return NULL;
        strcpy(buffer, json_object_get_boolean(value) ? "effect" : "clean");
    } else if(strcmp(path, "/api/amount") == 0) {
        double value;
        if(!field_number(o, "amount", &value) || value < 0 || value > 1) return NULL;
        snprintf(buffer, sizeof(buffer), "amount %.9g", value);
    } else if(strcmp(path, "/api/tuner") == 0) {
        json_object *value;
        if(!json_object_object_get_ex(o, "enabled", &value) || !json_object_is_type(value, json_type_boolean)) return NULL;
        strcpy(buffer, json_object_get_boolean(value) ? "tuner on" : "tuner off");
    } else if(strcmp(path, "/api/config") == 0) {
        const char *pedal = field_string(o, "pedal"), *setting = field_string(o, "setting");
        double value;
        if(!token(pedal) || !token(setting) || !field_number(o, "value", &value)) return NULL;
        snprintf(buffer, sizeof(buffer), "config %s %s %.9g", pedal, setting, value);
    } else return NULL;
    return strdup(buffer);
}
static char *read_html(const char *path) {
    FILE *f = fopen(path, "rb");
    if(!f) return NULL;
    if(fseek(f, 0, SEEK_END) || ftell(f) < 0) { fclose(f); return NULL; }
    long length = ftell(f);
    if(length > 1048576 || fseek(f, 0, SEEK_SET)) { fclose(f); return NULL; }
    char *data = malloc((size_t)length + 1);
    if(!data) { fclose(f); return NULL; }
    size_t read_count = fread(data, 1, (size_t)length, f);
    fclose(f); data[read_count] = 0;
    return data;
}
static void handle(int fd, const char *html) {
    char request[16384]; size_t used = 0, header_end = 0;
    while(used < sizeof(request) - 1) {
        ssize_t got = recv(fd, request + used, sizeof(request) - used - 1, 0);
        if(got <= 0) return;
        used += (size_t)got; request[used] = 0;
        char *end = strstr(request, "\r\n\r\n");
        if(end) { header_end = (size_t)(end - request) + 4; break; }
    }
    if(!header_end) { response(fd, 400, "application/json", "{\"error\":\"Headers too large\"}"); return; }
    char method[8], path[128];
    if(sscanf(request, "%7s %127s", method, path) != 2) { response(fd, 400, "application/json", "{\"error\":\"Bad request\"}"); return; }
    if(strcmp(method, "GET") == 0 && strcmp(path, "/") == 0) { response(fd, 200, "text/html; charset=utf-8", html); return; }
    if(strcmp(method, "GET") == 0 && (strcmp(path, "/api/state") == 0 || strcmp(path, "/api/lv2") == 0 || strcmp(path, "/api/midi") == 0)) {
        const char *command = strcmp(path, "/api/lv2") == 0 ? "lv2-list" :
                              strcmp(path, "/api/midi") == 0 ? "midi-events" : "state";
        char *reply = pedal_send(command);
        if(!reply) response(fd, 503, "application/json", "{\"error\":\"Pedal engine unavailable\"}");
        else if(strncmp(reply, "error:", 6) == 0) response(fd, 503, "application/json", "{\"error\":\"Pedal engine error\"}");
        else response(fd, 200, "application/json", reply);
        free(reply); return;
    }
    if(strcmp(method, "POST") != 0) { response(fd, 404, "application/json", "{\"error\":\"Unknown endpoint\"}"); return; }
    size_t content_length = 0;
    char *line = strstr(request, "\r\n");
    while(line && (size_t)(line - request) < header_end - 2) {
        line += 2;
        if(strncasecmp(line, "Content-Length:", 15) == 0) content_length = strtoul(line + 15, NULL, 10);
        line = strstr(line, "\r\n");
    }
    if(!content_length || content_length > 8192 || header_end + content_length >= sizeof(request)) { response(fd, 400, "application/json", "{\"error\":\"Invalid body size\"}"); return; }
    while(used - header_end < content_length) {
        ssize_t got = recv(fd, request + used, sizeof(request) - used - 1, 0);
        if(got <= 0) return;
        used += (size_t)got;
    }
    request[header_end + content_length] = 0;
    json_object *body = json_tokener_parse(request + header_end);
    char *command = body && json_object_is_type(body, json_type_object) ? command_for(path, body) : NULL;
    if(body) json_object_put(body);
    if(!command) { response(fd, 400, "application/json", "{\"error\":\"Invalid request\"}"); return; }
    char *reply = pedal_send(command); free(command);
    if(!reply) { response(fd, 503, "application/json", "{\"error\":\"Pedal engine unavailable\"}"); return; }
    if(strncmp(reply, "error:", 6) == 0) { response(fd, 400, "application/json", "{\"error\":\"Pedal rejected request\"}"); free(reply); return; }
    free(reply);
    reply = pedal_send("state");
    if(reply) response(fd, 200, "application/json", reply);
    else response(fd, 503, "application/json", "{\"error\":\"Pedal engine unavailable\"}");
    free(reply);
}
int main(int argc, char **argv) {
    int port = 8765; const char *html_path = "web/index.html";
    for(int i = 1; i < argc; ++i) {
        if(strcmp(argv[i], "--port") == 0 && ++i < argc) port = atoi(argv[i]);
        else if(strcmp(argv[i], "--html") == 0 && ++i < argc) html_path = argv[i];
        else { fprintf(stderr, "Usage: pedal-web [--port 8765] [--html web/index.html]\n"); return 2; }
    }
    if(port < 1 || port > 65535) return 2;
    char *html = read_html(html_path);
    if(!html && strcmp(html_path, "web/index.html") == 0) {
        char executable[4096], candidate[8192];
        ssize_t length = readlink("/proc/self/exe", executable, sizeof(executable) - 1);
        if(length > 0) {
            executable[length] = 0;
            char *slash = strrchr(executable, '/');
            if(slash) {
                *slash = 0;
                snprintf(candidate, sizeof(candidate), "%s/web/index.html", executable);
                html = read_html(candidate);
                if(!html) {
                    snprintf(candidate, sizeof(candidate), "%s/../share/c-pedal/web/index.html", executable);
                    html = read_html(candidate);
                }
            }
        }
    }
    if(!html) { perror(html_path); return 1; }
    int server = socket(AF_INET, SOCK_STREAM, 0);
    if(server < 0) { perror("socket"); free(html); return 1; }
    int reuse = 1; setsockopt(server, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
    struct sockaddr_in address = {.sin_family = AF_INET, .sin_port = htons((uint16_t)port)};
    address.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    if(bind(server, (struct sockaddr *)&address, sizeof(address)) || listen(server, 16)) { perror("bind/listen"); close(server); free(html); return 1; }
    signal(SIGINT, stop); signal(SIGTERM, stop);
    printf("Pedal UI: http://127.0.0.1:%d\n", port); fflush(stdout);
    while(running) {
        int fd = accept(server, NULL, NULL);
        if(fd < 0) { if(errno == EINTR) continue; break; }
        struct timeval timeout = {.tv_sec = 2}; setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
        handle(fd, html); close(fd);
    }
    close(server); free(html); return 0;
}
