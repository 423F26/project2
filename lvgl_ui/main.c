#include <lvgl/lvgl.h>

#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/un.h>
#include <unistd.h>

#define WIDTH 800
#define HEIGHT 480
#define CONTROL_SOCKET "/run/guitar-effect.sock"

#define C_BG 0x0A1016
#define C_CARD 0x14202A
#define C_TILE 0x20313A
#define C_TEXT 0xF2F6F4
#define C_MUTED 0x8CA3A9
#define C_LINE 0x30444C
#define C_ACCENT 0x43E0A0
#define C_GOLD 0xF0B968

enum { OVERDRIVE, FUZZ, DELAY, TREMOLO, CHORUS, PEDAL_COUNT };
static const char * pedal_names[PEDAL_COUNT] = {"overdrive", "fuzz", "delay", "tremolo", "chorus"};
static const char * pedal_titles[PEDAL_COUNT] = {"OVERDRIVE", "FUZZ", "DELAY", "TREMOLO", "CHORUS"};
static const char * pedal_details[PEDAL_COUNT] = {"WARM DRIVE", "HARD CLIP", "ECHO", "PULSE", "MODULATE"};
static const uint32_t pedal_colors[PEDAL_COUNT] = {C_ACCENT, C_GOLD, 0x85B6FA, 0xD8A7F2, 0xF59E9E};
static const uint32_t pedal_bodies[PEDAL_COUNT] = {0x1D3940, 0x3B3428, 0x26374B, 0x382E4A, 0x3D3038};
static bool live_mode;
static bool enabled = true;
static int amount = 65;
static int slots[PEDAL_COUNT] = {OVERDRIVE};
static int active_count = 1;
static bool view_only;
static int dragging = -1;
static int drag_offset_x;
static int drag_offset_y;
static bool drag_moved;

static lv_obj_t * tiles[PEDAL_COUNT];
static lv_obj_t * tile_details[PEDAL_COUNT];
static lv_obj_t * tile_leds[PEDAL_COUNT];
static lv_obj_t * gear_buttons[PEDAL_COUNT];
static lv_obj_t * path_label;
static lv_obj_t * status_label;
static lv_obj_t * mode_button;
static lv_obj_t * mode_button_label;
static lv_obj_t * slider;
static lv_obj_t * amount_label;
static lv_obj_t * config_overlay;
static lv_obj_t * library_overlay;
static lv_obj_t * config_values[8];
static lv_obj_t * config_sliders[8];
static lv_obj_t * config_status;
static int config_pedal = -1;
enum { DRIVE, TONE, MIX, LEVEL };
enum { TIME = 4, FEEDBACK, RATE, DEPTH, PARAMETER_COUNT };
static const char * parameter_names[PARAMETER_COUNT] = {"drive", "tone", "mix", "level", "time", "feedback", "rate", "depth"};
static const int pedal_parameters[PEDAL_COUNT][4] = {
    {DRIVE, TONE, MIX, LEVEL}, {DRIVE, TONE, LEVEL, -1},
    {TIME, FEEDBACK, MIX, -1}, {RATE, DEPTH, -1, -1}, {RATE, DEPTH, MIX, -1}
};
static float settings[PEDAL_COUNT][PARAMETER_COUNT] = {
    {20.0f, 3000.0f, 1.0f, 0.5f}, {15.0f, 2500.0f, 0.0f, 0.45f},
    {[TIME] = 300.0f, [FEEDBACK] = 0.35f, [MIX] = 0.35f},
    {[RATE] = 5.0f, [DEPTH] = 0.7f},
    {[RATE] = 1.2f, [DEPTH] = 0.5f, [MIX] = 0.5f}
};

static void refresh_state(lv_timer_t * timer);

static lv_color_t color(uint32_t hex)
{
    return lv_color_hex(hex);
}

