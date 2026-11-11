#include <lvgl/lvgl.h>
#include <SDL.h>
#include <json-c/json.h>
#include "audio_settings.h"

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

enum { OVERDRIVE, FUZZ, DELAY, TREMOLO, CHORUS, LIMITER, OCTAVE, PEDAL_COUNT };
static const char * pedal_names[PEDAL_COUNT] = {"overdrive", "fuzz", "delay", "tremolo", "chorus", "limiter", "octave"};
static const char * pedal_titles[PEDAL_COUNT] = {"OVERDRIVE", "FUZZ", "DELAY", "TREMOLO", "CHORUS", "LIMITER", "OCTAVE"};
static const char * pedal_details[PEDAL_COUNT] = {"WARM DRIVE", "HARD CLIP", "ECHO", "PULSE", "MODULATE", "PEAK CONTROL", "PITCH SHIFT"};
static const uint32_t pedal_colors[PEDAL_COUNT] = {C_ACCENT, C_GOLD, 0x85B6FA, 0xD8A7F2, 0xF59E9E, 0xF5CB77, 0xB9B0FF};
static const uint32_t pedal_bodies[PEDAL_COUNT] = {0x1D3940, 0x3B3428, 0x26374B, 0x382E4A, 0x3D3038, 0x403725, 0x302D46};
static bool live_mode;
static bool ui_running = true;
static bool bypassed[PEDAL_COUNT];
static lv_obj_t *led_buttons[PEDAL_COUNT];
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
static lv_obj_t * tile_titles[PEDAL_COUNT];
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
static lv_obj_t * audio_overlay;
static lv_obj_t * tuner_overlay;
static lv_obj_t * tuner_note_label;
static lv_obj_t * tuner_frequency_label;
static lv_obj_t * tuner_cents_label;
static lv_obj_t * tuner_needle;
static lv_obj_t * tuner_toggle_label;
static bool tuner_enabled = true, tuner_has_note;
static char tuner_note[16];
static double tuner_frequency, tuner_cents;
static lv_obj_t * input_port;
static lv_obj_t * output_port;
static lv_obj_t * audio_sliders[2];
static lv_obj_t * audio_values[2];
static lv_obj_t * audio_status;
static lv_obj_t * audio_info;
static lv_obj_t * audio_inputs;
static lv_obj_t * audio_mute;
static lv_obj_t * audio_mute_label;
static bool output_muted;
static lv_obj_t * config_status;
static int config_pedal = -1;
enum { DRIVE, TONE, MIX, LEVEL };
enum { TIME = 4, FEEDBACK, RATE, DEPTH, PITCH, CEILING, RELEASE, PARAMETER_COUNT };
static lv_obj_t * config_values[PARAMETER_COUNT];
static lv_obj_t * config_sliders[PARAMETER_COUNT];
static const char * parameter_names[PARAMETER_COUNT] = {"drive", "tone", "mix", "level", "time", "feedback", "rate", "depth", "pitch", "ceiling", "release"};
static const int pedal_parameters[PEDAL_COUNT][4] = {
    {DRIVE, TONE, MIX, LEVEL}, {DRIVE, TONE, LEVEL, -1},
    {TIME, FEEDBACK, MIX, -1}, {RATE, DEPTH, -1, -1}, {RATE, DEPTH, MIX, -1},
    {CEILING, RELEASE, -1, -1}, {PITCH, MIX, -1, -1}
};
static float settings[PEDAL_COUNT][PARAMETER_COUNT] = {
    {20.0f, 3000.0f, 1.0f, 0.5f}, {15.0f, 2500.0f, 0.0f, 0.45f},
    {[TIME] = 300.0f, [FEEDBACK] = 0.35f, [MIX] = 0.35f},
    {[RATE] = 5.0f, [DEPTH] = 0.7f},
    {[RATE] = 1.2f, [DEPTH] = 0.5f, [MIX] = 0.5f},
    {[CEILING] = -1.0f, [RELEASE] = 80.0f},
    {[PITCH] = .5f, [MIX] = .65f}
};

static void refresh_state(lv_timer_t * timer);
static void audio_open(lv_event_t *event);
static void tuner_open(lv_event_t *event);

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

