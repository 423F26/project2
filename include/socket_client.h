#ifndef PEDAL_SOCKET_CLIENT_H
#define PEDAL_SOCKET_CLIENT_H

/* Returns a malloc-owned newline-terminated reply, or NULL on error. */
char *pedal_send(const char *command);
const char *pedal_socket_path(void);

#endif