static lv_obj_t * box(lv_obj_t * parent, int x, int y, int w, int h, uint32_t bg, int radius)
{
    lv_obj_t * obj = lv_obj_create(parent);
    lv_obj_remove_style_all(obj);
    lv_obj_set_pos(obj, x, y);
    lv_obj_set_size(obj, w, h);
    lv_obj_set_style_bg_color(obj, color(bg), 0);
    lv_obj_set_style_bg_opa(obj, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(obj, radius, 0);
    lv_obj_set_scrollable(obj, false);
    return obj;
}

static lv_obj_t * label(lv_obj_t * parent, const char * text, int x, int y,
                        const lv_font_t * font, uint32_t fg)
{
    lv_obj_t * obj = lv_label_create(parent);
    lv_label_set_text(obj, text);
    lv_obj_set_pos(obj, x, y);
    lv_obj_set_style_text_color(obj, color(fg), 0);
    lv_obj_set_style_text_font(obj, font, 0);
    return obj;
}

static void show_status(const char * message, uint32_t fg)
{
    lv_label_set_text(status_label, message);
    lv_obj_set_style_text_color(status_label, color(fg), 0);
}

static bool command(const char * request, char * reply, size_t reply_size)
{
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if(fd < 0) return false;
    struct timeval timeout = {.tv_sec = 0, .tv_usec = 100000};
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));

    struct sockaddr_un address = {.sun_family = AF_UNIX};
    snprintf(address.sun_path, sizeof(address.sun_path), "%s", CONTROL_SOCKET);
    bool ok = connect(fd, (struct sockaddr *)&address, sizeof(address)) == 0;
    if(ok) ok = send(fd, request, strlen(request), 0) == (ssize_t)strlen(request);
    size_t used = 0;
    while(ok && used < reply_size - 1) {
        ssize_t count = recv(fd, reply + used, reply_size - 1 - used, 0);
        if(count <= 0) break;
        used += (size_t)count;
        if(memchr(reply, '\n', used)) break;
    }
    close(fd);
    if(!ok || used == 0) return false;
    reply[used] = '\0';
    return strncmp(reply, "error:", 6) != 0;
}

static bool read_state(void)
{
    char reply[8192];
    if(!command("state", reply, sizeof(reply))) return false;
    const char * enabled_value = strstr(reply, "\"enabled\":");
    const char * amount_value = strstr(reply, "\"amount\":");
    const char * pedal_value = strstr(reply, "\"pedals\":");
    if(!enabled_value || !amount_value || !pedal_value) return false;

    enabled_value = strchr(enabled_value, ':') + 1;
    while(*enabled_value == ' ') enabled_value++;
    if(strncmp(enabled_value, "true", 4) != 0 && strncmp(enabled_value, "false", 5) != 0) return false;
    enabled = strncmp(enabled_value, "true", 4) == 0;
    amount = (int)lround(strtod(strchr(amount_value, ':') + 1, NULL) * 100.0);
    if(amount < 0) amount = 0;
    if(amount > 100) amount = 100;

    const char * start = strchr(pedal_value, '[');
    const char * end = start ? strchr(start, ']') : NULL;
    if(!end) return false;
    active_count = 0;
    view_only = false;
    for(const char * cursor = start + 1; cursor < end;) {
        const char * open = memchr(cursor, '"', (size_t)(end - cursor));
        if(!open) break;
        const char * close = memchr(open + 1, '"', (size_t)(end - open - 1));
        if(!close) return false;
        int found = -1;
        for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal) {
            size_t length = strlen(pedal_names[pedal]);
            if((size_t)(close - open - 1) == length && strncmp(open + 1, pedal_names[pedal], length) == 0)
                found = pedal;
        }
        if(found < 0 || active_count == PEDAL_COUNT) view_only = true;
        else slots[active_count++] = found;
        cursor = close + 1;
    }

    const char * config = strstr(reply, "\"settings\":");
    if(config) {
        for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal) {
            const char * section = strstr(config, pedal_names[pedal]);
            const char * open = section ? strchr(section, '{') : NULL;
            const char * close = open ? strchr(open, '}') : NULL;
            if(!close) continue;
            for(int index = 0; index < 4 && pedal_parameters[pedal][index] >= 0; ++index) {
                int parameter = pedal_parameters[pedal][index];
                char key[20];
                snprintf(key, sizeof(key), "\"%s\"", parameter_names[parameter]);
                const char * field = strstr(open, key);
                if(field && field < close)
                    settings[pedal][parameter] = (float)strtod(strchr(field, ':') + 1, NULL);
            }
        }
    }
    return true;
}

static int board_index(int pedal)
{
    for(int i = 0; i < active_count; ++i)
        if(slots[i] == pedal) return i;
    return -1;
}