static lv_obj_t * button_label(lv_obj_t *button, const char *text,
                               const lv_font_t *font, uint32_t fg)
{
    lv_obj_t *text_label = label(button, text, 0, 0, font, fg);
    lv_obj_set_width(text_label, LV_PCT(100));
    lv_obj_set_style_text_align(text_label, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_center(text_label);
    return text_label;
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
    const char *path = getenv("PEDAL_CONTROL_SOCKET");
    snprintf(address.sun_path, sizeof(address.sun_path), "%s", path && *path ? path : CONTROL_SOCKET);
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
    char reply[32768];
    if(!command("state", reply, sizeof(reply))) return false;
    json_object *root = json_tokener_parse(reply);
    if(!root) return false;
    json_object *board = json_object_object_get(root, "pedals");
    if(!board || !json_object_is_type(board, json_type_array)) { json_object_put(root); return false; }
    enabled = json_object_get_boolean(json_object_object_get(root, "enabled"));
    amount = (int)lround(100 * json_object_get_double(json_object_object_get(root, "amount")));
    json_object *tuner = json_object_object_get(root, "tuner");
    json_object *note = tuner ? json_object_object_get(tuner, "note") : NULL;
    tuner_enabled = tuner && json_object_get_boolean(json_object_object_get(tuner, "enabled"));
    tuner_has_note = tuner_enabled && note && json_object_is_type(note, json_type_string);
    snprintf(tuner_note, sizeof(tuner_note), "%s", tuner_has_note ? json_object_get_string(note) : "--");
    tuner_frequency = json_object_get_double(json_object_object_get(tuner, "frequency"));
    tuner_cents = json_object_get_double(json_object_object_get(tuner, "cents"));
    active_count = 0;
    view_only = false;
    for(size_t i = 0; i < json_object_array_length(board); ++i) {
        const char *name = json_object_get_string(json_object_array_get_idx(board, i));
        int found = -1;
        for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal)
            if(name && strcmp(name, pedal_names[pedal]) == 0) found = pedal;
        if(found < 0 || active_count == PEDAL_COUNT) view_only = true;
        else slots[active_count++] = found;
    }
    json_object *all = json_object_object_get(root, "settings");
    json_object *available = json_object_object_get(root, "available");
    for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal) {
        json_object *info = available ? json_object_object_get(available, pedal_names[pedal]) : NULL;
        bypassed[pedal] = info && json_object_get_boolean(json_object_object_get(info, "bypassed"));
        json_object *values = all ? json_object_object_get(all, pedal_names[pedal]) : NULL;
        for(int index = 0; values && index < 4 && pedal_parameters[pedal][index] >= 0; ++index) {
            int parameter = pedal_parameters[pedal][index];
            json_object *value;
            if(json_object_object_get_ex(values, parameter_names[parameter], &value))
                settings[pedal][parameter] = (float)json_object_get_double(value);
        }
    }
    json_object_put(root);
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
    lv_obj_set_style_text_font(path_label, active_count >= 6 ? &lv_font_montserrat_12 : &lv_font_montserrat_14, 0);

    int width = active_count <= 4 ? 164 : active_count == 5 ? 130 : active_count == 6 ? 112 : 96;
    int gap = active_count <= 4 ? 12 : 8;
    int total = active_count * width + (active_count ? active_count - 1 : 0) * gap;
    int left = 400 - total / 2;
    lv_obj_set_hidden(input_port, active_count >= 4);
    lv_obj_set_hidden(output_port, active_count >= 4);
    for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal) {
        int index = board_index(pedal);
        if(index < 0) {
            lv_obj_set_hidden(tiles[pedal], true);
            continue;
        }
        lv_obj_set_hidden(tiles[pedal], false);
        lv_obj_set_pos(tiles[pedal], left + index * (width + gap), 169);
        lv_obj_set_size(tiles[pedal], width, 100);
        lv_obj_set_width(tile_titles[pedal], width - 16);
        lv_obj_set_style_text_font(tile_titles[pedal], active_count >= 6 ? &lv_font_montserrat_12 : &lv_font_montserrat_14, 0);
        lv_obj_set_style_bg_color(tiles[pedal], color(bypassed[pedal] ? C_CARD : pedal_bodies[pedal]), 0);
        static const char *compact_details[PEDAL_COUNT] = {"DRIVE", "CLIP", "ECHO", "PULSE", "SWIRL", "PEAKS", "PITCH"};
        lv_label_set_text(tile_details[pedal], active_count >= 6 ? compact_details[pedal] : pedal_details[pedal]);
        lv_obj_set_style_text_font(tile_details[pedal], active_count >= 6 ? &lv_font_montserrat_12 : &lv_font_montserrat_14, 0);
        lv_obj_set_pos(gear_buttons[pedal], width - 38, 62);
        lv_obj_set_size(gear_buttons[pedal], 30, 30);
        lv_obj_set_pos(led_buttons[pedal], width - 38, 2);
        lv_obj_set_style_bg_color(tile_leds[pedal], color(bypassed[pedal] ? C_MUTED : pedal_colors[pedal]), 0);
        lv_obj_set_style_shadow_opa(tile_leds[pedal], bypassed[pedal] ? LV_OPA_TRANSP : LV_OPA_30, 0);
        lv_obj_set_width(tile_details[pedal], width - 48);
    }

    lv_obj_set_style_bg_color(mode_button, color(enabled ? C_ACCENT : C_TILE), 0);
    lv_label_set_text(mode_button_label, enabled ? "SIGNAL ON" : "BYPASSED");
    lv_obj_set_style_text_color(mode_button_label, color(enabled ? C_BG : C_TEXT), 0);
    lv_label_set_text_fmt(amount_label, "MIX  %d%%", amount);
    lv_slider_set_value(slider, amount, LV_ANIM_OFF);
}

