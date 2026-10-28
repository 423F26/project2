#define _POSIX_C_SOURCE 200809L
#include "socket_client.h"
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static volatile sig_atomic_t running = 1;
static pid_t child = -1;
static void stop(int unused) { (void)unused; running = 0; if(child > 0) kill(child, SIGTERM); }
int main(int argc, char **argv) {
    const char *chip = "gpiochip0", *line = "17";
    for(int i = 1; i < argc; ++i) {
        if(strcmp(argv[i], "--chip") == 0 && ++i < argc) chip = argv[i];
        else if(strcmp(argv[i], "--line") == 0 && ++i < argc) line = argv[i];
        else { fprintf(stderr, "Usage: pedal-footswitch [--chip gpiochip0] [--line 17]\n"); return 2; }
    }
    int pipefd[2]; if(pipe(pipefd)) { perror("pipe"); return 1; }
    child = fork();
    if(child < 0) { perror("fork"); return 1; }
    if(child == 0) {
        close(pipefd[0]); dup2(pipefd[1], STDOUT_FILENO); close(pipefd[1]);
        execlp("stdbuf", "stdbuf", "-oL", "gpiomon", "--chip", chip, "--bias", "pull-up", "--edges", "falling", "--debounce-period", "50ms", line, (char *)NULL);
        perror("gpiomon"); _exit(127);
    }
    close(pipefd[1]); signal(SIGINT, stop); signal(SIGTERM, stop);
    FILE *events = fdopen(pipefd[0], "r");
    if(!events) { stop(0); waitpid(child, NULL, 0); return 1; }
    char event[1024];
    while(running && fgets(event, sizeof(event), events)) {
        if(!strchr(event, '\n')) { int ch; while((ch = fgetc(events)) != '\n' && ch != EOF) {} }
        char *reply = pedal_send("toggle");
        if(!reply) fprintf(stderr, "Pedal engine unavailable: %s\n", strerror(errno));
        else { fputs(reply, stdout); free(reply); }
    }
    fclose(events);
    int status = 0; waitpid(child, &status, 0);
    return running && (!WIFEXITED(status) || WEXITSTATUS(status) != 0) ? 1 : 0;
}