static void render_board(void)
{
    char path[160] = "INPUT";
    for(int i = 0; i < active_count; ++i) {
        strcat(path, "  >  ");
        strcat(path, pedal_titles[slots[i]]);
    }
    strcat(path, "  >  OUTPUT");
    lv_label_set_text(path_label, path);

    int width = active_count <= 4 ? 164 : 130;
    int gap = active_count <= 4 ? 12 : 10;
    int total = active_count * width + (active_count ? active_count - 1 : 0) * gap;
    int left = 400 - total / 2;
    for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal) {
        int index = board_index(pedal);
        if(index < 0) {
            lv_obj_set_hidden(tiles[pedal], true);
            continue;
        }
        lv_obj_set_hidden(tiles[pedal], false);
        lv_obj_set_pos(tiles[pedal], left + index * (width + gap), 169);
        lv_obj_set_size(tiles[pedal], width, 100);
        lv_obj_set_style_bg_color(tiles[pedal], color(pedal_bodies[pedal]), 0);
        lv_label_set_text(tile_details[pedal], pedal_details[pedal]);
        lv_obj_set_pos(gear_buttons[pedal], width - 42, 6);
        lv_obj_set_size(gear_buttons[pedal], 36, 36);
        lv_obj_set_pos(tile_leds[pedal], width - 25, 72);
    }

    lv_obj_set_style_bg_color(mode_button, color(enabled ? C_ACCENT : C_TILE), 0);
    lv_label_set_text(mode_button_label, enabled ? "SIGNAL ON" : "BYPASSED");
    lv_obj_set_style_text_color(mode_button_label, color(enabled ? C_BG : C_TEXT), 0);
    lv_label_set_text_fmt(amount_label, "MIX  %d%%", amount);
    lv_slider_set_value(slider, amount, LV_ANIM_OFF);
}

static void send_board(void)
{
    if(!live_mode) return;
    if(view_only) {
        show_status("USE BROWSER FOR LV2 CHAIN", C_GOLD);
        return;
    }
    char request[160] = "board ";
    if(active_count == 0) strcat(request, "-");
    for(int i = 0; i < active_count; ++i) {
        if(i) strcat(request, ",");
        strcat(request, pedal_names[slots[i]]);
    }
    char reply[1024];
    if(!command(request, reply, sizeof(reply)) || !read_state())
        show_status("PEDAL DISCONNECTED", C_GOLD);
    else
        show_status("CONNECTED TO PEDAL", C_ACCENT);
    render_board();
}

static void tile_event(lv_event_t * event)
{
    int pedal = (int)(intptr_t)lv_event_get_user_data(event);
    lv_event_code_t code = lv_event_get_code(event);
    lv_point_t point;
    lv_indev_get_point(lv_indev_active(), &point);
    if(code == LV_EVENT_PRESSED) {
        dragging = pedal;
        drag_moved = false;
        drag_offset_x = point.x - lv_obj_get_x(tiles[pedal]);
        drag_offset_y = point.y - lv_obj_get_y(tiles[pedal]);
        lv_obj_move_foreground(tiles[pedal]);
    }
    else if(code == LV_EVENT_PRESSING && dragging == pedal) {
        int x = point.x - drag_offset_x;
        int y = point.y - drag_offset_y;
        if(abs(x - lv_obj_get_x(tiles[pedal])) > 2 || abs(y - lv_obj_get_y(tiles[pedal])) > 2)
            drag_moved = true;
        lv_obj_set_pos(tiles[pedal], x, y);
    }
    else if(code == LV_EVENT_RELEASED && dragging == pedal) {
        dragging = -1;
        int source = board_index(pedal);
        if(drag_moved && !view_only && source >= 0 && point.y >= 150 && point.y < 310 && point.x >= 30 && point.x < 770) {
            int target = active_count * (point.x - 30) / 740;
            if(target >= active_count) target = active_count - 1;
            if(target != source) {
                for(int i = source; i < active_count - 1; ++i) slots[i] = slots[i + 1];
                active_count--;
                if(target > active_count) target = active_count;
                for(int i = active_count; i > target; --i) slots[i] = slots[i - 1];
                slots[target] = pedal;
                active_count++;
                render_board();
                send_board();
            }
            else render_board();
        }
        else if(drag_moved && !view_only && source >= 0 && point.y >= 330) {
            for(int i = source; i < active_count - 1; ++i) slots[i] = slots[i + 1];
            active_count--;
            render_board();
            send_board();
        }
        else render_board();
    }
}