static void bypass_clicked(lv_event_t *event)
{
    int pedal = (int)(intptr_t)lv_event_get_user_data(event);
    bypassed[pedal] = !bypassed[pedal];
    if(live_mode) {
        char request[80], reply[32768];
        snprintf(request, sizeof(request), "bypass %s %s", pedal_names[pedal], bypassed[pedal] ? "on" : "off");
        if(!command(request, reply, sizeof(reply)) || !read_state()) show_status("COULD NOT CHANGE BYPASS", C_GOLD);
    }
    render_board();
}

static void exit_clicked(lv_event_t *event) { (void)event; ui_running = false; }

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
        int col = pedal % 3;
        int row = pedal / 3;
        lv_obj_t * button = box(panel, 28 + col * 188, 93 + row * 88, 178, 72,
                                board_index(pedal) >= 0 ? C_TILE : pedal_bodies[pedal], 10);
        lv_obj_set_style_border_color(button, color(pedal_colors[pedal]), 0);
        lv_obj_set_style_border_width(button, 1, 0);
        box(button, 0, 0, 5, 72, pedal_colors[pedal], 2);
        lv_obj_set_clickable(button, true);
        lv_obj_add_event_cb(button, library_select, LV_EVENT_CLICKED, (void *)(intptr_t)pedal);
        lv_obj_t *title = button_label(button, pedal_titles[pedal], &lv_font_montserrat_16, pedal_colors[pedal]);
        lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 14);
        lv_obj_t *detail = button_label(button, board_index(pedal) >= 0 ? "ON BOARD" : pedal_details[pedal],
                                       &lv_font_montserrat_12, C_MUTED);
        lv_obj_align(detail, LV_ALIGN_BOTTOM_MID, 0, -13);
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
    if(parameter == PITCH) return value < .75f ? -1 : value > 1.5f ? 1 : 0;
    int scale = parameter == RATE ? 10 :
                parameter == MIX || parameter == LEVEL || parameter == FEEDBACK || parameter == DEPTH ? 100 : 1;
    return (int)lroundf(value * scale);
}

static void format_config_value(int parameter, int value, char * text, size_t size)
{
    if(parameter == PITCH) snprintf(text, size, "%s", value < 0 ? "DOWN" : value > 0 ? "UP" : "NORMAL");
    else if(parameter == TONE) snprintf(text, size, "%d Hz", value);
    else if(parameter == TIME || parameter == RELEASE) snprintf(text, size, "%d ms", value);
    else if(parameter == CEILING) snprintf(text, size, "%d dB", value);
    else if(parameter == RATE) snprintf(text, size, "%.1f Hz", value / 10.0f);
    else if(parameter == DRIVE) snprintf(text, size, "%dx", value);
    else snprintf(text, size, "%d%%", value);
}