static void library_close(lv_event_t * event)
{
    (void)event;
    lv_obj_delete_async(library_overlay);
    library_overlay = NULL;
}

static void library_select(lv_event_t * event)
{
    int pedal = (int)(intptr_t)lv_event_get_user_data(event);
    if(view_only || board_index(pedal) >= 0 || active_count >= PEDAL_COUNT) return;
    slots[active_count++] = pedal;
    library_close(NULL);
    render_board();
    send_board();
}

static void library_open(lv_event_t * event)
{
    (void)event;
    if(library_overlay) return;
    library_overlay = box(lv_screen_active(), 0, 0, WIDTH, HEIGHT, C_BG, 0);
    lv_obj_set_style_bg_opa(library_overlay, LV_OPA_80, 0);
    lv_obj_t * panel = box(library_overlay, 95, 48, 610, 384, C_CARD, 18);
    label(panel, "PEDAL LIBRARY", 28, 20, &lv_font_montserrat_20, C_ACCENT);
    label(panel, "Select a pedal to append to the board", 28, 54, &lv_font_montserrat_14, C_MUTED);
    lv_obj_t * close = box(panel, 540, 15, 44, 44, C_TILE, 10);
    lv_obj_set_clickable(close, true);
    lv_obj_add_event_cb(close, library_close, LV_EVENT_CLICKED, NULL);
    lv_obj_t * icon = label(close, LV_SYMBOL_CLOSE, 0, 0, &lv_font_montserrat_20, C_TEXT);
    lv_obj_center(icon);
    for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal) {
        int col = pedal % 2;
        int row = pedal / 2;
        lv_obj_t * button = box(panel, 28 + col * 275, 93 + row * 80, 258, 64,
                                board_index(pedal) >= 0 ? C_TILE : pedal_bodies[pedal], 10);
        lv_obj_set_style_border_color(button, color(pedal_colors[pedal]), 0);
        lv_obj_set_style_border_width(button, 1, 0);
        box(button, 0, 0, 5, 64, pedal_colors[pedal], 2);
        lv_obj_set_clickable(button, true);
        lv_obj_add_event_cb(button, library_select, LV_EVENT_CLICKED, (void *)(intptr_t)pedal);
        label(button, pedal_titles[pedal], 12, 10, &lv_font_montserrat_16, pedal_colors[pedal]);
        label(button, board_index(pedal) >= 0 ? "ON BOARD" : pedal_details[pedal],
              12, 37, &lv_font_montserrat_14, C_MUTED);
    }
}

static void mode_clicked(lv_event_t * event)
{
    (void)event;
    enabled = !enabled;
    render_board();
    if(!live_mode) return;
    char reply[512];
    if(!command(enabled ? "effect" : "clean", reply, sizeof(reply)) || !read_state())
        show_status("PEDAL DISCONNECTED", C_GOLD);
    else
        show_status("CONNECTED TO PEDAL", C_ACCENT);
    render_board();
}

static void slider_changed(lv_event_t * event)
{
    (void)event;
    amount = lv_slider_get_value(slider);
    lv_label_set_text_fmt(amount_label, "MIX  %d%%", amount);
}

static void slider_released(lv_event_t * event)
{
    (void)event;
    if(!live_mode) return;
    char request[32];
    char reply[512];
    snprintf(request, sizeof(request), "amount %.2f", amount / 100.0);
    if(!command(request, reply, sizeof(reply)))
        show_status("PEDAL DISCONNECTED", C_GOLD);
    else
        show_status("CONNECTED TO PEDAL", C_ACCENT);
}

static int config_slider_value(int pedal, int parameter)
{
    float value = settings[pedal][parameter];
    int scale = parameter == RATE ? 10 :
                parameter == MIX || parameter == LEVEL || parameter == FEEDBACK || parameter == DEPTH ? 100 : 1;
    return (int)lroundf(value * scale);
}

static void format_config_value(int parameter, int value, char * text, size_t size)
{
    if(parameter == TONE) snprintf(text, size, "%d Hz", value);
    else if(parameter == TIME) snprintf(text, size, "%d ms", value);
    else if(parameter == RATE) snprintf(text, size, "%.1f Hz", value / 10.0f);
    else if(parameter == DRIVE) snprintf(text, size, "%dx", value);
    else snprintf(text, size, "%d%%", value);
}

static void config_changed(lv_event_t * event)
{
    int parameter = (int)(intptr_t)lv_event_get_user_data(event);
    if(config_pedal < 0) return;
    int value = lv_slider_get_value(config_sliders[parameter]);
    settings[config_pedal][parameter] = parameter == RATE ? value / 10.0f :
        parameter == MIX || parameter == LEVEL || parameter == FEEDBACK || parameter == DEPTH ? value / 100.0f : (float)value;
    char text[24];
    format_config_value(parameter, value, text, sizeof(text));
    lv_label_set_text(config_values[parameter], text);
}

static void config_released(lv_event_t * event)
{
    int parameter = (int)(intptr_t)lv_event_get_user_data(event);
    if(!live_mode || config_pedal < 0) return;
    char request[80];
    char reply[1024];
    snprintf(request, sizeof(request), "config %s %s %.3f", pedal_names[config_pedal],
             parameter_names[parameter], settings[config_pedal][parameter]);
    if(!command(request, reply, sizeof(reply)))
        lv_label_set_text(config_status, "COULD NOT APPLY SETTING");
    else
        lv_label_set_text(config_status, "APPLIED TO PEDAL");
}

static void config_close(lv_event_t * event)
{
    (void)event;
    lv_obj_delete_async(config_overlay);
    config_overlay = NULL;
    config_pedal = -1;
    if(live_mode) refresh_state(NULL);
}

static void config_open(lv_event_t * event)
{
    int pedal = (int)(intptr_t)lv_event_get_user_data(event);
    if(config_overlay) return;
    config_pedal = pedal;
    for(int i = 0; i < PARAMETER_COUNT; ++i) {
        config_values[i] = NULL;
        config_sliders[i] = NULL;
    }
    lv_obj_t * screen = lv_screen_active();
    config_overlay = box(screen, 0, 0, WIDTH, HEIGHT, C_BG, 0);
    lv_obj_set_style_bg_opa(config_overlay, LV_OPA_80, 0);
    lv_obj_t * panel = box(config_overlay, 94, 45, 612, 390, C_CARD, 20);
    char heading[48];
    snprintf(heading, sizeof(heading), "%s  /  SETTINGS", pedal_titles[pedal]);
    label(panel, heading, 28, 22, &lv_font_montserrat_20, pedal_colors[pedal]);
    label(panel, "Adjust this pedal independently", 28, 53, &lv_font_montserrat_14, C_MUTED);
    lv_obj_t * close = box(panel, 541, 16, 44, 44, C_TILE, 10);
    lv_obj_set_clickable(close, true);
    lv_obj_add_event_cb(close, config_close, LV_EVENT_CLICKED, NULL);
    lv_obj_t * close_icon = label(close, LV_SYMBOL_CLOSE, 0, 0, &lv_font_montserrat_20, C_TEXT);
    lv_obj_center(close_icon);

    const char * titles[PARAMETER_COUNT] = {"DRIVE", "TONE", "MIX", "LEVEL", "TIME", "FEEDBACK", "RATE", "DEPTH"};
    int rows = 0;
    while(rows < 4 && pedal_parameters[pedal][rows] >= 0) rows++;
    for(int row = 0; row < rows; ++row) {
        int parameter = pedal_parameters[pedal][row];
        int y = 94 + row * 69;
        label(panel, titles[parameter], 30, y, &lv_font_montserrat_14, C_TEXT);
        lv_obj_t * control = lv_slider_create(panel);
        config_sliders[parameter] = control;
        lv_obj_set_pos(control, 152, y + 10);
        lv_obj_set_size(control, 320, 8);
        int minimum = parameter == DRIVE ? 1 : parameter == TONE ? 100 : parameter == TIME ? 20 : parameter == RATE ? 1 : 0;
        int maximum = parameter == DRIVE ? 100 : parameter == TONE ? 8000 : parameter == TIME ? 1500 :
                      parameter == RATE ? (pedal == CHORUS ? 50 : 200) : parameter == FEEDBACK ? 90 : 100;
        lv_slider_set_range(control, minimum, maximum);
        lv_obj_set_style_bg_color(control, color(C_LINE), LV_PART_MAIN);
        lv_obj_set_style_bg_color(control, color(pedal_colors[pedal]), LV_PART_INDICATOR);
        lv_obj_set_style_bg_color(control, color(pedal_colors[pedal]), LV_PART_KNOB);
        lv_obj_set_style_pad_all(control, 8, LV_PART_KNOB);
        lv_slider_set_value(control, config_slider_value(pedal, parameter), LV_ANIM_OFF);
        lv_obj_add_event_cb(control, config_changed, LV_EVENT_VALUE_CHANGED, (void *)(intptr_t)parameter);
        lv_obj_add_event_cb(control, config_released, LV_EVENT_RELEASED, (void *)(intptr_t)parameter);
        char value[24];
        format_config_value(parameter, config_slider_value(pedal, parameter), value, sizeof(value));
        config_values[parameter] = label(panel, value, 498, y - 3, &lv_font_montserrat_14, C_MUTED);
    }
    config_status = label(panel, live_mode ? "CONNECTED SETTINGS" : "DEMO MODE  /  NO AUDIO",
                          30, 353, &lv_font_montserrat_14, C_MUTED);
}