static void config_changed(lv_event_t * event)
{
    int parameter = (int)(intptr_t)lv_event_get_user_data(event);
    if(config_pedal < 0) return;
    int value = lv_slider_get_value(config_sliders[parameter]);
    settings[config_pedal][parameter] = parameter == PITCH ? (value < 0 ? .5f : value > 0 ? 2.0f : 1.0f) : parameter == RATE ? value / 10.0f :
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
    label(panel, pedal == LIMITER ? "Instant attack / no lookahead / place last for peak control" :
          "Adjust this pedal independently", 28, 53, &lv_font_montserrat_14, C_MUTED);
    lv_obj_t * close = box(panel, 541, 16, 44, 44, C_TILE, 10);
    lv_obj_set_clickable(close, true);
    lv_obj_add_event_cb(close, config_close, LV_EVENT_CLICKED, NULL);
    lv_obj_t * close_icon = label(close, LV_SYMBOL_CLOSE, 0, 0, &lv_font_montserrat_20, C_TEXT);
    lv_obj_center(close_icon);

    const char * titles[PARAMETER_COUNT] = {"DRIVE", "TONE", "MIX", "LEVEL", "TIME", "FEEDBACK", "RATE", "DEPTH", "OCTAVE", "CEILING", "RELEASE"};
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
        if(parameter == PITCH) { minimum = -1; maximum = 1; }
        if(parameter == CEILING) { minimum = -36; maximum = 0; }
        if(parameter == RELEASE) { minimum = 5; maximum = 1000; }
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

static void audio_refresh(void)
{
    json_object *state = audio_settings_read();
    bool available = live_mode && json_object_get_boolean(json_object_object_get(state, "available"));
    for(int i = 0; i < 2; ++i) {
        if(available) lv_obj_remove_state(audio_sliders[i], LV_STATE_DISABLED);
        else lv_obj_add_state(audio_sliders[i], LV_STATE_DISABLED);
        if(!available || lv_obj_has_state(audio_sliders[i], LV_STATE_PRESSED)) continue;
        int value = (int)lround(json_object_get_double(json_object_object_get(state, i ? "input_gain_db" : "volume_db")));
        lv_slider_set_value(audio_sliders[i], value, LV_ANIM_OFF);
        lv_label_set_text_fmt(audio_values[i], "%+d dB", value);
    }
    if(available) {
        lv_obj_remove_state(audio_mute, LV_STATE_DISABLED);
        output_muted = json_object_get_boolean(json_object_object_get(state, "muted"));
        lv_label_set_text(audio_mute_label, output_muted ? "OUTPUT MUTED" : "OUTPUT ON");
        lv_obj_set_style_text_color(audio_mute_label, color(output_muted ? C_GOLD : C_ACCENT), 0);
        unsigned rate = (unsigned)json_object_get_int(json_object_object_get(state, "rate"));
        int period = json_object_get_int(json_object_object_get(state, "period_frames"));
        int buffer = json_object_get_int(json_object_object_get(state, "buffer_frames"));
        lv_label_set_text_fmt(audio_info, "%u Hz  /  %d frame periods  /  %d frame ring", rate, period, buffer);
        const char *bias = json_object_get_string(json_object_object_get(state, "mic_bias"));
        lv_label_set_text_fmt(audio_inputs, "I2C control  /  I2S audio  /  %s", bias ? bias : "Bias status unavailable");
        lv_label_set_text(audio_status, "CHANGES SAVE AUTOMATICALLY");
    } else {
        lv_obj_add_state(audio_mute, LV_STATE_DISABLED);
        lv_label_set_text(audio_info, "ADAC hardware controls require the connected Pi");
        lv_label_set_text(audio_inputs, "Output: -60 to 0 dB  /  Input gain: -12 to +32 dB");
        lv_label_set_text(audio_status, live_mode ? "ADAC INTERFACE UNAVAILABLE" : "PREVIEW  /  HARDWARE CONTROLS DISABLED");
    }
    json_object_put(state);
}

static void audio_changed(lv_event_t *event)
{
    int index = (int)(intptr_t)lv_event_get_user_data(event);
    lv_label_set_text_fmt(audio_values[index], "%+d dB", (int)lv_slider_get_value(audio_sliders[index]));
}

static void audio_apply(lv_event_t *event)
{
    if(!live_mode) return;
    int index = (int)(intptr_t)lv_event_get_user_data(event);
    json_object *settings = json_object_new_object();
    if(index == 2) json_object_object_add(settings, "muted", json_object_new_boolean(!output_muted));
    else json_object_object_add(settings, index ? "input_gain_db" : "volume_db",
                                json_object_new_int(lv_slider_get_value(audio_sliders[index])));
    char error[200];
    bool ok = audio_settings_apply(settings, error, sizeof(error));
    json_object_put(settings);
    audio_refresh();
    if(!ok) lv_label_set_text(audio_status, error);
}

static void audio_close(lv_event_t *event)
{
    (void)event;
    lv_obj_delete_async(audio_overlay);
    audio_overlay = NULL;
}

static void audio_open(lv_event_t *event)
{
    (void)event;
    if(audio_overlay) return;
    audio_overlay = box(lv_screen_active(), 0, 0, WIDTH, HEIGHT, C_BG, 0);
    lv_obj_set_style_bg_opa(audio_overlay, LV_OPA_80, 0);
    lv_obj_t *panel = box(audio_overlay, 94, 45, 612, 390, C_CARD, 20);
    label(panel, "AUDIO  /  HIFIBERRY ADAC", 28, 22, &lv_font_montserrat_20, C_ACCENT);
    label(panel, "Hardware levels before and after the pedal chain", 28, 54, &lv_font_montserrat_14, C_MUTED);
    lv_obj_t *close = box(panel, 541, 16, 44, 44, C_TILE, 10);
    lv_obj_set_clickable(close, true);
    lv_obj_add_event_cb(close, audio_close, LV_EVENT_CLICKED, NULL);
    lv_obj_t *icon = label(close, LV_SYMBOL_CLOSE, 0, 0, &lv_font_montserrat_20, C_TEXT);
    lv_obj_center(icon);
    for(int i = 0; i < 2; ++i) {
        int y = 108 + i * 76;
        label(panel, i ? "INPUT GAIN" : "OUTPUT LEVEL", 30, y, &lv_font_montserrat_14, C_TEXT);
        audio_sliders[i] = lv_slider_create(panel);
        lv_obj_set_pos(audio_sliders[i], 190, y + 10);
        lv_obj_set_size(audio_sliders[i], 280, 8);
        lv_slider_set_range(audio_sliders[i], i ? -12 : -60, i ? 32 : 0);
        lv_obj_set_style_bg_color(audio_sliders[i], color(C_LINE), LV_PART_MAIN);
        lv_obj_set_style_bg_color(audio_sliders[i], color(C_ACCENT), LV_PART_INDICATOR);
        lv_obj_set_style_bg_color(audio_sliders[i], color(C_ACCENT), LV_PART_KNOB);
        lv_obj_set_style_pad_all(audio_sliders[i], 10, LV_PART_KNOB);
        lv_obj_add_event_cb(audio_sliders[i], audio_changed, LV_EVENT_VALUE_CHANGED, (void *)(intptr_t)i);
        lv_obj_add_event_cb(audio_sliders[i], audio_apply, LV_EVENT_RELEASED, (void *)(intptr_t)i);
        audio_values[i] = label(panel, "-- dB", 495, y - 3, &lv_font_montserrat_14, C_MUTED);
    }
    audio_mute = box(panel, 30, 241, 238, 44, C_TILE, 10);
    lv_obj_set_clickable(audio_mute, true);
    lv_obj_add_event_cb(audio_mute, audio_apply, LV_EVENT_CLICKED, (void *)(intptr_t)2);
    audio_mute_label = button_label(audio_mute, "OUTPUT ON", &lv_font_montserrat_14, C_ACCENT);
    label(panel, "Gain applies before effects", 288, 255, &lv_font_montserrat_14, C_MUTED);
    audio_info = label(panel, "", 30, 305, &lv_font_montserrat_14, C_TEXT);
    audio_inputs = label(panel, "", 30, 329, &lv_font_montserrat_14, C_MUTED);
    audio_status = label(panel, "", 30, 359, &lv_font_montserrat_14, C_MUTED);
    lv_obj_set_width(audio_status, 552);
    lv_label_set_long_mode(audio_status, LV_LABEL_LONG_DOT);
    audio_refresh();
}

static void tuner_render(bool connected)
{
    bool tracking = connected && tuner_enabled && tuner_has_note;
    uint32_t fg = tracking && fabs(tuner_cents) <= 5 ? C_ACCENT : C_TEXT;
    lv_label_set_text(tuner_note_label, tracking ? tuner_note : "--");
    lv_obj_set_style_text_color(tuner_note_label, color(fg), 0);
    if(tracking) {
        lv_label_set_text_fmt(tuner_frequency_label, "%.1f Hz", tuner_frequency);
        lv_label_set_text_fmt(tuner_cents_label, "%+.1f cents  /  %s", tuner_cents,
                              fabs(tuner_cents) <= 5 ? "IN TUNE" : tuner_cents < 0 ? "TUNE UP" : "TUNE DOWN");
    } else {
        lv_label_set_text(tuner_frequency_label, !connected ? "Pedal disconnected" :
                          tuner_enabled ? "Play a single note" : "Pitch tracking paused");
        lv_label_set_text(tuner_cents_label, "A4 = 440 Hz");
    }
    lv_obj_set_hidden(tuner_needle, !tracking);
    lv_obj_set_x(tuner_needle, 268 + (int)lround(fmax(-50, fmin(50, tuner_cents)) * 4.8));
    lv_label_set_text(tuner_toggle_label, tuner_enabled ? "TRACKING ON" : "TRACKING OFF");
}

static void tuner_tick(lv_timer_t *timer)
{
    (void)timer;
    if(tuner_overlay) tuner_render(!live_mode || read_state());
}

static void tuner_close(lv_event_t *event)
{
    (void)event;
    lv_obj_delete_async(tuner_overlay);
    tuner_overlay = NULL;
    refresh_state(NULL);
}

static void tuner_toggle(lv_event_t *event)
{
    (void)event;
    if(live_mode) {
        char reply[32768];
        if(!command(tuner_enabled ? "tuner off" : "tuner on", reply, sizeof(reply))) {
            tuner_render(false);
            return;
        }
    } else tuner_enabled = !tuner_enabled;
    tuner_tick(NULL);
}

static void tuner_open(lv_event_t *event)
{
    (void)event;
    if(tuner_overlay) return;
    tuner_overlay = box(lv_screen_active(), 0, 0, WIDTH, HEIGHT, C_BG, 0);
    lv_obj_set_style_bg_opa(tuner_overlay, LV_OPA_80, 0);
    lv_obj_t *panel = box(tuner_overlay, 94, 45, 612, 390, C_CARD, 20);
    label(panel, "TUNER", 28, 22, &lv_font_montserrat_20, C_ACCENT);
    label(panel, "Clean input / audio continues while tuning", 28, 53, &lv_font_montserrat_14, C_MUTED);
    lv_obj_t *close = box(panel, 541, 16, 44, 44, C_TILE, 10);
    lv_obj_set_clickable(close, true);
    lv_obj_add_event_cb(close, tuner_close, LV_EVENT_CLICKED, NULL);
    button_label(close, LV_SYMBOL_CLOSE, &lv_font_montserrat_20, C_TEXT);
    tuner_note_label = button_label(panel, "--", &lv_font_montserrat_36, C_TEXT);
    lv_obj_align(tuner_note_label, LV_ALIGN_TOP_MID, 0, 101);
    tuner_frequency_label = button_label(panel, "Play a single note", &lv_font_montserrat_20, C_MUTED);
    lv_obj_align(tuner_frequency_label, LV_ALIGN_TOP_MID, 0, 159);
    lv_obj_t *scale = box(panel, 36, 222, 540, 32, C_CARD, 0);
    box(scale, 28, 13, 484, 6, C_LINE, 3);
    box(scale, 246, 13, 48, 6, C_ACCENT, 3);
    box(scale, 269, 3, 2, 26, C_TEXT, 0);
    label(scale, "-", 2, 5, &lv_font_montserrat_20, C_GOLD);
    label(scale, "+", 522, 5, &lv_font_montserrat_20, C_GOLD);
    tuner_needle = box(scale, 268, 0, 4, 32, C_GOLD, 2);
    tuner_cents_label = button_label(panel, "A4 = 440 Hz", &lv_font_montserrat_16, C_TEXT);
    lv_obj_align(tuner_cents_label, LV_ALIGN_TOP_MID, 0, 274);
    lv_obj_t *toggle = box(panel, 190, 323, 232, 44, C_TILE, 10);
    lv_obj_set_clickable(toggle, true);
    lv_obj_add_event_cb(toggle, tuner_toggle, LV_EVENT_CLICKED, NULL);
    tuner_toggle_label = button_label(toggle, "TRACKING ON", &lv_font_montserrat_14, C_ACCENT);
    tuner_tick(NULL);
}

static void refresh_state(lv_timer_t * timer)
{
    (void)timer;
    if(!live_mode || dragging >= 0 || config_overlay || library_overlay || audio_overlay || tuner_overlay) return;
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

    lv_obj_t *logo = box(screen, 24, 20, 42, 42, C_ACCENT, 12);
    static const lv_point_precise_t waveform[] = {{7, 22}, {13, 22}, {17, 11}, {23, 31}, {28, 18}, {35, 18}};
    lv_obj_t *wave = lv_line_create(logo);
    lv_line_set_points(wave, waveform, 6);
    lv_obj_set_style_line_color(wave, color(C_BG), 0);
    lv_obj_set_style_line_width(wave, 3, 0);
    lv_obj_set_style_line_rounded(wave, true, 0);
    label(screen, "RIFFLINE", 80, 22, &lv_font_montserrat_20, C_TEXT);
    label(screen, "YOUR TONE, CONNECTED", 80, 47, &lv_font_montserrat_12, C_MUTED);
    lv_obj_t *tuner_button = box(screen, 494, 20, 96, 42, C_TILE, 10);
    lv_obj_set_clickable(tuner_button, true);
    lv_obj_add_event_cb(tuner_button, tuner_open, LV_EVENT_CLICKED, NULL);
    button_label(tuner_button, "TUNER", &lv_font_montserrat_14, C_ACCENT);
    lv_obj_t *audio_button = box(screen, 602, 20, 96, 42, C_TILE, 10);
    lv_obj_set_clickable(audio_button, true);
    lv_obj_add_event_cb(audio_button, audio_open, LV_EVENT_CLICKED, NULL);
    button_label(audio_button, "AUDIO", &lv_font_montserrat_14, C_ACCENT);
    lv_obj_t *exit_button = box(screen, 710, 20, 66, 42, C_TILE, 10);
    lv_obj_set_clickable(exit_button, true);
    lv_obj_add_event_cb(exit_button, exit_clicked, LV_EVENT_CLICKED, NULL);
    button_label(exit_button, "EXIT", &lv_font_montserrat_14, C_TEXT);
    box(screen, 24, 75, 752, 1, C_LINE, 0);

    box(screen, 24, 90, 752, 229, C_CARD, 20);
    label(screen, "01  /  PEDAL BOARD", 47, 108, &lv_font_montserrat_14, C_ACCENT);
    path_label = label(screen, "INPUT  >  OVERDRIVE  >  OUTPUT", 47, 133, &lv_font_montserrat_14, C_MUTED);
    lv_obj_set_width(path_label, 706);
    lv_obj_set_height(path_label, 18);
    lv_label_set_long_mode(path_label, LV_LABEL_LONG_DOT);
    box(screen, 98, 216, 602, 3, C_LINE, 2);
    input_port = box(screen, 46, 185, 76, 65, C_TILE, 13);
    button_label(input_port, "IN", &lv_font_montserrat_20, C_ACCENT);
    output_port = box(screen, 681, 185, 70, 65, C_TILE, 13);
    button_label(output_port, "OUT", &lv_font_montserrat_20, C_ACCENT);
    label(screen, "DRAG TO REORDER  /  DRAG DOWN TO REMOVE", 47, 283, &lv_font_montserrat_14, C_MUTED);

    box(screen, 24, 332, 521, 124, C_CARD, 18);
    label(screen, "02  /  PEDAL LIBRARY", 47, 344, &lv_font_montserrat_14, C_MUTED);
    lv_obj_t * library_button = box(screen, 47, 373, 473, 61, C_TILE, 12);
    lv_obj_set_clickable(library_button, true);
    lv_obj_add_event_cb(library_button, library_open, LV_EVENT_CLICKED, NULL);
    button_label(library_button, "OPEN LIBRARY  +", &lv_font_montserrat_20, C_ACCENT);
    box(screen, 560, 332, 216, 124, C_CARD, 18);
    mode_button = box(screen, 575, 344, 186, 47, C_ACCENT, 11);
    lv_obj_set_clickable(mode_button, true);
    lv_obj_add_event_cb(mode_button, mode_clicked, LV_EVENT_CLICKED, NULL);
    mode_button_label = button_label(mode_button, "SIGNAL ON", &lv_font_montserrat_20, C_BG);
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
        tile_titles[pedal] = label(tiles[pedal], pedal_titles[pedal], 8, 36, &lv_font_montserrat_14, C_TEXT);
        lv_label_set_long_mode(tile_titles[pedal], LV_LABEL_LONG_DOT);
        tile_details[pedal] = label(tiles[pedal], pedal_details[pedal], 8, 68, &lv_font_montserrat_14, C_MUTED);
        lv_label_set_long_mode(tile_details[pedal], LV_LABEL_LONG_DOT);
        lv_obj_set_height(tile_details[pedal], 18);
        led_buttons[pedal] = box(tiles[pedal], 122, 2, 36, 34, pedal_bodies[pedal], 8);
        lv_obj_set_style_bg_opa(led_buttons[pedal], LV_OPA_TRANSP, 0);
        lv_obj_set_clickable(led_buttons[pedal], true);
        lv_obj_add_event_cb(led_buttons[pedal], bypass_clicked, LV_EVENT_CLICKED, (void *)(intptr_t)pedal);
        tile_leds[pedal] = box(led_buttons[pedal], 13, 12, 10, 10, pedal_colors[pedal], 5);
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
    bool fullscreen = false;
    bool self_test = false;
    bool show_audio = false;
    bool show_tuner = false;
    for(int i = 1; i < argc; ++i) {
        if(strcmp(argv[i], "--live") == 0) live_mode = true;
        else if(strcmp(argv[i], "--fullscreen") == 0) fullscreen = true;
        else if(strcmp(argv[i], "--self-test") == 0) self_test = true;
        else if(strcmp(argv[i], "--audio-settings") == 0) show_audio = true;
        else if(strcmp(argv[i], "--tuner") == 0) show_tuner = true;
        else { fprintf(stderr, "Usage: %s [--live] [--fullscreen] [--audio-settings | --tuner]\n", argv[0]); return 2; }
    }
    lv_init();
    lv_display_t * display = lv_sdl_window_create(WIDTH, HEIGHT);
    if(!display) {
        fprintf(stderr, "Could not open an SDL window. Is a graphical desktop running?\n");
        return 1;
    }
    lv_sdl_window_set_title(display, "Riffline — Guitar pedal board");
    if(fullscreen && SDL_SetWindowFullscreen(lv_sdl_window_get_window(display), SDL_WINDOW_FULLSCREEN_DESKTOP) != 0) {
        fprintf(stderr, "Fullscreen: %s\n", SDL_GetError()); return 1;
    }
    lv_sdl_mouse_create();
    lv_sdl_keyboard_create();
    build_ui();
    if(live_mode) refresh_state(NULL);
    if(show_audio) audio_open(NULL);
    else if(show_tuner) tuner_open(NULL);
    lv_timer_create(tuner_tick, 200, NULL);
    if(live_mode) {
        lv_timer_create(refresh_state, 1000, NULL);
    }
    if(self_test) {
        if(!live_mode || !read_state() || view_only || active_count != PEDAL_COUNT) return 3;
        render_board();
        lv_obj_update_layout(lv_screen_active());
        for(int pedal = 0; pedal < PEDAL_COUNT; ++pedal)
            if(lv_obj_get_x(tiles[pedal]) < 24 || lv_obj_get_x(tiles[pedal])+lv_obj_get_width(tiles[pedal]) > 776) return 4;
        bool original_bypass = bypassed[OCTAVE];
        lv_obj_send_event(led_buttons[OCTAVE], LV_EVENT_CLICKED, NULL);
        if(!read_state() || bypassed[OCTAVE] == original_bypass) return 5;
        lv_obj_send_event(led_buttons[OCTAVE], LV_EVENT_CLICKED, NULL);
        lv_obj_send_event(gear_buttons[OCTAVE], LV_EVENT_CLICKED, NULL);
        lv_slider_set_value(config_sliders[PITCH], 1, LV_ANIM_OFF);
        lv_obj_send_event(config_sliders[PITCH], LV_EVENT_VALUE_CHANGED, NULL);
        lv_obj_send_event(config_sliders[PITCH], LV_EVENT_RELEASED, NULL);
        if(!read_state() || settings[OCTAVE][PITCH] != 2.0f) return 6;
        lv_slider_set_value(config_sliders[PITCH], -1, LV_ANIM_OFF);
        lv_obj_send_event(config_sliders[PITCH], LV_EVENT_VALUE_CHANGED, NULL);
        lv_obj_send_event(config_sliders[PITCH], LV_EVENT_RELEASED, NULL);
        if(!read_state() || settings[OCTAVE][PITCH] != .5f) return 7;
        config_close(NULL);
        lv_timer_handler();
        lv_obj_send_event(gear_buttons[LIMITER], LV_EVENT_CLICKED, NULL);
        lv_slider_set_value(config_sliders[CEILING], -6, LV_ANIM_OFF);
        lv_obj_send_event(config_sliders[CEILING], LV_EVENT_VALUE_CHANGED, NULL);
        lv_obj_send_event(config_sliders[CEILING], LV_EVENT_RELEASED, NULL);
        if(!read_state() || settings[LIMITER][CEILING] != -6.0f) return 8;
        config_close(NULL);
        lv_timer_handler();
        tuner_open(NULL);
        bool original_tracking = tuner_enabled;
        tuner_toggle(NULL);
        if(tuner_enabled == original_tracking) return 9;
        tuner_toggle(NULL);
        if(tuner_enabled != original_tracking || active_count != PEDAL_COUNT) return 10;
        tuner_has_note = true;
        strcpy(tuner_note, "A4"); tuner_frequency = 440; tuner_cents = 0;
        tuner_render(true);
        lv_obj_update_layout(lv_screen_active());
        if(strcmp(lv_label_get_text(tuner_note_label), "A4") != 0 || lv_obj_get_x(tuner_needle) != 268) return 11;
        tuner_close(NULL);
        lv_timer_handler();
        puts("Native seven-pedal layout, bypass, octave, limiter and tuner controls passed.");
        lv_deinit();
        return 0;
    }
    while(ui_running) {
        uint32_t delay = lv_timer_handler();
        if(SDL_GetKeyboardState(NULL)[SDL_SCANCODE_ESCAPE]) break;
        lv_sleep_ms(delay > 20 ? 20 : delay);
    }
    lv_deinit();
    return 0;
}