static void refresh_state(lv_timer_t * timer)
{
    (void)timer;
    if(!live_mode || dragging >= 0 || config_overlay || library_overlay) return;
    if(read_state()) {
        render_board();
        show_status(view_only ? "USE BROWSER FOR LV2 CHAIN" : "CONNECTED TO PEDAL",
                    view_only ? C_GOLD : C_ACCENT);
    }
    else show_status("PEDAL DISCONNECTED", C_GOLD);
}

static void build_ui(void)
{
    lv_obj_t * screen = lv_screen_active();
    lv_obj_set_style_bg_color(screen, color(C_BG), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
    lv_obj_set_scrollable(screen, false);

    box(screen, 24, 20, 42, 42, C_ACCENT, 12);
    label(screen, "P", 37, 23, &lv_font_montserrat_28, C_BG);
    label(screen, "PEDAL / LAB", 80, 25, &lv_font_montserrat_20, C_TEXT);
    label(screen, "SIGNAL GRAPH", 632, 31, &lv_font_montserrat_14, C_MUTED);
    box(screen, 24, 75, 752, 1, C_LINE, 0);

    box(screen, 24, 90, 752, 229, C_CARD, 20);
    label(screen, "01  /  PEDAL BOARD", 47, 108, &lv_font_montserrat_14, C_ACCENT);
    path_label = label(screen, "INPUT  >  OVERDRIVE  >  OUTPUT", 47, 133, &lv_font_montserrat_14, C_MUTED);
    box(screen, 98, 216, 602, 3, C_LINE, 2);
    box(screen, 46, 185, 76, 65, C_TILE, 13);
    label(screen, "IN", 69, 203, &lv_font_montserrat_20, C_ACCENT);
    box(screen, 681, 185, 70, 65, C_TILE, 13);
    label(screen, "OUT", 689, 203, &lv_font_montserrat_20, C_ACCENT);
    label(screen, "DRAG TO REORDER  /  DRAG DOWN TO REMOVE", 47, 283, &lv_font_montserrat_14, C_MUTED);

    box(screen, 24, 332, 521, 124, C_CARD, 18);
    label(screen, "02  /  PEDAL LIBRARY", 47, 344, &lv_font_montserrat_14, C_MUTED);
    lv_obj_t * library_button = box(screen, 47, 373, 473, 61, C_TILE, 12);
    lv_obj_set_clickable(library_button, true);
    lv_obj_add_event_cb(library_button, library_open, LV_EVENT_CLICKED, NULL);
    label(library_button, "OPEN LIBRARY  +", 18, 15, &lv_font_montserrat_20, C_ACCENT);
    box(screen, 560, 332, 216, 124, C_CARD, 18);
    mode_button = box(screen, 575, 344, 186, 47, C_ACCENT, 11);
    lv_obj_set_clickable(mode_button, true);
    lv_obj_add_event_cb(mode_button, mode_clicked, LV_EVENT_CLICKED, NULL);
    mode_button_label = label(mode_button, "SIGNAL ON", 0, 0, &lv_font_montserrat_20, C_BG);
    lv_obj_center(mode_button_label);
    amount_label = label(screen, "MIX  65%", 577, 401, &lv_font_montserrat_14, C_MUTED);
    slider = lv_slider_create(screen);
    lv_obj_set_pos(slider, 578, 432);
    lv_obj_set_size(slider, 180, 6);
    lv_slider_set_range(slider, 0, 100);
    lv_obj_set_style_bg_color(slider, color(C_LINE), LV_PART_MAIN);
    lv_obj_set_style_bg_color(slider, color(C_GOLD), LV_PART_INDICATOR);
    lv_obj_set_style_bg_color(slider, color(C_GOLD), LV_PART_KNOB);
    lv_obj_set_style_pad_all(slider, 8, LV_PART_KNOB);
    lv_obj_add_event_cb(slider, slider_changed, LV_EVENT_VALUE_CHANGED, NULL);
    lv_obj_add_event_cb(slider, slider_released, LV_EVENT_RELEASED, NULL);

    for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal) {
        tiles[pedal] = box(screen, 0, 169, 164, 100, pedal_bodies[pedal], 12);
        lv_obj_set_style_border_color(tiles[pedal], color(pedal_colors[pedal]), 0);
        lv_obj_set_style_border_width(tiles[pedal], 2, 0);
        lv_obj_set_style_shadow_color(tiles[pedal], color(pedal_colors[pedal]), 0);
        lv_obj_set_style_shadow_width(tiles[pedal], 10, 0);
        lv_obj_set_style_shadow_opa(tiles[pedal], LV_OPA_20, 0);
        lv_obj_set_clickable(tiles[pedal], true);
        lv_obj_add_event_cb(tiles[pedal], tile_event, LV_EVENT_PRESSED, (void *)(intptr_t)pedal);
        lv_obj_add_event_cb(tiles[pedal], tile_event, LV_EVENT_PRESSING, (void *)(intptr_t)pedal);
        lv_obj_add_event_cb(tiles[pedal], tile_event, LV_EVENT_RELEASED, (void *)(intptr_t)pedal);
        box(tiles[pedal], 0, 0, 6, 100, pedal_colors[pedal], 3);
        label(tiles[pedal], pedal_titles[pedal], 8, 13, &lv_font_montserrat_14, C_TEXT);
        tile_details[pedal] = label(tiles[pedal], pedal_details[pedal], 8, 48, &lv_font_montserrat_14, C_MUTED);
        tile_leds[pedal] = box(tiles[pedal], 139, 72, 12, 12, pedal_colors[pedal], 6);
        lv_obj_set_style_shadow_color(tile_leds[pedal], color(pedal_colors[pedal]), 0);
        lv_obj_set_style_shadow_width(tile_leds[pedal], 12, 0);
        lv_obj_set_style_shadow_opa(tile_leds[pedal], LV_OPA_70, 0);
        gear_buttons[pedal] = box(tiles[pedal], 122, 6, 36, 36, C_LINE, 9);
        lv_obj_set_clickable(gear_buttons[pedal], true);
        lv_obj_add_event_cb(gear_buttons[pedal], config_open, LV_EVENT_CLICKED, (void *)(intptr_t)pedal);
        lv_obj_t * icon = label(gear_buttons[pedal], LV_SYMBOL_SETTINGS, 0, 0, &lv_font_montserrat_20, C_TEXT);
        lv_obj_center(icon);
    }

    box(screen, 24, 467, 8, 8, live_mode ? C_ACCENT : C_GOLD, 4);
    status_label = label(screen, live_mode ? "CONNECTING TO PEDAL" : "DEMO MODE  /  NO AUDIO",
                         42, 462, &lv_font_montserrat_14, live_mode ? C_ACCENT : C_GOLD);
    render_board();
}

int main(int argc, char ** argv)
{
    if(argc > 2 || (argc == 2 && strcmp(argv[1], "--live") != 0)) {
        fprintf(stderr, "Usage: %s [--live]\n", argv[0]);
        return 2;
    }
    live_mode = argc == 2;
    lv_init();
    lv_display_t * display = lv_sdl_window_create(WIDTH, HEIGHT);
    if(!display) {
        fprintf(stderr, "Could not open an SDL window. Is a graphical desktop running?\n");
        return 1;
    }
    lv_sdl_window_set_title(display, "Pedal / Lab — LVGL pedal board");
    lv_sdl_mouse_create();
    lv_sdl_keyboard_create();
    build_ui();
    if(live_mode) {
        refresh_state(NULL);
        lv_timer_create(refresh_state, 1000, NULL);
    }
    while(true) {
        uint32_t delay = lv_timer_handler();
        lv_sleep_ms(delay > 20 ? 20 : delay);
    }
}
